---
title: Checksum fingerprints
description: Verify downloaded FAIRDOM-SEEK Research Object snapshots using MD5 and SHA1 checksums to detect tampering or modifications.
redirect_from:
    - /investigation_checksum.html
    - /tech/investigation_checksum.html
---

## What are they?

The checksum fingerprints for the snapshots provide the ability to verify the downloaded Research Object hasn't been modified. This could either be through malicious tampering
or has simply been passed around and modified without your knowledge before you received it. The checksum allows you to double check this against the snapshot on SEEK.

## Verifying the MD5 or SHA1

For most cases MD5 is fine. There is some potential for 2 different files to produce the same checksum, but this is unusual and difficult to manipulate. We also provide a SHA1 sum
which is less likely to produce the same checksum for different files.

### Internet

SEEK snapshots are usually public and available, so you shouldn't be too worried about uploading to an online service. In many cases the file isn't even uploaded but is checked within
the browser.

An example is [OnlineMD5](http://onlinemd5.com/)

### Windows

There are many tools available to download to check the sum, which can be found by searching online for "md5sum Windows".

Popular tools include [HashTab](http://implbits.com/products/hashtab/) and [md5sums](http://www.pc-tools.net/win32/md5sums/)

### Linux

For MD5

    md5sum <filename>

For SHA1

    sha1sum <filename>

This will return and display the checksum


### Mac OS

For MD5

    openssl dgst -md5 <filename> | cat

For SHA1

    openssl dgst -sha1 <filename> | cat

This will return and display the checksum





