---
title: Configuring SEEK for Virtuoso
redirect_from: "/setting-up-virtuoso.html"
---


It is possible to configure SEEK to automatically send RDF triples to a
Virtuoso Repository.

Developers may also be interested in how to extend this for other triple
stores - this is potentially quite simple and please contact us on our
[developers mailing list](http://groups.google.com/group/seek-dev) if you are
interested.

## Installing Virtuoso

Virtuoso is available as a Debian package, and this is the easiest way to
install it.

For other distributions, or for the latest version, please follow the online
documentation using the link at the end of this section.

    sudo apt-get install virtuoso-opensource

Note that during the installation process, you will be asked for a password
for the DBA and DAV users. We find this doesn't change the password and it
remains as the defaults *dba* or *dav* - you will need to change this
passwords after the installation.

Once installed you should be able to access it, on the port 8890 -
http://localhost:8890 - Click "Conductor" at the top right to login and change
the default passwords.

You may also need to set additional privileges for deleting triples. You can
do this using isql-vt:

    > isql-vt -U dba
    SQL> grant execute on SPARQL_DELETE_DICT_CONTENT to "SPARQL";
    SQL> grant execute on SPARQL_DELETE_DICT_CONTENT to SPARQL_UPDATE;

For more information about setting up and configuring Virtuoso please visit
http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/

## Configuring SEEK

You first need to copy the file *config/virtuoso-settings.example.yml* to
*config/virtuoso-settings.yml*

This file contains configurations for the environments Rails runs under -
production:, development: and test:. If you don't need it configured under a
given environment, just delete that section, or add *disabled: true*

You need to at least set up the username and password.

There are 2 graphs defined - a private graph (that contains everything) and a
public graph (that only contains RDF for publicly accessible items). However,
you will need to configure Virtuoso to prevent access to the private graph. By
default it will be publicly accessible.

If you don't wish to create a private graph - remove the configuration
*private_graph*.

Finally, to start generating and sending triples run the command

    bundle exec rake seek_rdf:generate RAILS_ENV=production

setting the appropriate environment for RAILS_ENV. This will generated a set
of background jobs, which will start generated and sending the RDF.

You can check the progress of these jobs in the Admin pages of SEEK, under
Statistics and then select Job Queue from the dropdown list.
