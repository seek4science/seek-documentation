---
title: Installing SEEK under a sub URI
redirect_from: "/install-on-suburi.html"
---


Running under a sub URI means running seek with a path below the main domain
URI - e.g http://myhost.org/seek

This requires a couple of small changes on-top of the standard installation.
This only covers installing in a production environment running with Apache,
but the principle is the same for other webservers.

It is assumed here that the suburi will be /seek and these steps should be
carried out once the rest of the installation is complete.

## Modifying the Apache configuration

The Apache configuration requires a small change to pass an additional couple
of parameters to Passenger. Please add the following to your virtual host
settings, just before the Directory definition.

    Alias /seek /srv/rails/seek/public
    <Location /seek>
      PassengerBaseURI /seek
      PassengerAppRoot /srv/rails/seek
    </Location>

You can find out more about this configuration at

[https://www.phusionpassenger.com/library/deploy/apache/deploy/ruby/#deploying-an-app-to-a-sub-uri-or-subdirectory](https://www.phusionpassenger.com/library/deploy/apache/deploy/ruby/#deploying-an-app-to-a-sub-uri-or-subdirectory)

## Setting the relative_url_root

In the file *config/application.rb* towards the end withing the inner block,
either uncomment or add the line:

    config.relative_url_root = '/seek'

This setting is necessary to create the correct paths when compiling the
assets, and also for the delayed-job background tasks. An alternative to this
is to set the RAILS_RELATIVE_URL_ROOT environment variable when
starting/stopping the seek:workers or compiling assets.

Now re-compile the assets

    rm -rf public/assets
    bundle exec rake assets:precompile

Now restart Apache, and if you have already ran seek clear the cache with:

    bundle exec rake tmp:clear

You should now be able to visit and use seek at [http://localhost/seek](http://localhost/seek)
