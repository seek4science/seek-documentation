---
title: "Setting up the Apache Solr Search Engine"
description: Configure Apache Solr for search using Docker image or direct installation for bare metal setups.
---

Since version _1.12_ of FAIRDOM-SEEK [Apache Solr](https://solr.apache.org/) now needs to be setup separately rather than using the built in _Sunspot Solr_ .

This guide only relates to bare metal installations of FAIRDOM-SEEK. It doesn't affect using a 
[Docker](docker/docker-compose) based installation, where the changes are already handled for you.

There are two alternatives to installing and running Apache Solr. If possible, the simplest is to use our Docker
image. If this is not possible, there are also some instructions below on directly installing Apache Solr.

## Using the Docker Image

Using Docker provides the easiest solution to running Solr for SEEK, using the official _solr:8.11.4_ image. The SEEK-specific configuration is mounted directly from your installation directory, so any configuration updates are automatically picked up when the container is restarted.

You first need to have [Docker installed](docker/docker-install). We provide example scripts for managing the Solr service, which should be run from the root directory of your SEEK installation:

  * [script/start-docker-solr.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/start-docker-solr.sh)
    * Creates and starts the container, mounting the SEEK configuration from your installation directory. Creates the data volume if it does not already exist. Waits until Solr is ready before returning.
  * [script/stop-docker-solr.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/stop-docker-solr.sh)
    * Stops and removes the container. The data volume is preserved, so the index persists.
  * [script/reset-docker-solr.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/reset-docker-solr.sh)
    * Stops and removes the container, deletes and recreates the data volume, starts Solr, and runs a full reindex. Use this when the Solr configuration has changed and the index needs to be rebuilt.
  * [script/delete-docker-solr.sh](https://github.com/seek4science/seek/blob/v{{ site.current_seek_version }}/script/delete-docker-solr.sh)
    * Removes both the container and the data volume entirely.

e.g. to start:

```bash
sh ./script/start-docker-solr.sh
```

The Docker container will be named _seek-search_ and the volume named _seek-solr-data-volume_.

Once running, and with search enabled, you can trigger jobs to reindex all searchable content with

```bash
bundle exec rake seek:reindex_all
```

## Installing Apache Solr

The following describes the steps for installing and setting up Solr on Ubuntu 24.04, but the process should be the same for
all Debian based distributions, and very similar for others. It is based on the guide found at [https://tecadmin.net/install-apache-solr-on-ubuntu-20-04/](https://tecadmin.net/install-apache-solr-on-ubuntu-20-04/) 
but the following steps have been updated for solr 8.11.4.

First you should make sure Java 21 is installed. OpenJDK is fine

```bash
sudo apt update
sudo apt install openjdk-21-jdk
```

Double check this with

```bash
java -version
```

If an different version is shown, use the following command and select the number for the correct version

```bash
sudo update-alternatives --config java
```

The next step is to download and install Solr into _/opt/_, and set it up as a service

```bash
cd /opt
sudo wget https://downloads.apache.org/lucene/solr/8.11.4/solr-8.11.4.tgz
sudo tar xzf solr-8.11.4.tgz solr-8.11.4/bin/install_solr_service.sh --strip-components=2
sudo bash ./install_solr_service.sh solr-8.11.4.tgz
```

The services can be stopped and started the usual way with

```bash
sudo service solr stop
sudo service solr start
```

You now need to set up the core configured for SEEK. Move to the root directory of the SEEK installation (in this example /srv/rails/seek), 
and to avoid file permission issue copy the `solr` directory to a location where the `solr` user can access it, and then run the command to create the core with the configuration from SEEK.

```bash
cd /srv/rails/seek
cp -r solr /tmp/seek-solr
sudo su - solr -c "/opt/solr/bin/solr create -c seek -d /tmp/seek-solr/seek/conf"
```

The configuration and data for the SEEK core can be found in _/var/solr/data/seek_ .

You should be able to confirm the service is running and the core setup by visiting [http://localhost:8983/solr](http://localhost:8983/solr)

Solr is now setup, and you can trigger jobs to reindex the content with

```bash
bundle exec rake seek:reindex_all
```

## Updating the Solr Configuration

When the Solr configuration changes between SEEK versions, the existing index data must be cleared and rebuilt to remain consistent with the new configuration.

### Using the Docker Image

Since the configuration is mounted directly from your SEEK installation, no image update is required. Run the following from the root of your SEEK installation:

```bash
sh ./script/reset-docker-solr.sh
```

This will stop and remove the existing container, clear the index data, start a fresh container with the updated configuration, and trigger a full reindex automatically.

### Direct Installation

Delete and recreate the core using the Solr CLI, then trigger a full reindex. Run the following from the root of your SEEK installation (in this example /srv/rails/seek):

```bash
cp -r solr/seek/conf /tmp/seek-solr-conf
sudo su - solr -c "/opt/solr/bin/solr delete -c seek"
sudo su - solr -c "/opt/solr/bin/solr create -c seek -d /tmp/seek-solr-conf"
bundle exec rake seek:reindex_all
rm -rf /tmp/seek-solr-conf
```

The config is copied to `/tmp` first so that the `solr` user can read it. Deleting the core also removes the existing index data, so a full reindex is required afterwards.






    



