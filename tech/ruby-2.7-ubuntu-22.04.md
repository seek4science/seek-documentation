---
title: Installing Ruby 2.7 on Ubuntu 22.04
description: Installation steps for Ruby 2.7 with correct openSSL libraries on Ubuntu 22.04 for FAIRDOM-SEEK (archived guide).
redirect_from: "/install.html"
---

{% include callout.html type="warning" content="This page is out-of-date and may be removed." %}

## Install openssl libraries

This describes the steps for the installation of the correct openSSL libraries - based on information from this [forum](https://askubuntu.com/questions/1399788/ruby-installation-build-failed-ubuntu-20-04-using-ruby-build-20220324).


### Downloading the libraries

```sh
wget https://www.openssl.org/source/openssl-1.1.1n.tar.gz
tar xf openssl-1.1.1n.tar.gz
```

### Compiling

`cd` in the directory `openssl-1.1.1n`

```sh
./config --prefix=/opt/openssl-1.1.1n --openssldir=/opt/openssl-1.1.1n shared zlib
make
make test
sudo make install
```

### Link system certificates to openSSL1.1.1 directory
```sh
sudo rm -rf /opt/openssl-1.1.1n/certs
sudo ln -s /etc/ssl/certs /opt/openssl-1.1.1n
```

## Install ruby using rvm

If you cd in the project folder:

```sh
rvm install $(cat .ruby-version) --with-openssl-dir=/opt/openssl-1.1.1n/
```

or if you want to install another version:

```sh
rvm install <ruby version> --with-openssl-dir=/opt/openssl-1.1.1n/
```