.. _nginx_configuration_example:

===================
Nginx Configuration
===================

-  You need to insert the following code into **your nginx config file.**
-  The config assumes that ownCloud is installed in /var/www/owncloud and
   that it is accessed via http(s)://cloud.example.com.
-  Adjust **server_name**, **root**, **ssl_certificate** and 
   **ssl_certificate_key** to suit your needs.
-  Make sure your SSL certificates are readable by the server (see `Nginx HTTP 
   SSL Module documentation <http://wiki.nginx.org/HttpSslModule>`_).

.. note:: The following example assumes that your ownCloud is installed in
   your webroot. If you're using a subfolder you need to adjust the configuration
   accordingly.

.. code-block:: python

  upstream php-handler {
    server 127.0.0.1:9000;
    #server unix:/var/run/php5-fpm.sock;
  }

  server {
    listen 80;
    server_name cloud.example.com;
    # enforce https
    return 301 https://$server_name$request_uri;  
  }

  server {
    listen 443 ssl;
    server_name cloud.example.com;

    ssl_certificate /etc/ssl/nginx/cloud.example.com.crt;
    ssl_certificate_key /etc/ssl/nginx/cloud.example.com.key;

    # Add headers to serve security related headers
    add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;

    # Path to the root of your installation
    root /var/www/owncloud/;
    # set max upload size 
    client_max_body_size 10G;             
    fastcgi_buffers 64 4K;

    # Disable gzip to avoid the removal of the ETag header
    gzip off;

    # Uncomment if your server is build with the ngx_pagespeed module
    # This module is currently not supported.
    #pagespeed off;

    rewrite ^/caldav(.*)$ /remote.php/caldav$1 redirect;
    rewrite ^/carddav(.*)$ /remote.php/carddav$1 redirect;
    rewrite ^/webdav(.*)$ /remote.php/webdav$1 redirect;

    index index.php;
    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;

    location = /robots.txt {
      allow all;
      log_not_found off;
      access_log off;
    }
    
    # Security improvement translated from apache htaccess to nginx.
    location ~ ^/(?:\.htaccess|data|config|db_structure\.xml|README){
      deny all;
      error_page 403 = /core/templates/403.php;
    }

    location ~ ^/(?:build|tests|config|lib|3rdparty|templates) {
      deny all;
      error_page 403 = /core/templates/403.php;
    }

    location ~ ^/(?:autotest|occ|issue|indie|db_|console).* {
      deny all;
      error_page 403 = /core/templates/403.php;
    }

    location / {
      # The following 2 rules are only needed with webfinger
      rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
      rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

      rewrite ^/.well-known/carddav /remote.php/carddav/ redirect;
      rewrite ^/.well-known/caldav /remote.php/caldav/ redirect;

      rewrite ^(/core/doc/[^\/]+/)$ $1/index.html;

      try_files $uri $uri/ /index.php;
    }

    location ~ \.php(?:$|/) {
      fastcgi_split_path_info ^(.+\.php)(/.+)$;
      include fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_param PATH_INFO $fastcgi_path_info;
      fastcgi_param HTTPS on;
      fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
      fastcgi_pass php-handler;
      fastcgi_intercept_errors on;
    }

    # Adding the cache control header for js and css files
    # Make sure it is BELOW the location ~ \.php(?:$|/) { block
    location ~* \.(?:css|js)$ {
      add_header Cache-Control "public, max-age=7200";
      # Add headers to serve security related headers
      add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
      add_header X-Content-Type-Options nosniff;
      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-XSS-Protection "1; mode=block";
      add_header X-Robots-Tag none;
      # Optional: Don't log access to assets
      access_log off;
    }

    # Optional: Don't log access to other assets
    location ~* \.(?:jpg|jpeg|gif|bmp|ico|png|swf)$ {
      access_log off;
    }
  }

.. note:: You can use ownCloud over plain http, but we strongly encourage you to
          use SSL/TLS to encrypt all of your server traffic, and to protect 
          user's logins and data in transit.

-  Remove the server block containing the redirect
-  Change **listen 443 ssl** to **listen 80;**
-  Remove **ssl_certificate** and **ssl_certificate_key**.
-  Remove **fastcgi_params HTTPS on;**

.. note:: If you are using php-fpm please read :ref:`using_php-fpm`

Suppressing Log Messages
------------------------

If you're seeing meaningless messages in your logfile, for example `client 
denied by server configuration: /var/www/data/htaccesstest.txt 
<https://forum.owncloud.org/viewtopic.php?f=17&t=20217>`_, add this section to 
your Nginx configuration to suppress them::

        location = /data/htaccesstest.txt {
          allow all;
          log_not_found off;
          access_log off;
        }

JavaScript (.js) or CSS (.css) files not served properly
--------------------------------------------------------

A common issue with custom nginx configs is that JavaScript (.js)
or CSS (.css) files are not served properly leading to a 404 (File not found)
error on those files and a broken webinterface.

This could be caused by the::

        location ~* \.(?:css|js)$ {

block shown above not located **below** the::

        location ~ \.php(?:$|/) {

block. Other custom configurations like caching JavaScript (.js)
or CSS (.css) files via gzip could also cause such issues.
