---
title: Upgrade guide MySQL 8.0 to 8.4 for docker compose deployments
---

Starting from [SEEK 1.18.0](https://docs.seek4science.org/tech/releases/#version-1180), we highly recommend upgrading the MySQL database from version 8.0 to the next LTS version, 8.4. MySQL 8.0 reached end-of-life status April 21st 2026, with the last released version being 8.0.46 (see [release notes](https://dev.mysql.com/doc/relnotes/mysql/8.0/en/)). MySQL server will not receive security fixes anymore. This guide provides detailed instructions for upgrading MySQL from version 8.0 to 8.4 in a docker-compose deployment.

Bare-metal installations on ubuntu will still get security fixes backported as part of the Extended Security Maintenance programme. Although most of the docker-compose procedure can be translated to bare-metal deployments, it will not be covered in detail in this guide.

## Critical Breaking Changes in MySQL 8.4

The new LTS release has a couple of breaking changes, cited here below. The first two will apply to all older databases (created in MySQL < v8.0) and should be read carefully! The remaining changes could impact you, depending on your setup and usage of MySQL, or are simply less impactful.

### 1. **Removal of `default_authentication_plugin` Variable** (CRITICAL)

**What Changed:**

- The `default_authentication_plugin` system variable has been completely removed in MySQL 8.4
- The `mysql_native_password` authentication plugin is now **disabled by default**
- MySQL 8.4 uses `caching_sha2_password` as the default authentication mechanism

**Impact:**

- Any configuration files (my.cnf or Docker env vars) containing `default_authentication_plugin` will cause errors during startup (especially for older databases)
- Existing applications using `mysql_native_password` authentication will fail to connect
- The `authentication_policy` variable replaces the old plugin configuration

**Migration Path:**

- Remove all `default_authentication_plugin` settings from configuration files
- Update applications to use `caching_sha2_password` or explicitly enable `mysql_native_password` via `mysql_native_password=ON` if required
- If you must use `mysql_native_password`, enable it with the server option `--mysql-native-password=ON` or add `mysql_native_password=ON` to the `[mysqld]` section of your configuration

### 2. **Deprecation of `mysql_native_password` Plugin**

**Details:**

- The `mysql_native_password` authentication plugin is deprecated
- To enable it (for backward compatibility), you must explicitly configure it during MySQL startup
- New installations should migrate users to `caching_sha2_password`

### 3. **Restrictions on Foreign Key Constraints**

**What Changed:**

- Non-unique or partial keys cannot be used as foreign keys without explicit configuration
- The `restrict_fk_on_non_standard_key` system variable is enabled by default

**Required Action:**

- Review foreign key constraints in your database schema
- Either modify constraints to use unique keys, or explicitly disable this restriction by setting `restrict_fk_on_non_standard_key=OFF` in your configuration

### 4. **Replication Variable Renames**

These replication-related status variables have been renamed:

- `Com_slave_start` → `Com_replica_start`
- `Com_slave_stop` → `Com_replica_stop`
- `Com_show_slave_status` → `Com_show_replica_status`
- `Com_show_slave_hosts` → `Com_show_replicas`
- `Com_show_master_status` → `Com_show_binary_log_status`
- `Com_change_master` → `Com_change_replication_source`

Update any monitoring or administrative scripts that reference these variables.

### 5. **OpenSSL 3.0 Update**

MySQL 8.4 bundles OpenSSL 3.0.13. This may affect SSL/TLS connections if your applications have strict cipher or protocol requirements.

### 6. **Unsupported Upgrade Path**

Direct upgrades from MySQL 5.7 to 8.4 are not supported. You must:

1. First upgrade from 5.7 → 8.0
2. Then upgrade from 8.0 → 8.4

---

## Pre-Upgrade Checklist

Before beginning the upgrade process:

- [ ] Back up all databases and configuration files
- [ ] Document all current `default_authentication_plugin` settings
- [ ] Identify all applications and users utilizing `mysql_native_password`
- [ ] Review foreign key constraints for non-standard keys
- [ ] Test the upgrade in a staging environment
- [ ] Plan a maintenance window
- [ ] Verify disk space is sufficient (upgrade requires temporary space for binary logs and temporary tables)
- [ ] Review application database driver compatibility with MySQL 8.4

---

## Procedure

### Prerequisites

- Docker and Docker Compose installed
- Current MySQL 8.0 container is running
- Volumes are used for persistent data (not ephemeral containers)
- Access to modify `docker-compose.yml` and related configurations

### Step 1: Backup the Database Container Volume

Create a backup of the MySQL data volume before upgrading. Follow the instructions on the [docker compose section]({{ "/tech/docker/docker-compose" | relative_url }}) of the technical guide.

### Step 2: Prepare the Configuration

Update your Docker configuration to handle the breaking changes or download it from the [GitHub repository](https://github.com/seek4science/seek/tree/seek-1.18):

**For docker-compose.yml:**

```yaml
x-shared:
  seek_base: &seek_base
    # build: .
    image: fairdom/seek:1.18

    restart: always
    environment: &seek_base_env
      RAILS_ENV: production
      SOLR_PORT: 8983
      SOLR_HOST: solr
      RAILS_LOG_LEVEL: info # debug, info, warn, error or fatal
    env_file:
      - docker/db.env
    volumes:
      - seek-filestore:/seek/filestore
      - seek-cache:/seek/tmp/cache
    depends_on:
      db:
        condition: service_healthy
      solr:
        condition: service_healthy

services:
  db:
    # Database implementation, in this case MySQL
    image: mysql:8.4
    container_name: seek-mysql
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
      - --log-error-verbosity=1
      # Optional: Enable mysql_native_password if needed for legacy apps
      # - --mysql-native-password=ON
      # Optional: restrict foreign keys if needed
      # - --restrict-fk-on-non-standard-key=OFF
    restart: always
    stop_grace_period: 1m30s
    env_file:
      - docker/db.env
    volumes:
      - seek-mysql-db:/var/lib/mysql
    healthcheck:
      test:
        [
          "CMD-SHELL",
          "mysqladmin ping -h localhost -u $$MYSQL_USER -p$$MYSQL_PASSWORD --silent",
        ]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 20s

  seek:
    # The SEEK application
    <<: *seek_base
    container_name: seek
    command: docker/entrypoint.sh
    ports:
      - "3000:3000"
    environment:
      <<: *seek_base_env
      NO_ENTRYPOINT_WORKERS: 1
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/up"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 20s

  seek_workers:
    # The SEEK delayed job workers
    <<: *seek_base
    container_name: seek-workers
    environment:
      <<: *seek_base_env
      QUIET_SUPERCRONIC: 1
    command: docker/start_workers.sh
    healthcheck:
      test: ["CMD", "bash", "script/check_worker_pids.sh"]
      retries: 5

  solr:
    image: solr:8.11.4
    container_name: seek-solr
    restart: always
    environment:
      SOLR_JAVA_MEM: -Xms512m -Xmx1024m
    volumes:
      - seek-solr-data:/var/solr/
      - ./solr/seek/conf:/opt/solr/server/solr/configsets/seek_config/conf
    healthcheck:
      test: ["CMD", "curl", "-sf", "http://localhost:8983/solr/seek/admin/ping"]
      interval: 30s
      timeout: 5s
      retries: 6
      start_period: 30s
    entrypoint:
      - docker-entrypoint.sh
      - solr-precreate
      - seek
      - /opt/solr/server/solr/configsets/seek_config

volumes:
  seek-filestore:
    external: true
  seek-mysql-db:
    external: true
  seek-solr-data:
    external: true
  seek-cache:
    external: true
```

**Explanation:**

- The `image: mysql:8.4` pulls the latest MySQL 8.4 image
- `--mysql-native-password=ON` enables the deprecated plugin if needed
- `--restrict-fk-on-non-standard-key=OFF` allows the usage of non-standard foreign keys if needed

### Step 3: Pull the New MySQL 8.4 Image

Download the MySQL 8.4 Docker image:

```bash
# Pull the latest MySQL 8.4 image
docker pull mysql:8.4

# Or pull a specific version (recommended for production)
docker pull mysql:8.4.7

# Verify the image was downloaded
docker images | grep mysql
```

**Explanation:**

- `docker pull` downloads the image from Docker Hub
- Using specific versions (`8.4.7`) ensures reproducibility across environments

### Step 4: Update the Container Image in docker-compose.yml

Update the image reference:

```bash
# Edit docker-compose.yml (using nano, vim, or your editor)
nano docker-compose.yml

# Change the image line from:
# image: mysql:8.0
# To:
# image: mysql:8.4

# Or for a specific version:
# image: mysql:8.4.7
```

### Step 5: Perform the Upgrade

Start the new MySQL 8.4 container:

```bash
# If using docker-compose, bring up the service
docker compose up -d db

# If using plain Docker
docker start seek-mysql

# Monitor the startup process
docker logs -f seek-mysql

# Wait for the message: "ready for connections"
# Once you see this, the container is ready (usually 30-60 seconds)
```

**What happens during startup:**

- The container initializes with the MySQL 8.4 image
- System tables are automatically created/upgraded
- The database is ready for connections

### Step 6: Migration of the authentication plugin inside the container

The easiest way to proceed is to open a terminal session in the container itself.


```sh
docker exec -it seek-mysql /bin/bash
```

If you try to connect to the MySQL server in the container, you might see the following error:

```sh
mysql -u root -p<YOUR_SECURE_PASSWORD>

ERROR 1524 (HY000): Plugin 'mysql_native_password' is not loaded
```

If you do not encounter any errors when connecting to the MySQL server, skip the rest of this step and proceed with Step 7.

To be able to log in, you need to explicitly enable the `mysql_native_password` plugin. You can easily do that by uncommenting the `--mysql-native-password=ON` flag in the docker-compose file and restart the container.

```sh
docker compose up --detach --force-recreate db
```

This will enable you to connect to the MySQL server. So, open a terminal session in the database container again.

```sh
docker exec -it seek-mysql /bin/bash
```

Confirm some users are still using the legacy plugin for authentication by running:

```sh
mysql -u root -p -e "SELECT user, host, plugin FROM mysql.user ORDER BY plugin, user, host;"
```

The output should look something like:

```
+------------------+-----------+-----------------------+
| user             | host      | plugin                |
+------------------+-----------+-----------------------+
| mysql.infoschema | localhost | caching_sha2_password |
| mysql.session    | localhost | caching_sha2_password |
| mysql.sys        | localhost | caching_sha2_password |
| root             | %         | mysql_native_password |
| root             | localhost | mysql_native_password |
| seek_user        | %         | mysql_native_password |
+------------------+-----------+-----------------------+
6 rows in set (0.00 sec)
```

Locate your Seek DB user (seek_user in this case) and root user. If the plugin column mentions `mysql_native_password`, it means that user is still using the legacy authentication system and needs to be migrated to `caching_sha2_password`.

For every user, alter the user record from mysql.user:

```sh
mysql -u root -p -e "ALTER USER 'seek_user'@'%' IDENTIFIED WITH caching_sha2_password BY 'REPLACE_WITH_THE_CURRENT_OR_NEW_PASSWORD';"
```

Confirm the changes by running this command again:

```sh
mysql -u root -p -e "SELECT user, host, plugin FROM mysql.user ORDER BY plugin, user, host;"

```

The output should look like this now:

```
+------------------+-----------+-----------------------+
| user             | host      | plugin                |
+------------------+-----------+-----------------------+
| mysql.infoschema | localhost | caching_sha2_password |
| mysql.session    | localhost | caching_sha2_password |
| mysql.sys        | localhost | caching_sha2_password |
| root             | %         | caching_sha2_password |
| root             | localhost | caching_sha2_password |
| seek_user        | %         | caching_sha2_password |
+------------------+-----------+-----------------------+
6 rows in set (0.00 sec)
```

Log out of the MySQL DB container and comment out the `--mysql-native-password=ON` flag.

Restart the docker compose deployment:

```sh
docker compose up --force-recreate
```

The SEEK deployment should start as expected again and be completely operational now.

---

## Troubleshooting Common Issues

### "Plugin 'mysql_native_password' is not loaded"

#### Symptoms

Trying to log into the MySQL server returns this error:

```
ERROR 1524 (HY000): Plugin 'mysql_native_password' is not loaded
```

This indicates that some users are still using the legacy authentication plugin. 

#### Solution

The preferred solution would be to migrate the authentication plugin to use the more modern and secure `caching_sha2_password` plugin. We encourage you follow the instructions in Step 6 again. If migrating is not possible, you can still use the legacy plugin but you will need to explicitly enable it.

Update docker-compose.yml to include in the command section:

```
# --mysql-native-password=ON
```

```sh
docker compose restart db
```

### "Foreign key constraint fails" After Upgrade

#### Symptoms

```
ERROR 1217 (23000): Cannot delete or update a parent row:
a foreign key constraint fails
```
#### Solution

This occurs when non-standard foreign keys are used. Check your schema:

```bash
docker exec -it seek-mysql /bin/sh
```

```bash
# Identify problematic foreign keys
mysql -u root -p -e "
SELECT TABLE_SCHEMA, TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_NAME IS NOT NULL
AND TABLE_SCHEMA NOT IN ('mysql', 'performance_schema', 'information_schema')
ORDER BY TABLE_SCHEMA, TABLE_NAME;
"
```

Then either:

1. Fix the foreign key constraints to use unique keys
2. Disable the restriction (not recommended for new deployments):

  Add this flag to the command in the `db` service:

  ```bash
  --restrict-fk-on-non-standard-key=OFF
  ```

---

## Rollback Procedure

If you need to rollback to MySQL 8.0:

```bash
# Stop and remove the 8.4 container
docker compose stop
docker compose rm db

# Restore the volume from backup
docker volume rm seek-mysql-db
docker run --rm \
  -v seek-mysql-db:/data \
  -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/mysql_8.0_volume_backup.tar.gz -C /data

# Update docker-compose.yml to use mysql:8.0
nano docker-compose.yml
# Change: image: mysql:8.4
# To:     image: mysql:8.0

# Restart with the old image
docker compose up -d db
```

---

## References

- [MySQL 8.4 Release Notes](https://dev.mysql.com/doc/relnotes/mysql/8.4/en/news-8-4-0.html)
- [MySQL 8.4 Reference Manual - Authentication Plugins](https://dev.mysql.com/doc/refman/8.4/en/authentication-plugins.html)
- [Upgrading to MySQL 8.0: Default Authentication Plugin Considerations](https://dev.mysql.com/blog-archive/upgrading-to-mysql-8-0-default-authentication-plugin-considerations/)
- [MySQL Upgrade Documentation](https://dev.mysql.com/doc/refman/8.4/en/upgrading.html)
