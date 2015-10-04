.. _nginx_configuration_example:

===================
Nginx Configuration
===================

-  You need to insert the following code into **your nginx config file.**
-  The config assumes that ownCloud is installed in /var/www/owncloud
-  Adjust **server_name**, **root**, **ssl_certificate** and 
   **ssl_certificate_key** to suit your needs.
-  Make sure your SSL certificates are readable by the server (see `Nginx HTTP 
   SSL Module documentation <http://wiki.nginx.org/HttpSslModule>`_).

Serving at https(s)://cloud.example.com
---------------------------------------

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

    location ~ ^/(?:\.htaccess|data|config|db_structure\.xml|README){
      deny all;
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

     # Optional: set long EXPIRES header on static assets
     location ~* \.(?:jpg|jpeg|gif|bmp|ico|png|css|js|swf)$ {
         expires 30d;
         # Optional: Don't log access to assets
           access_log off;
     }

    }

Serving at https(s)://example.com/owncloud
------------------------------------------

.. note:: Assumes php-fpm; :ref:`using_php-fpm`

.. code-block:: python


    server {
        listen 80;
        server_name example.com;
        # enforce https
        return 301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl;
        server_name example.com;

        ssl_certificate /etc/ssl/nginx/cloud.example.com.crt;
        ssl_certificate_key /etc/ssl/nginx/cloud.example.com.key;

        # Add headers to serve security related headers
        add_header Strict-Transport-Security "max-age=0; includeSubDomains; preload;";
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag none;

        # Path to the root of your website (one level above owncloud folder)
        root /var/www;
        # set max upload size
        client_max_body_size 10G;
        fastcgi_buffers 64 4K;

        # Disable gzip to avoid the removal of the ETag header
        gzip off;

        # Uncomment if your server is build with the ngx_pagespeed module
        # This module is currently not supported.
        #pagespeed off;

        # ownCloud blacklist
        location ~ ^/owncloud/(?:\.htaccess|data|config|db_structure\.xml|README) {
            deny all;
            error_page 403 = /owncloud/core/templates/403.php;
        }

        index index.php;

        location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
        }

        location ~ ^/(?:\.htaccess|data|config|db_structure\.xml|README){
            deny all;
        }

        location /owncloud {
            error_page 403 = /owncloud/core/templates/403.php;
            error_page 404 = /owncloud/core/templates/404.php;

            rewrite ^/owncloud/caldav(.*)$ /remote.php/caldav$1 redirect;
            rewrite ^/owncloud/carddav(.*)$ /remote.php/carddav$1 redirect;
            rewrite ^/owncloud/webdav(.*)$ /remote.php/webdav$1 redirect;

            rewrite ^(/owncloud/core/doc[^\/]+/)$ $1/index.html;

            # The following rules are only needed with webfinger
            rewrite ^/owncloud/.well-known/host-meta /public.php?service=host-meta last;
            rewrite ^/owncloud/.well-known/host-meta.json /public.php?service=host-meta-json last;
            rewrite ^/owncloud/.well-known/carddav /remote.php/carddav/ redirect;
            rewrite ^/owncloud/.well-known/caldav /remote.php/caldav/ redirect;

            try_files $uri $uri/ index.php;
        }

        location ~ \.php(?:$|/) {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param HTTPS on;
            fastcgi_pass unix:/var/run/php5-fpm.sock;
        }

        location / {
             root /var/www/html/;
             index index.html;
        }

        # Optional: set long EXPIRES header on static assets
        location ~* \.(?:jpg|jpeg|gif|bmp|ico|png|css|js|swf)$ {
            expires 30d;
            # Optional: Don't log access to assets
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
<https://forum.owncloud.org/viewtopic.php?f=17&t=20217>_`, add this section to 
your Nginx configuration to suppress them::

         location = /data/htaccesstest.txt {
            allow all;
            log_not_found off;
            access_log off;
        }
