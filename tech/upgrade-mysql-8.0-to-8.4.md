---
title: Upgrade guide MySQL 8.0 to 8.4
---
Starting from SEEK 1.18.0, we highly recommend upgrading the MySQL database from version 8.0 to the next LTS version, 8.4. MySQL 8.0 reached end-of-life status April 30th 2026 and will not receive security fixes anymore. This guide provides detailed instructions for upgrading MySQL from version 8.0 to 8.4, covering both bare-metal installations and containerized deployments using Docker.

## Critical Breaking Changes in MySQL 8.4

The new LTS release has a couple of breaking changes, cited here below. The First two will apply to all older databases (prior to V 8.0) and should be read carefully! The remaining changes could impact you, depending on your setup / usage of MySQL or are simply less impactful.

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
-  should migrate users to `caching_sha2_password`

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

## Part 1: Bare-Metal Installation Upgrade

### Prerequisites

Ensure you have:

- Administrative/root access to the server
- At least 2GB of free disk space
- A backup of the current MySQL data directory
- The MySQL 8.4 installation package for your operating system

### Step 1: Backup Your Data

Create a full backup before proceeding with the upgrade:

```bash
# Create a backup directory
mkdir -p /backups/mysql
cd /backups/mysql

# Perform a logical backup using mysqldump
mysqldump \
  --all-databases \
  --single-transaction \
  --user=root \
  --password \
  > mysql_8.0_full_backup.sql
```

### Step 2: Stop the MySQL Service

Stop the running MySQL server gracefully:

```bash
# On systemd systems (most modern Linux distributions)
sudo systemctl stop mysql

# Verify MySQL has stopped
sudo systemctl status mysql

# Alternative: if using init.d
sudo service mysql stop

# Verify no MySQL processes are running
ps aux | grep mysqld | grep -v grep
```

**Explanation:**

- `systemctl stop` sends a SIGTERM signal, allowing MySQL to shut down gracefully
- Graceful shutdown ensures data integrity and avoids corruption
- The `ps aux` command verifies that all MySQL processes have terminated

### Step 3: Update Configuration File

Edit the MySQL configuration file to prepare for version 8.4:

```bash
# Find the MySQL configuration file
sudo find /etc -name "my.cnf" -o -name "mysql.cnf" 2>/dev/null

# Typically located at:
# /etc/mysql/my.cnf
# /etc/my.cnf
# /usr/local/mysql/etc/my.cnf

# Open the configuration file with sudo
sudo nano /etc/mysql/my.cnf
```

**Critical Changes Required:**

1. **Remove `default_authentication_plugin` if it exists:**

```ini
# DELETE THIS LINE if present:
# default_authentication_plugin=mysql_native_password
```

2. **If your applications require `mysql_native_password`, add this instead:**

```ini
[mysqld]
# Enable mysql_native_password for backward compatibility
mysql_native_password=ON
```

3. **If using non-standard foreign keys, optionally add:**

```ini
[mysqld]
# Allow non-unique/partial keys as foreign keys (if needed)
restrict_fk_on_non_standard_key=OFF
```

4. **Review and verify other settings for compatibility:**

```bash
# After saving, validate the configuration
sudo mysql --help | grep "my.cnf"
```

### Step 4: Install MySQL 8.4

The installation process depends on your Linux distribution.

**On Debian/Ubuntu:**

```bash
# Optional: Download the MySQL repository package
wget https://dev.mysql.com/get/mysql-apt-config_0.8.24-1_all.deb

# Optional: Install the repository configuration
sudo dpkg -i mysql-apt-config_0.8.24-1_all.deb

# Update package index
sudo apt-get update

# Install MySQL 8.4 (the specific version)
sudo apt-get install -y mysql-server=8.4.*

# You will be prompted for a root password - enter it securely
```

**On CentOS/RHEL:**

```bash
# Optional: Download the MySQL repository RPM
wget https://dev.mysql.com/get/mysql80-community-release-el8-x.noarch.rpm

# Optional: Install the repository
sudo yum install mysql80-community-release-el8-x.noarch.rpm

# Install MySQL 8.4
sudo yum install -y mysql-community-server-8.4.*

# Start the MySQL service
sudo systemctl start mysql
```

**Explanation:**

- The repository configuration allows your package manager to find MySQL 8.4
- Installation automatically handles file placement and basic configuration
- The `=8.4.*` ensures you get version 8.4.x (the latest in the 8.4 series)

### Step 5: Run the MySQL Upgrade Utility

This critical step upgrades the system tables to MySQL 8.4 format:

```bash
# Start MySQL in skip-grant-tables mode to allow the upgrade
sudo systemctl start mysql

# Run the upgrade tool
sudo mysql_upgrade --user=root --password

# You'll be prompted for the MySQL root password
# Enter it when requested
```

**What `mysql_upgrade` does:**

- Checks all tables in all databases for compatibility
- Updates system tables (`mysql.user`, `mysql.db`, etc.) to the new format
- Refreshes the privilege tables
- Rebuilds information schema files
- Checks for deprecated features

**Expected output:**

```
Checking mysql database
Checking all databases
Upgrading the system database structures
OK
```

If you see any warnings or errors, address them before continuing:

```bash
# For detailed information about the upgrade process
mysql -u root -p -e "SELECT VERSION();"
```

### Step 6: Migration of the authentication plugin (bare-metal)

After updating the MySQL server, you might experience issues trying to connect to it.

If you get this error message, it means some users are still using the old `mysql_native_password` plugin to authenticate, while it is diabled by default in MySQL 8.4.

```
ERROR 1524 (HY000): Plugin 'mysql_native_password' is not loaded
```

If you **do not** experience any problems, proceed with [step 7](#step-7-verify-application-connectivity)!

In order to be able to login to the MySQL server, you need to explicitly enable it. Therefor, you should at the following line to the `[mysqld]` section of `/etc/mysql/my.cnf` or in `/etc/mysql/conf.d/` if you have a multi-file config:

```ini
mysql_native_password=ON
```

And restart MySQL

```sh
sudo systemctl restart mysql
```

This should allow you to connect to the MySQL server again. Confirm some users are still using the legacy plugin for authentication by running:

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

Remove the `mysql_native_password=ON` from the MySQL config again and restart MySQL.

Now you should be able to connect to the MySQL server without having to explicitly enable the `mysql_native_password` plugin.

### Step 7: Verify Application Connectivity

Confirm that MySQL 8.4 is running correctly:

```bash
# Check the MySQL version
mysql -u root -p -e "SELECT VERSION();"
```

Output should similar to:

```
+-----------+
| VERSION() |
+-----------+
| 8.4.7     |
+-----------+
```

Test that your applications can connect with the new authentication setup:

```bash
# Test connection with a database user
mysql -u seek_user -p -h <host> database_name -e "SHOW TABLES;"
```

If connection fails, check the error log

```sh
sudo tail -50 /var/log/mysql/error.log
```

---

## Part 2: Docker/Containerized Upgrade

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
    image: fairdom/seek:main

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
        condition: service_started

services:
  db:
    # Database implementation, in this case MySQL
    image: mysql:8.4
    container_name: seek-mysql
    command: >
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
      --log-error-verbosity=1
      # Optional: Enable mysql_native_password if needed for legacy apps
      # --mysql-native-password=ON
      # Optional: restrict foreign keys if needed
      # --restrict_fk_on_non_standard_key=OFF
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
    image: fairdom/seek-solr:8.11
    container_name: seek-solr
    restart: always
    environment:
      SOLR_JAVA_MEM: -Xms512m -Xmx1024m
    volumes:
      - seek-solr-data:/var/solr/
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
- `--restrict_fk_on_non_standard_key=OFF` allows the usage of non-standard foreign keys if needed

**Alternative: Create a custom my.cnf configuration file:**

```bash
# Create a custom configuration directory
mkdir -p ./mysql-config

# Create my.cnf
cat > ./mysql-config/my.cnf << 'EOF'
[mysqld]
# MySQL 8.4 Configuration

# Default storage engine
default_storage_engine=InnoDB

# Character set
character_set_server=utf8mb4
collation_server=utf8mb4_unicode_ci

# Enable mysql_native_password if needed
# mysql_native_password=ON

# Optional: disable strict foreign key restrictions if needed
# restrict_fk_on_non_standard_key=OFF

# Performance tuning
max_connections=1000
innodb_buffer_pool_size=2G
innodb_log_file_size=512M
EOF
```

Then reference it in docker-compose.yml:

```yaml
volumes:
  - ./mysql-config:/etc/mysql/conf.d:ro
```

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

If you have no trouble connecting to the MySQL server, without encountering any errors, no need to do the rest of this step and proceed with Step 7.

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

### Issue 1: "Plugin 'mysql_native_password' is not loaded"

#### Symptoms

Trying to log into the MySQL server returns this error:

```
ERROR 1524 (HY000): Plugin 'mysql_native_password' is not loaded
```

This indicates that some users are still using the legacy authentication plugin. 

#### Solution

The preferred solution would be to migrate the authentication plugin to use the more modern and secure `caching_sha2_password` plugin. If migrating is not possible, you can still use the legacy plugin but you will need to explicitly enable it.

##### Bare-metal



```bash
sudo nano /etc/mysql/my.cnf
# Add or verify this in the [mysqld] section:
# mysql_native_password=ON

sudo systemctl restart mysql
```

##### Docker

```bash
# Update docker-compose.yml to include in the command section:
# --mysql-native-password=ON

docker compose restart db
```

### Issue 2: "Unknown variable 'default_authentication_plugin'"

#### Symptoms

```
ERROR 1193 (HY000): Unknown variable 'default_authentication_plugin'
```
#### Solution


Remove all instances of `default_authentication_plugin` from:

- `/etc/mysql/my.cnf` or `/etc/my.cnf` (bare-metal)
- Docker environment variables in `docker-compose.yml`
- Docker command arguments

### Issue 3: "Foreign key constraint fails" After Upgrade

#### Symptoms

```
ERROR 1217 (23000): Cannot delete or update a parent row:
a foreign key constraint fails
```
#### Solution


This occurs when non-standard foreign keys are used. Check your schema:

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

```bash
# Bare-metal
sudo nano /etc/mysql/my.cnf
# Add: restrict_fk_on_non_standard_key=OFF

# Docker
# Add to command: --restrict_fk_on_non_standard_key=OFF
```

### Issue 4: Container Fails to Start

#### Symptoms

```
docker: Error response from daemon: container exited with code 1
```
#### Solution


```bash
# Check the logs for detailed error information
docker logs <container_name>

# Common issues:
# 1. Invalid my.cnf syntax - validate the configuration file
# 2. Insufficient disk space - check: df -h
# 3. Port already in use - check: sudo netstat -tlnp | grep 3306

# Restart with verbose logging
docker compose logs -f db
```

---

## Rollback Procedure

If you need to rollback to MySQL 8.0:

### Bare-Metal Rollback

```bash
# Stop MySQL 8.4
sudo systemctl stop mysql

# Uninstall MySQL 8.4
sudo apt-get remove mysql-server  # On Debian/Ubuntu
# or
sudo yum remove mysql-community-server  # On CentOS/RHEL

# Restore the backup of the data directory
sudo rm -rf /var/lib/mysql
sudo cp -r /backups/mysql/mysql_8.0_datadir_backup /var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql

# Reinstall MySQL 8.0
sudo apt-get install mysql-server=8.0.*  # On Debian/Ubuntu

# Start MySQL
sudo systemctl start mysql

# Verify
mysql -u root -p -e "SELECT VERSION();"
```

### Docker Rollback

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

