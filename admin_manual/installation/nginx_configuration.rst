===================
NGINX Configuration
===================

This page covers example NGINX configurations to use with running an ownCloud 
server. Note that NGINX is not officially supported, and this page is 
community-maintained. (Thank you, contributors!)

-  You need to insert the following code into **your NGINX configuration file.**
-  The configuration assumes that ownCloud is installed in 
   ``/var/www/owncloud`` and that it is accessed via 
   ``http(s)://cloud.example.com``.
-  Adjust **server_name**, **root**, **ssl_certificate** and 
   **ssl_certificate_key** to suit your needs.
-  Make sure your SSL certificates are readable by the server (see `NGINX HTTP 
   SSL Module documentation <http://wiki.nginx.org/HttpSslModule>`_).
-  ``add_header`` statements are only taken from the current level and are not 
   cascaded from or to a different level. All necessary ``add_header`` 
   statements must be defined in each level needed. For better readability it 
   is possible to move *common* add header statements into a separate file 
   and include that file wherever necessary. However, each ``add_header`` 
   statement must be written in a single line to prevent connection problems 
   with sync clients.

Example Configurations
----------------------

Be careful about line breaks if you copy the examples, as long lines may be broken
for page formatting.

Thanks to `@josh4trunks <https://github.com/josh4trunks>`_ for providing / 
creating these configuration examples.

You can use ownCloud over plain http, but we strongly encourage you to use 
SSL/TLS to encrypt all of your server traffic, and to protect user's logins and 
data in transit.

-  Remove the server block containing the redirect
-  Change **listen 443 ssl http2** to **listen 80;**
-  Remove all **ssl_** entries.
-  Remove **fastcgi_params HTTPS on;**

ownCloud in the webroot of NGINX
================================

The following config should be used when ownCloud is placed in the webroot of 
your NGINX installation.

.. code-block:: nginx

  upstream php-handler {
      server 127.0.0.1:9000;
      # Depending on your used PHP version
      #server unix:/var/run/php5-fpm.sock;
      #server unix:/var/run/php7-fpm.sock;
  }

  server {
      listen 80;
      server_name cloud.example.com;

      # For Lets Encrypt, this needs to be served via HTTP
      location /.well-known/acme-challenge/ {
          root /var/www/owncloud; # Specify here where the challenge file is placed
      }

      # enforce https
      location / {
          return 301 https://$server_name$request_uri;
      }
  }
  
  server {
      listen 443 ssl http2;
      server_name cloud.example.com;
  
      ssl_certificate /etc/ssl/nginx/cloud.example.com.crt;
      ssl_certificate_key /etc/ssl/nginx/cloud.example.com.key;

      # Example SSL/TLS configuration. Please read into the manual of
      # nginx before applying these.
      ssl_session_timeout 5m;
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers "-ALL:EECDH+AES256:EDH+AES256:AES256-SHA:EECDH+AES:EDH+AES:!ADH:!NULL:!aNULL:!eNULL:!EXPORT:!LOW:!MD5:!3DES:!PSK:!SRP:!DSS:!AESGCM:!RC4";
      ssl_dhparam /etc/nginx/dh4096.pem;
      ssl_prefer_server_ciphers on;
      keepalive_timeout    70;
      ssl_stapling on;
      ssl_stapling_verify on;
  
      # Add headers to serve security related headers
      # Before enabling Strict-Transport-Security headers please read into this topic first.
      #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
      add_header X-Content-Type-Options nosniff;
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-XSS-Protection "1; mode=block";
      add_header X-Robots-Tag none;
      add_header X-Download-Options noopen;
      add_header X-Permitted-Cross-Domain-Policies none;
  
      # Path to the root of your installation
      root /var/www/owncloud/;
  
      location = /robots.txt {
          allow all;
          log_not_found off;
          access_log off;
      }
  
      # The following 2 rules are only needed for the user_webfinger app.
      # Uncomment it if you're planning to use this app.
      #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
      #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;
  
      location = /.well-known/carddav {
          return 301 $scheme://$host/remote.php/dav;
      }
      location = /.well-known/caldav {
          return 301 $scheme://$host/remote.php/dav;
      }
  
      # set max upload size
      client_max_body_size 512M;
      fastcgi_buffers 64 4K;
  
      # Disable gzip to avoid the removal of the ETag header
      # Enabling gzip would also make your server vulnerable to BREACH
      # if no additional measures are done. See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=773332
      gzip off;
  
      # Uncomment if your server is build with the ngx_pagespeed module
      # This module is currently not supported.
      #pagespeed off;
  
      error_page 403 /core/templates/403.php;
      error_page 404 /core/templates/404.php;
  
      location / {
          rewrite ^ /index.php$uri;
      }
  
      location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
          return 404;
      }
      location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
          return 404;
      }
  
      location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
          fastcgi_split_path_info ^(.+\.php)(/.*)$;
          include fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_param SCRIPT_NAME $fastcgi_script_name; # necessary for owncloud to detect the contextroot https://github.com/owncloud/core/blob/v10.0.0/lib/private/AppFramework/Http/Request.php#L603
          fastcgi_param PATH_INFO $fastcgi_path_info;
          fastcgi_param HTTPS on;
          fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
          fastcgi_param front_controller_active true;
          fastcgi_read_timeout 180; # increase default timeout e.g. for long running carddav/ caldav syncs with 1000+ entries
          fastcgi_pass php-handler;
          fastcgi_intercept_errors on;
          fastcgi_request_buffering off; #Available since NGINX 1.7.11
      }
  
      location ~ ^/(?:updater|ocs-provider)(?:$|/) {
          try_files $uri $uri/ =404;
          index index.php;
      }
  
      # Adding the cache control header for js and css files
      # Make sure it is BELOW the PHP block
      location ~ \.(?:css|js)$ {
          try_files $uri /index.php$uri$is_args$args;
          add_header Cache-Control "max-age=15778463";
          # Add headers to serve security related headers (It is intended to have those duplicated to the ones above)
          # Before enabling Strict-Transport-Security headers please read into this topic first.
          #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
          add_header X-Content-Type-Options nosniff;
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Robots-Tag none;
          add_header X-Download-Options noopen;
          add_header X-Permitted-Cross-Domain-Policies none;
          # Optional: Don't log access to assets
          access_log off;
      }
  
      location ~ \.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg|map)$ {
          add_header Cache-Control "public, max-age=7200";
          try_files $uri /index.php$uri$is_args$args;
          # Optional: Don't log access to other assets
          access_log off;
      }
  }

ownCloud in a subdir of NGINX
=============================

The following config should be used when ownCloud is not in your webroot but placed under a different contextroot of your NGINX installation such as /owncloud or /cloud. The following configuration assumes it is placed under ``/owncloud`` and that you have ``'overwritewebroot' => '/owncloud',`` set in your ``config/config.php``.

.. code-block:: nginx

  upstream php-handler {
      server 127.0.0.1:9000;
      # Depending on your used PHP version
      #server unix:/var/run/php5-fpm.sock;
      #server unix:/var/run/php7-fpm.sock;
  }
  
  server {
      listen 80;
      server_name cloud.example.com;

      # For Lets Encrypt, this needs to be served via HTTP
      location /.well-known/acme-challenge/ {
          root /var/www/owncloud; # Specify here where the challenge file is placed
      }

      # enforce https
      location / {
          return 301 https://$server_name$request_uri;
      }
  }
  
  server {
      listen 443 ssl http2;
      server_name cloud.example.com;
  
      ssl_certificate /etc/ssl/nginx/cloud.example.com.crt;
      ssl_certificate_key /etc/ssl/nginx/cloud.example.com.key;

      # Example SSL/TLS configuration. Please read into the manual of
      # nginx before applying these.
      ssl_session_timeout 5m;
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers "-ALL:EECDH+AES256:EDH+AES256:AES256-SHA:EECDH+AES:EDH+AES:!ADH:!NULL:!aNULL:!eNULL:!EXPORT:!LOW:!MD5:!3DES:!PSK:!SRP:!DSS:!AESGCM:!RC4";
      ssl_dhparam /etc/nginx/dh4096.pem;
      ssl_prefer_server_ciphers on;
      keepalive_timeout    70;
      ssl_stapling on;
      ssl_stapling_verify on;

      # Add headers to serve security related headers
      # Before enabling Strict-Transport-Security headers please read into this topic first.
      #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
      add_header X-Content-Type-Options nosniff;
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-XSS-Protection "1; mode=block";
      add_header X-Robots-Tag none;
      add_header X-Download-Options noopen;
      add_header X-Permitted-Cross-Domain-Policies none;
  
      # Path to the root of your installation
      root /var/www/;
  
      location = /robots.txt {
          allow all;
          log_not_found off;
          access_log off;
      }
  
      # The following 2 rules are only needed for the user_webfinger app.
      # Uncomment it if you're planning to use this app.
      #rewrite ^/.well-known/host-meta /owncloud/public.php?service=host-meta last;
      #rewrite ^/.well-known/host-meta.json /owncloud/public.php?service=host-meta-json last;
  
      location = /.well-known/carddav {
          return 301 $scheme://$host/owncloud/remote.php/dav;
      }
      location = /.well-known/caldav {
          return 301 $scheme://$host/owncloud/remote.php/dav;
      }
  
      location ^~ /owncloud {

          root /var/www/owncloud/;

          # set max upload size
          client_max_body_size 512M;
          fastcgi_buffers 64 4K;
  
          # Disable gzip to avoid the removal of the ETag header
          # Enabling gzip would also make your server vulnerable to BREACH
          # if no additional measures are done. See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=773332
          gzip off;
  
          # Uncomment if your server is build with the ngx_pagespeed module
          # This module is currently not supported.
          #pagespeed off;
  
          error_page 403 /owncloud/core/templates/403.php;
          error_page 404 /owncloud/core/templates/404.php;
  
          location /owncloud {
              rewrite ^ /owncloud/index.php$uri;
          }
  
          location ~ ^/owncloud/(?:build|tests|config|lib|3rdparty|templates|data)/ {
              return 404;
          }
          location ~ ^/owncloud/(?:\.|autotest|occ|issue|indie|db_|console) {
              return 404;
          }
  
          location ~ ^/owncloud/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
              fastcgi_split_path_info ^/owncloud(.+\.php)(/.*)$;
              include fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param SCRIPT_NAME $fastcgi_script_name; # necessary for owncloud to detect the contextroot https://github.com/owncloud/core/blob/v10.0.0/lib/private/AppFramework/Http/Request.php#L603
              fastcgi_param PATH_INFO $fastcgi_path_info;
              fastcgi_param HTTPS on;
              fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
              # EXPERIMENTAL: active the following if you need to get rid of the 'index.php' in the URLs
              #fastcgi_param front_controller_active true;
              fastcgi_read_timeout 180; # increase default timeout e.g. for long running carddav/ caldav syncs with 1000+ entries
              fastcgi_pass php-handler;
              fastcgi_intercept_errors on;
              fastcgi_request_buffering off; #Available since NGINX 1.7.11
          }
  
          location ~ ^/owncloud/(?:updater|ocs-provider)(?:$|/) {
              try_files $uri $uri/ =404;
              index index.php;
          }
  
          # Adding the cache control header for js and css files
          # Make sure it is BELOW the PHP block
          location ~ /owncloud(\/.*\.(?:css|js)) {
              try_files $1 /owncloud/index.php$1$is_args$args;
              add_header Cache-Control "max-age=15778463";
              # Add headers to serve security related headers  (It is intended to have those duplicated to the ones above)
              # Before enabling Strict-Transport-Security headers please read into this topic first.
              #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
              add_header X-Content-Type-Options nosniff;
              add_header X-Frame-Options "SAMEORIGIN";
              add_header X-XSS-Protection "1; mode=block";
              add_header X-Robots-Tag none;
              add_header X-Download-Options noopen;
              add_header X-Permitted-Cross-Domain-Policies none;
              # Optional: Don't log access to assets
              access_log off;
          }
  
          location ~ /owncloud(/.*\.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg|map)) {
              try_files $1 /owncloud/index.php$1$is_args$args;
              add_header Cache-Control "public, max-age=7200";
              # Optional: Don't log access to other assets
              access_log off;
          }
      }
  }

Suppressing Log Messages
========================

If you're seeing meaningless messages in your logfile, for example `client 
denied by server configuration: /var/www/data/htaccesstest.txt 
<https://central.owncloud.org/t/htaccesstest-txt-errors-in-logfiles/831>`_,
add this section to your NGINX configuration to suppress them::

        location = /data/htaccesstest.txt {
          allow all;
          log_not_found off;
          access_log off;
        }

JavaScript (.js) or CSS (.css) files not served properly
========================================================

A common issue with custom NGINX configs is that JavaScript (.js)
or CSS (.css) files are not served properly leading to a 404 (File not found)
error on those files and a broken webinterface.

This could be caused by the::

        location ~ \.(?:css|js)$ {

block shown above not located **below** the::

        location ~ \.php(?:$|/) {

block. Other custom configurations like caching JavaScript (.js)
or CSS (.css) files via gzip could also cause such issues.

Not all of my contacts are synchronized
=======================================

Check your server timeouts! It turns out that CardDAV sync often fails silently if the request runs into timeouts. With PHP-FPM you might see a "CoreDAVHTTPStatusErrorDomain error 504" which is an "HTTP504 Gateway timeout" error. To solve this, first check the ``default_socket_timeout`` setting in ``/etc/php/7.0/fpm/php.ini`` and increase the above ``fastcgi_read_timeout`` accordingly. Depending on your server's performance a timeout of 180s should be sufficient to sync an addressbook of ~1000 contacts.

Performance Tuning
==================

`nginx (<1.9.5) <ngx_http_spdy_module 
<http://nginx.org/en/docs/http/ngx_http_spdy_module.html>`_
`nginx (+1.9.5) <ngx_http_http2_module 
<http://nginx.org/en/docs/http/ngx_http_v2_module.html>`_

To use http_v2 for NGINX you have to check two things:

   1.) be aware that this module is not built in by default due to a dependency 
   to the openssl version used on your system. It will be enabled with the 
   ``--with-http_v2_module`` configuration parameter during compilation. The 
   dependency should be checked automatically. You can check the presence of 
   http_v2 with ``nginx -V 2>&1 | grep http_v2 -o``. An example of how to 
   compile NGINX can be found in section "Configure NGINX with the 
   ``nginx-cache-purge`` module" below.
   
   2.) When you have used SPDY before, the NGINX config has to be changed from 
   ``listen 443 ssl spdy;`` to ``listen 443 ssl http2;``

NGINX: caching ownCloud gallery thumbnails
==========================================

One of the optimizations for ownCloud when using NGINX as the Web server is to 
combine FastCGI caching with "Cache Purge", a `3rdparty NGINX module 
<http://wiki.nginx.org/3rdPartyModules>`_  that adds the ability to purge 
content from `FastCGI`, `proxy`, `SCGI` and `uWSGI` caches. This mechanism 
speeds up thumbnail presentation as it shifts requests to NGINX and minimizes 
php invocations which otherwise would take place for every thumbnail presented 
every time.
 
The following procedure is based on an Ubuntu 14.04 system. You may need to 
adapt it according your OS type and release.

.. note::
   Unlike Apache, NGINX does not dynamically load modules. All modules needed 
   must be compiled into NGINX. This is one of the reasons for NGINX´s 
   performance. It is expected to have an already running NGINX installation 
   with a working configuration set up as described in the ownCloud 
   documentation.

NGINX module check
==================

As a first step, it is necessary to check if your NGINX installation has the 
``nginx cache purge`` module compiled in::
 
 nginx -V 2>&1 | grep ngx_cache_purge -o
 
If your output contains ``ngx_cache_purge``, you can continue with the 
configuration, otherwise you need to manually compile NGINX with the module 
needed.

Compile NGINX with the ``nginx-cache-purge`` module
===================================================

1. **Preparation:**

::

    cd /opt
    wget http://nginx.org/keys/nginx_signing.key
    sudo apt-key add nginx_signing.key
    sudo vi /etc/apt/sources.list.d/nginx.list
    
Add the following lines (if different, replace ``{trusty}`` by your 
distribution name)::

   deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx
   deb -src http://nginx.org/packages/mainline/ubuntu/ trusty nginx    

Then run ``sudo apt-get update``

.. note:: If you're not overly cautious and wish to install the latest and 
   greatest NGINX packages and features, you may have to install NGINX from its 
   mainline repository. From the NGINX homepage: "In general, you should 
   deploy NGINX from its mainline branch at all times." If you would like to 
   use standard NGINX from the latest mainline branch but without compiling in 
   any additional modules, just run ``sudo apt-get install nginx``.   

2. **Download the NGINX source from the ppa repository**

::

   cd /opt
   sudo apt-get build-dep nginx
   sudo apt-get source nginx

3. **Download module(s) to be compiled in and configure compiler arguments**
    
:: 
   
   ls -la
    
Please replace ``{release}`` with the release downloaded::

   cd /opt/nginx-{release}/debian
    
If folder "modules" is not present, do:

::

   sudo mkdir modules
   cd modules
   sudo git clone https://github.com/FRiCKLE/ngx_cache_purge.git
   sudo vi /opt/nginx-{release}/debian/rules
    
If not present, add the following line at the top under::

   #export DH_VERBOSE=1:
   MODULESDIR = $(CURDIR)/debian/modules
   
And at the end of every ``configure`` command add::

  --add-module=$(MODULESDIR)/ngx_cache_purge
    
Don't forget to escape preceeding lines with a backslash ``\``.
The parameters may now look like::
      
   --with-cc-opt="$(CFLAGS)" \
   --with-ld-opt="$(LDFLAGS)" \
   --with-ipv6 \
   --add-module=$(MODULESDIR)/ngx_cache_purge

4. **Compile and install NGINX**

::

   cd /opt/nginx-{release}
   sudo dpkg-buildpackage -uc -b
   ls -la /opt
   sudo dpkg --install /opt/nginx_{release}~{distribution}_amd64.deb

5. **Check if the compilation and installation of the ngx_cache_purge module 
   was successful**
   
::  

   nginx -V 2>&1 | grep ngx_cache_purge -o
    
It should now show: ``ngx_cache_purge``
    
Show NGINX version including all features compiled and installed::

   nginx -V 2>&1 | sed s/" --"/"\n\t--"/g

6. **Mark NGINX to be blocked from further updates via apt-get**

::

   sudo dpkg --get-selections | grep nginx
    
For every NGINX component listed run ``sudo apt-mark hold <component>``   

7. **Regular checks for NGINX updates**

Do a regular visit on the `NGINX news page <http://nginx.org>`_ and proceed 
in case of updates with items 2 to 5.

Configure NGINX with the ``nginx-cache-purge`` module
=====================================================

1. **Preparation**
   Create a directory where NGINX will save the cached thumbnails. Use any 
   path that fits to your environment. Replace ``{path}`` in this example with 
   your path created:
   
::   
   
   sudo mkdir -p /usr/local/tmp/cache   

2. **Configuration**

::

   sudo vi /etc/nginx/sites-enabled/{your-ownCloud-nginx-config-file}
   
Add at the *beginning*, but *outside* the ``server{}`` block::

   # cache_purge
   fastcgi_cache_path {path} levels=1:2 keys_zone=OWNCLOUD:100m inactive=60m;
   map $request_uri $skip_cache {
        default 1;
        ~*/thumbnail.php 0;
        ~*/apps/galleryplus/ 0;
        ~*/apps/gallery/ 0;
   }

.. note:: Please adopt or delete any regex line in the ``map`` block according 
   your needs and the ownCloud version used.
   As an alternative to mapping, you can use as many ``if`` statements in 
   your server block as necessary::
   
    set $skip_cache 1;
    if ($request_uri ~* "thumbnail.php")      { set $skip_cache 0; }
    if ($request_uri ~* "/apps/galleryplus/") { set $skip_cache 0; }
    if ($request_uri ~* "/apps/gallery/")     { set $skip_cache 0; }

Add *inside* the ``server{}`` block, as an example of a configuration::
   
   
   # cache_purge (with $http_cookies we have unique keys for the user)
   fastcgi_cache_key $http_cookie$request_method$host$request_uri;
   fastcgi_cache_use_stale error timeout invalid_header http_500;
   fastcgi_ignore_headers Cache-Control Expires Set-Cookie;
   
   location ~ \.php(?:$/) {
         fastcgi_split_path_info ^(.+\.php)(/.+)$;
       
         include fastcgi_params;
         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
         fastcgi_param PATH_INFO $fastcgi_path_info;
         fastcgi_param HTTPS on;
         fastcgi_pass php-handler;
       
         # cache_purge
         fastcgi_cache_bypass $skip_cache;
         fastcgi_no_cache $skip_cache;
         fastcgi_cache OWNCLOUD;
         fastcgi_cache_valid  60m;
         fastcgi_cache_methods GET HEAD;
         }
   
.. note:: Note regarding the ``fastcgi_pass`` parameter:
   Use whatever fits your configuration. In the example above, an ``upstream`` 
   was defined in an NGINX global configuration file.
   This may look like::
       
     upstream php-handler {
         server unix:/var/run/php5-fpm.sock;
         # or
         # server 127.0.0.1:9000;
       } 
   
3. **Test the configuration**

::

   sudo nginx -s reload
   
*  Open your browser and clear your cache.   
*  Logon to your ownCloud instance, open the gallery app, move thru your       
   folders and watch while the thumbnails are generated for the first time.
*  You may also watch with eg. ``htop`` your system load while the 
   thumbnails are processed.
*  Go to another app or logout and relogon.
*  Open the gallery app again and browse to the folders you accessed before.
   Your thumbnails should appear more or less immediately.
*  ``htop`` will not show up additional load while processing, compared to 
   the high load before.

Prevent access log entries when accessing thumbnails
====================================================
When using Gallery or Galleryplus, any access to a thumbnail of a picture will be logged.
This can cause a massive log quanity making log reading challenging. With this approach,
you can disable access logging for those thumbnails.

1. **Create a map directive outside your server block like**

   (Adopt the path queried according your needs.)

::

     # do not access log to gallery thumbnails, flooding access logs only, error will be logged anyway
     map $request_uri $loggable {
             default 1;
             ~*\/apps\/gallery\/thumbnails           0;
             ~*\/apps\/galleryplus\/thumbnails       0;
     }


2. **Inside your server block where you define your logs**

::

     access_log /path-to-your-log combined if=$loggable;
