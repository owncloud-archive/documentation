NGINX Configuration
===================

This page covers example NGINX configurations to use with running an ownCloud server. 
Note that NGINX is *not officially supported*, and this page is *community-maintained*.
Thank you, contributors!

-  Depending on your setup, you need to insert the code examples into 
   your NGINX configuration file.
-  Adjust **server_name**, **root**, **ssl_certificate**, **ssl_certificate_key** ect. to suit your needs.
-  Make sure your SSL certificates are readable by the server (see `NGINX HTTP 
   SSL Module documentation <http://wiki.nginx.org/HttpSslModule>`_).
-  ``add_header`` statements are only valid in the current ``location`` block and are not 
   derived or cascaded from or to a different ``location`` block. All necessary ``add_header`` 
   statements **must** be defined in each ``location`` block needed.
-  For better readability it is possible to move *common* ``add_header`` directives into a separate file 
   and include that file wherever necessary. However, each ``add_header`` directive must be written in 
   a single line to prevent connection problems with sync clients.
-  The same is true for ``map`` directives which also can be collected
   into a singe file and then be included.

Example Configurations
----------------------

.. note::
   Be careful about line breaks if you copy the examples, as long lines may be broken for page formatting.

You can use ownCloud over plain HTTP. 
However, *we strongly encourage you* to use SSL/TLS to encrypt all of your server traffic **and** to protect users' logins, and their data while it is in transit.
To use plain HTTP:

#. Remove the server block containing the redirect
#. Change **listen 443 ssl http2** to **listen 80;**
#. Remove all **ssl_** entries.
#. Remove **fastcgi_params HTTPS on;**

.. _fastcgi_buffers_label:

Note 1
~~~~~~

::

  fastcgi_buffers 8 4K;

- Do not set the number of buffers to greater than 63. In our example, it is set to 8.
- If you exceed this maximum, big file downloads may consume a lot of system memory over time. This is especially problematic on low-memory systems.

Note 2
~~~~~~
 
::

  fastcgi_ignore_headers
  X-Accel-Buffering

- From ownCloud version 10.0.4 on, a header will be sent to NGINX not to use buffers to avoid problems with problematic ``fastcgi_buffers`` values. See note above.
- If the values of ``fastcgi_buffers`` are properly set and no problems are expected, you can use this directive to reenable buffering **overriding** the sent header.
- In case you use an earlier version of ownCloud or can´t change the buffers, or can´t remove a existing ignore header directive, you can explicitly enable following directive in the location block ``fastcgi_buffering off;``

.. note::
   The directives ``fastcgi_ignore_headers X-Accel-Buffering;`` and ``fastcgi_buffering off;`` can be used separately but not together.

ownCloud in the web root of NGINX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following config should be used when ownCloud is placed in the web root of your NGINX installation.

The configuration assumes that ownCloud is installed in

  ``/var/www/owncloud`` and is accessed via ``http(s)://cloud.example.com``.

.. literalinclude:: examples/nginx/default-configuration.conf

ownCloud in a subdirectory of NGINX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following config should be used when ownCloud is placed under a different 
context root of your NGINX installation such as /owncloud or /cloud. 

The configuration assumes that ownCloud is installed in

  ``/var/www/owncloud`` is accessed via ``http(s)://example.com/owncloud`` 
 
  and that you have ``'overwriteweb root' => '/owncloud',`` set in your ``config/config.php``.

.. literalinclude:: examples/nginx/subdirectory-configuration.conf

Troubleshooting
---------------

JavaScript (.js) or CSS (.css) files not served properly
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A standard issue with custom NGINX configurations is, that JavaScript (.js) or CSS (.css) files are not served properly, leading to a 404 (File Not Found) error on those files and a broken web interface.

- This could be caused by an improper sequence of ``location`` blocks.

  The following sequence is correct:
   
.. code-block:: nginx

  location ~ \.php(?:$|/) {
   ...
  }
  
  location ~ \.(?:css|js)$ {
   ...
  }

Other custom configurations like caching JavaScript (.js)
or CSS (.css) files via gzip could also cause such issues.

Not all of my contacts are synchronized
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check for server timeouts! 
It turns out that CardDAV sync often fails silently if the request runs into timeouts. 
With PHP-FPM you might see a "CoreDAVHTTPStatusErrorDomain error 504" which is an "HTTP 504 Gateway timeout" error. 
To solve this, first check the ``default_socket_timeout`` setting in ``/etc/php/7.0/fpm/php.ini`` and increase the above ``fastcgi_read_timeout`` accordingly. 
Depending on your server's performance a timeout of 180s should be sufficient to sync an address book of ~1000 contacts.

Windows: Error 0x80070043 "The network name cannot be found." while adding a network drive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The windows native WebDAV client might fail with the following error message::

    Error 0x80070043 "The network name cannot be found." while adding a network drive

A known workaround for this issue is to update your web server configuration.

| Because NGINX does not allow nested `if`_ directives, you need to use the `map`_ directive.
| The position of the `location`_ directive is important for success.

**1 Create a map directive outside your server block**

.. code-block:: nginx

    # Fixes Windows WebDav client error 0x80070043 "The network name cannot be found."
    map "$http_user_agent:$request_method" $WinWebDav {
        default			0;
        "DavClnt:OPTIONS"	1;
    }

**2 Inside your server block on top of your location directives**

.. code-block:: nginx

    location = / {
        if ($WinWebDav) { return 401; }
    }

Log Optimisation
----------------

Suppressing ``htaccesstest.txt`` and ``.ocdata`` Log Messages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are seeing meaningless messages in your logfile, for example `client 
denied by server configuration: /var/www/data/htaccesstest.txt 
<https://central.owncloud.org/t/htaccesstest-txt-errors-in-logfiles/831>`_, 
or access to ``.ocdata``, add this section to your NGINX configuration to suppress them:
   
.. code-block:: nginx

   location = /data/htaccesstest.txt {
       allow all;
       log_not_found off;
       access_log off;
   }

.. code-block:: nginx

   location = /data/\.ocdata {
       access_log off;
   }
   
Prevent access log entries when accessing thumbnails
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When using eg. the Gallery App, any access to a thumbnail of a picture will be logged.
This can cause a massive log quanity making log reading challenging. With this approach,
you can prevent access logging for those thumbnails.

**1 Create a map directive outside your server block like**

   (Adopt the path queried according your needs.)
   
.. code-block:: nginx

   # do not access log to gallery thumbnails, flooding access logs only, error will be logged anyway
   map $request_uri $loggable {
       default                              1;
       ~*\/apps\/gallery\/thumbnails        0;
   }


**2 Inside your server block where you define your logs**

.. code-block:: nginx

   access_log /path-to-your-log-file combined if=$loggable;

If you want or need to log thumbnails access, you can easily add another logfile which only logs this access. 
You can easily enable / disable this kind of logging if you uncomment / comment the line starting with ``0`` in the following ``map`` directive.

**Below the above map statement**

.. code-block:: nginx

   # invert the $loggable variable
   map $loggable $invertloggable {
       default                         0;
       0                               1;
   }

**Below the above access_log statement**

.. code-block:: nginx

   access_log /var/log/nginx/<your-log-file-inverted> combined if=$invertloggable;


Performance Tuning
------------------

**1 HTTP/2**

To increase the performance of your NGINX installation, we recommend using either the SPDY or HTTP_V2 modules, depending on your installed NGINX version.

- nginx (<1.9.5) `ngx_http_spdy_module`_
- nginx (+1.9.5) `ngx_http_v2_module`_

To use HTTP_V2 for NGINX you have to check two things:

1. Be aware that this module may not built in by default, due to a dependency to the OpenSSL version used on your system. It will be enabled with the ``--with-http_v2_module`` configuration parameter during compilation. The dependencies should be checked automatically. You can check the presence of ``ngx_http_v2_module`` by using the command: ``nginx -V 2>&1 | grep http_v2 -o``. A description of how to compile NGINX to include modules can be found in `Compiling Modules`_.
2. When changing from `SPDY`_ to `HTTP v2`_, the NGINX config has to be changed from ``listen 443 ssl spdy;`` to ``listen 443 ssl http2;``

**2 Caching Metadata**

The ``open_file_cache`` directive can help you to cache file metadata information. This can increase performance on high loads respectively when using eg NFS as backend.
That cache can store:

- Open file descriptors, their sizes and modification times;
- Information on existence of directories;
- File lookup errors, such as “file not found”, “no read permission”, and so on.

To configure metadata caching, add following directives either in your http, server or location block:

.. code-block:: nginx

        open_file_cache                 max=10000 inactive=5m;
        open_file_cache_valid           1m;
        open_file_cache_min_uses        1;
        open_file_cache_errors          on;


Configure NGINX to use caching for ownCloud internal images and thumbnails 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This mechanism speeds up presentation as it shifts requests to NGINX and minimizes PHP invocations, which otherwise would take place for every thumbnail or internal image presented every time.

**1 Preparation**

- Create a directory where NGINX will save the cached thumbnails or internal images. Use any path that fits to your environment. Replace ``/opt/cachezone`` in this example with your path created:
   
.. code-block:: bash  
   
   sudo mkdir -p /opt/cachezone
   sudo chown www-data:www-data /opt/cachezone

**2 Configuration**

a. **Define when to skip the cache:**
   
- **Option 1:** ``map``

  This is the preferred method. 
  In the ``http{}`` block, but *outside* the ``server{}`` block:
   
.. code-block:: nginx

   # skip_cache, default skip
   map $request_uri $skip_cache {
        default              1;
        ~*\/thumbnail.php    0;
        ~*\/apps\/gallery\/  0;
        ~*\/core\/img\/      0;
   }

- **Option 2:** ``if``

  In the ``server{}`` block, above the location block mentioned below:

.. code-block:: nginx
   
   set $skip_cache 1;
   if ($request_uri ~* "thumbnail.php")      { set $skip_cache 0; }
   if ($request_uri ~* "/apps/gallery/")     { set $skip_cache 0; }
   if ($request_uri ~* "/core/img/")         { set $skip_cache 0; }
   
b. **General Config:**

  In case you want to have multiple cache paths with different cache keys, follow the NGINX documentation where to place the directives. 
  For the sake of simplicity, we both add them to the ``http{}`` block.
  
- Add *inside* the ``http{}`` block:

.. code-block:: nginx

   fastcgi_cache_path /opt/cache levels=1:2 keys_zone=cachezone:100m 
                      max_size=500m inactive=60m use_temp_path=off;
   fastcgi_cache_key $http_cookie$request_method$host$request_uri;


- Add *inside* the ``server{}`` block the following FastCGI caching directives, as an example of a configuration:

.. code-block:: nginx

   location ~ \.php(?:$/) {
       fastcgi_split_path_info ^(.+\.php)(/.+)$;
       
       include fastcgi_params;
       # ...

       ## Begin - FastCGI caching
       fastcgi_ignore_headers  "Cache-Control"
                               "Expires"
                               "Set-Cookie";
       fastcgi_cache_use_stale error
                               timeout
                               updating
                               http_429
                               http_500
                               http_503;
       fastcgi_cache_background_update on;
       fastcgi_no_cache $skip_cache;
       fastcgi_cache_bypass $skip_cache;
       fastcgi_cache cachezone;
       fastcgi_cache_valid  60m;
       fastcgi_cache_methods GET HEAD;
       ## End - FastCGI caching

   }
     
**3 Test the configuration**

::

   sudo nginx -t
   sudo service nginx reload
   
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
   

.. Links
 
.. _NGINX HTTP SSL Module documentation: http://wiki.nginx.org/HttpSslModule
.. _client denied by server configuration: https://central.owncloud.org/t/htaccesstest-txt-errors-in-logfiles/831
.. _ngx_http_v2_module: http://nginx.org/en/docs/http/ngx_http_v2_module.html
.. _ngx_http_spdy_module: http://nginx.org/en/docs/http/ngx_http_spdy_module.html
.. _Compiling Modules: https://www.nginx.com/resources/wiki/extending/compiling
.. _SPDY: https://www.maxcdn.com/one/visual-glossary/spdy/ 
.. _HTTP v2: https://tools.ietf.org/html/rfc7540
.. _Cache Purge: https://github.com/FRiCKLE/ngx_cache_purge
.. _if: http://nginx.org/en/docs/http/ngx_http_rewrite_module.html
.. _map: http://nginx.org/en/docs/http/ngx_http_map_module.html
.. _location: http://nginx.org/en/docs/http/ngx_http_core_module.html#location
