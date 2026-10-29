---
title: "Setting up Redis"
description: Set up Redis for caching, sessions and request throttling, using the Docker scripts or installing through apt.
---

From version _1.19.0_, FAIRDOM-SEEK requires [Redis](https://redis.io/), which needs to be set up separately. SEEK uses
a single Redis instance for:

* the Rails cache. Large items overflow to the filesystem cache instead (see [Cache item size](#cache-item-size)).
* user sessions.
* the request throttling counters used to protect against excessive traffic.

SEEK is tested with Redis 8.6, which is the version used by the Docker scripts and Docker Compose.

## Docker Compose

If you run SEEK with [Docker Compose](docker/docker-compose), the
[docker-compose.yml](https://github.com/seek4science/seek/blob/seek-{{ site.current_docker_tag }}/docker-compose.yml)
has been updated to include a `redis_store` service, so you don't need to install Redis separately. When installing or
upgrading, you need:

* the updated _docker-compose.yml_
* the new [docker/redis.env](https://github.com/seek4science/seek/blob/seek-{{ site.current_docker_tag }}/docker/redis.env)
  file. Change the `REDIS_PASSWORD` value from the default before starting.
* a new volume for the Redis data:

```bash
docker volume create --name=seek-redis-data
```

The settings in _docker/redis.env_ are used by both the Redis container and the SEEK containers, so the password only
needs setting in that one place. See [Configuration options](#configuration-options) for what each setting does.

The rest of this page covers installations that don't use Docker Compose.

## Using the Docker scripts

A convenient way to run Redis for a bare-metal installation is with the official _redis:8.6-alpine_ Docker image. You
first need to have [Docker installed](docker/docker-install). We provide scripts for managing the Redis service, which
should be run from the root directory of your SEEK installation:

  * [script/start-docker-redis.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/start-docker-redis.sh)
    * Creates and starts the container, and creates the data volume if it doesn't already exist. Waits until Redis is ready before returning.
  * [script/stop-docker-redis.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/stop-docker-redis.sh)
    * Stops and removes the container. The data volume is kept.
  * [script/reset-docker-redis.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/reset-docker-redis.sh)
    * Stops and removes the container, deletes and recreates the data volume, and starts Redis again. This clears the cache **and all sessions**, so logged-in users will be signed out.
  * [script/delete-docker-redis.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/delete-docker-redis.sh)
    * Removes both the container and the data volume entirely. The container must be stopped first.

e.g. to start:

```bash
sh ./script/start-docker-redis.sh
```

The Docker container is named _seek-redis_ and the volume is named _seek-redis-data-volume_. The container is
restarted automatically when Docker restarts.

The memory limit defaults to 256 MB. You can change it by setting `REDIS_MAXMEMORY` when starting the container:

```bash
REDIS_MAXMEMORY=512mb sh ./script/start-docker-redis.sh
```

To require a password, set `REDIS_PASSWORD` when starting the container:

```bash
REDIS_PASSWORD=your-redis-password sh ./script/start-docker-redis.sh
```

SEEK also needs to be given the same password, as described in [Configuration options](#configuration-options). The
password is set when the container is created, so it also needs to be given when running
_script/reset-docker-redis.sh_, which recreates the container. To change the password, stop the container and start it
again with the new one.

{% include callout.html type="warning" content="The script publishes port 6379 on all network interfaces. We strongly recommend setting a password, and making sure port 6379 is blocked by your firewall, so that Redis can't be reached from outside the server. Note that Docker's port publishing can bypass firewall rules set with tools such as `ufw`." %}

The script doesn't support TLS, so leave `REDIS_TLS` unset when using it. TLS isn't needed, since SEEK connects to the
container on the same machine.

## Installing Redis through apt

The following steps are for Ubuntu 24.04 but should be the same for other Debian-based distributions.

SEEK needs Redis 7.0 or later. You can either use the version provided by your distribution, or install a newer
version from the official Redis apt repository.

### Using the distribution's package

Ubuntu 24.04 provides Redis 7.0, which works with SEEK, so you can simply install it with:

```bash
sudo apt-get update
sudo apt-get install redis-server redis-tools
```

The Redis project no longer supports 7.0. Ubuntu packages it in the community-maintained _universe_ repository, so
security updates aren't guaranteed. The official repository described below is preferable for a production server.

{% include callout.html type="warning" content="Ubuntu 22.04 provides Redis 6.0, which is too old for SEEK. If you are using Ubuntu 22.04, install Redis from the official repository instead, or use the Docker scripts." %}

### Using the official Redis repository

These steps follow the
[Redis installation guide](https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/apt/) and install
the same version that SEEK uses with Docker.

Add the repository:

```bash
sudo apt-get install lsb-release curl gpg
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
```

Optionally, pin Redis to the 8.6 releases so that an `apt upgrade` doesn't move you to a new major version unexpectedly:

```bash
sudo tee /etc/apt/preferences.d/redis-8.6 <<EOF
Package: redis redis-server redis-sentinel redis-tools
Pin: version 6:8.6.*
Pin-Priority: 1001
EOF
```

Then install Redis:

```bash
sudo apt-get update
sudo apt-get install redis-server redis-tools
```

### Starting Redis

Whichever version you installed, enable and start the service:

```bash
sudo systemctl enable redis-server
sudo systemctl start redis-server
```

Check that it's running with:

```bash
redis-cli ping
```

which should respond with `PONG`.

### Configuring the Redis server

Redis is configured in _/etc/redis/redis.conf_. We recommend setting the following, to match the Docker setup:

```
maxmemory 256mb
maxmemory-policy allkeys-lru
appendonly yes
```

* `maxmemory` limits how much memory Redis uses. Increase it for a busy instance.
* `maxmemory-policy allkeys-lru` makes Redis discard the least recently used keys when the limit is reached, instead
  of refusing writes.
* `appendonly yes` logs every change to disk, so that little or nothing (including sessions) is lost if Redis
  restarts.

By default the packaged Redis only listens on localhost (`bind 127.0.0.1 -::1`), which is what you want when Redis
runs on the same machine as SEEK. To also require a password, set:

```
requirepass your-redis-password
```

Then restart Redis:

```bash
sudo systemctl restart redis-server
```

If you set a password, you also need to give it to SEEK with `REDIS_PASSWORD`, as described below. You can check the
password works with `redis-cli -a your-redis-password ping`.

## Configuration options

The following environment variables are used, and are all optional:

| Variable | Default | Description |
|---|---|---|
| `REDIS_HOST` | `localhost` | The hostname or IP address of the Redis server. |
| `REDIS_PASSWORD` | _(none)_ | The password, or token, needed to connect to Redis. Leave unset if Redis doesn't require one. |
| `REDIS_TLS` | _(off)_ | Set to `true`, `yes` or `1` to connect using TLS. |
| `REDIS_MAXMEMORY` | `256mb` | Only used by the Docker scripts and Docker Compose, to set the Redis memory limit. |

SEEK always connects on port 6379, and uses database 0.

For a bare-metal installation, the simplest way to set these is to create a _.env.local_ file in the root directory
of your SEEK installation, which is read automatically when SEEK starts and is ignored by git. For example:

```
REDIS_HOST=localhost
REDIS_PASSWORD=your-redis-password
```

Because it is read by SEEK itself, the settings also apply to the background workers and rake tasks. Restart SEEK and
the workers after changing it.

For Docker Compose, these are set in _docker/redis.env_ instead, but only `REDIS_PASSWORD` and `REDIS_MAXMEMORY`
should be changed. `REDIS_HOST` must stay as `redis_store`, the name of the Redis service, and `REDIS_TLS` must be left
unset, since the Redis service doesn't support TLS.

### Password or token

If `REDIS_PASSWORD` is set, SEEK authenticates with it when connecting. This works with Redis' `requirepass` setting,
and with hosted services that give you an authentication token, such as AWS ElastiCache, where the token is used as
the password. Special characters in the password, such as `@`, `:` and `/`, are handled.

If you use Redis ACL users rather than `requirepass`, the password must belong to the `default` user, since SEEK
doesn't support setting a username.

### TLS

Setting `REDIS_TLS=true` makes SEEK use an encrypted TLS connection (a `rediss://` connection rather than
`redis://`). This is needed for servers that only accept TLS connections, such as AWS ElastiCache with in-transit
encryption enabled, and is recommended whenever Redis runs on a different machine from SEEK. The server's certificate
needs to be one that the SEEK server trusts.

TLS is off by default, which is fine when Redis is on the same machine or private Docker network as SEEK.

## Cache item size

Small cache items are stored in Redis, and items larger than 1 MB are stored on the filesystem cache instead (in
_tmp/cache_). You can change this limit in the SEEK admin pages in _Server admin_, under _General > Settings_, using
_Maximum Redis cache item size_ (in KB). Setting it to 0 turns off Redis caching, so all cache items go to the
filesystem. Sessions and throttling still use Redis.

## Monitoring memory use

Cache items and sessions share the same Redis memory. If Redis reaches its `maxmemory` limit it starts evicting the
least recently used keys, and these can include sessions, which would sign users out. You can see how much memory is
used, and how many keys have been evicted, under _Server admin > Status and statistics > Redis cache_. The same
statistics are also written to the log daily. If the number of evicted keys keeps rising, increase `maxmemory`.

## Clearing the cache

To clear the cache, run:

```bash
bundle exec rake seek:clear_cache
```

This clears both the Redis and filesystem parts of the cache, along with SEEK's settings cache. `rake tmp:cache:clear`
only clears the filesystem overflow cache, not Redis. Clearing the cache doesn't remove sessions, so users stay logged in.
