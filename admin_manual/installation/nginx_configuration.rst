NGINX Configuration
===================

This page covers example NGINX configurations to use with running an ownCloud server. 
Note that NGINX is *not officially supported*, and this page is *community-maintained*. 
Thank you, contributors!

-  You need to insert the following code into **your NGINX configuration file.**
-  The configuration assumes that ownCloud is installed in ``/var/www/owncloud`` and that it is accessible via 
   ``http(s)://cloud.example.com``.
-  Adjust ``server_name``, ``root``, ``ssl_certificate`` and ``ssl_certificate_key`` to suit your needs.
-  Make sure your SSL certificates are readable by the server (see the `NGINX HTTP SSL Module documentation`_).
-  ``add_header`` statements are only taken from the current level and are not cascaded from or to a different level. All necessary ``add_header`` statements must be defined in each level needed. For better readability, it is possible to move *common* ``add_header`` statements into a separate file and to include that file wherever necessary. However, each ``add_header`` statement must be written on a single line to prevent connection problems with sync clients.

Example Configurations
----------------------

.. note::
   Be careful about line breaks if you copy the examples, as long lines may be broken for page formatting!
   Thanks to `@josh4trunks <https://github.com/josh4trunks>`_ for providing/creating these configuration examples.

You can use ownCloud over plain HTTP. 
However, *we strongly encourage you* to use SSL/TLS to encrypt all of your server traffic **and** to protect users' logins, and their data while it is in transit.
To use plain HTTP:

#. Remove the server block containing the redirect
#. Change ``listen 443 ssl http2`` to ``listen 80;``
#. Remove all ``ssl_`` entries.
#. Remove ``fastcgi_params HTTPS on;``

.. _fastcgi_buffers_label:

**Note 1**

::

  fastcgi_buffers 8 4K;

- Do not set the number of buffers to greater than 63. In our example, it is set to 8.
- If you exceed this maximum, big file downloads may consume a lot of system memory over time. This is especially problematic on low-memory systems.

**Note 2**

::

  fastcgi_ignore_headers X-Accel-Buffering;

- From ownCloud version 10.0.4 on, a header statement will be sent to NGINX telling it not to use buffers to avoid problems with problematic ``fastcgi_buffers`` values. `See note above <fastcgi_buffers_label>`_.
- If these values are properly set, and no problems are expected, you can turn on this statement to re-enable buffering overriding the sent header.
- In case you use an earlier version of ownCloud, can´t change the buffers, or you can´t remove an existing ignore header statement, you can explicitly set ``fastcgi_buffering off;``

.. note::
   These statements can be used separately but not together.

ownCloud in the web root of NGINX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following config should be used when ownCloud is placed in the web root of your NGINX installation.

.. literalinclude:: examples/nginx/default-configuration.conf

ownCloud in a sub directory of NGINX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following config should be used when ownCloud is not in your web root but placed under a different context root of your NGINX installation, such as ``/owncloud`` or ``/cloud``. 
The following configuration assumes that: 

#. It is placed under ``/owncloud`` 
#. You have ``'overwriteweb root' => '/owncloud',`` set in your ``config/config.php``.

.. literalinclude:: examples/nginx/subdirectory-configuration.conf

Troubleshooting
---------------

Suppressing Log Messages
~~~~~~~~~~~~~~~~~~~~~~~~

If you see meaningless messages in your log file, for example `client denied by server configuration`_ (/var/www/data/htaccesstest.txt), add this section to your NGINX configuration to suppress them:
   
.. code-block:: nginx

   location = /data/htaccesstest.txt {
       allow all;
       log_not_found off;
       access_log off;
   }

JavaScript (.js) or CSS (.css) files not served properly
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A standard issue with custom NGINX configurations is that JavaScript (.js) or CSS (.css) files are not served properly, leading to a 404 (File Not Found) error on those files and a broken web interface.
This could be caused by "*Block 1*", if it’s located above "*Block 2*":
 
Block 1
^^^^^^^
 
.. code-block:: nginx

  location ~ \.(?:css|js)$ {
 
Block 2
^^^^^^^

   
.. code-block:: nginx

   location ~ \.php(?:$|/) {

Other custom configurations like caching JavaScript (.js) or CSS (.css) files via GZIP could also cause such issues.

Not all of my contacts are synchronized
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check for server timeouts! 
It turns out that CardDAV sync often fails silently if the request runs into timeouts. 
With PHP-FPM you might see a "CoreDAVHTTPStatusErrorDomain error 504" which is an "HTTP 504 Gateway timeout" error. 
To solve this, first check the ``default_socket_timeout`` setting in ``/etc/php/7.0/fpm/php.ini`` and increase the above ``fastcgi_read_timeout`` accordingly. 
Depending on your server's performance a timeout of 180s should be sufficient to sync an address book of ~1000 contacts.

Performance Tuning
------------------

To increase the performance of your NGINX installation, we recommend using either the SPDY or HTTP_V2 modules, depending on your installed NGINX version.

- `nginx (<1.9.5) <ngx_http_spdy_module <http://nginx.org/en/docs/http/ngx_http_spdy_module.html>`_
- `nginx (+1.9.5) <ngx_http_http2_module <http://nginx.org/en/docs/http/ngx_http_v2_module.html>`_

To use `ngx_http_v2_module`_, you have to check two things:

1. Be aware that this module is not built in by default, due to a dependency to the OpenSSL version used on your system. It will be enabled with the ``--with-http_v2_module`` configuration parameter during compilation. The dependency should be checked automatically. You can check the presence of ``ngx_http_v2_module`` by using the command: ``nginx -V 2>&1 | grep http_v2 -o``. An example of how to compile NGINX can be found in the section "Configure NGINX with the ``nginx-cache-purge`` module" below.

2. When you have used `SPDY`_ before, the NGINX config has to be changed from ``listen 443 ssl spdy;`` to ``listen 443 ssl http2;``

NGINX: caching ownCloud gallery thumbnails
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

One of the optimizations for ownCloud when using NGINX as the web server is to combine FastCGI caching with the `Cache Purge`_ module. 
Cache Purge is a `3rdparty NGINX module`_  that adds the ability to purge content from `FastCGI`, `proxy`, `SCGI` and `uWSGI` caches. 

This mechanism speeds up thumbnail presentation as it shifts requests to NGINX and minimizes PHP invocations, which otherwise would take place for every thumbnail presented every time.
 
The following procedure is based on an Ubuntu 14.04 system. 
You may need to adapt it according to your OS type and release.

.. note::
   Unlike Apache, NGINX does not dynamically load modules. All modules needed must be compiled into NGINX. This is one of the reasons for NGINX´s performance. It is expected to have an already running NGINX installation with a working configuration set up as described in the ownCloud documentation.

NGINX module check
~~~~~~~~~~~~~~~~~~

As a first step, it is necessary to check if your NGINX installation has the ``nginx cache purge`` module compiled in. 
You can do this by running the following command:

::
 
 nginx -V 2>&1 | grep ngx_cache_purge -o
 
If your output contains ``ngx_cache_purge``, you can continue with the configuration; otherwise, you need to manually compile NGINX with the module needed.

Compile NGINX with the ``nginx-cache-purge`` module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Preparation
^^^^^^^^^^^

::

    cd /opt
    wget http://nginx.org/keys/nginx_signing.key
    sudo apt-key add nginx_signing.key
    sudo vi /etc/apt/sources.list.d/nginx.list
    
Add the following lines (if different, replace ``{trusty}`` by your distribution name).

::


Then run ``sudo apt-get update``.

.. note:: 
   If you're not overly cautious and wish to install the latest and greatest NGINX packages and features, you may have to install NGINX from its mainline repository. From the NGINX homepage: "*In general, you should deploy NGINX from its mainline branch at all times*." If you would like to use standard NGINX from the latest mainline branch without compiling in any additional modules, run: ``sudo apt-get install nginx``.   

Download the NGINX source from the ppa repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    cd /opt
    sudo apt-get build-dep nginx
    sudo apt-get source nginx

Download module(s) to be compiled in and configure compiler arguments
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
:: 
   
    ls -la
    
Please replace ``{release}`` with the release downloaded.

::

::

    cd /opt/nginx-{release}/debian
    
- If folder "modules" is not present, do:

::

    sudo mkdir modules
    cd modules
    sudo git clone https://github.com/FRiCKLE/ngx_cache_purge.git
    sudo vi /opt/nginx-{release}/debian/rules
    
If not present, add the following line at the top under

::

    #export DH_VERBOSE=1:
    MODULESDIR = $(CURDIR)/debian/modules
   
And at the end of every ``configure`` command add:

::

  --add-module=$(MODULESDIR)/ngx_cache_purge
    
Don't forget to escape preceding lines with a backslash ``\``.
The parameters may now look like:

::
      
   --with-cc-opt="$(CFLAGS)" \
   --with-ld-opt="$(LDFLAGS)" \
   --with-ipv6 \
   --add-module=$(MODULESDIR)/ngx_cache_purge

Compile and install NGINX
^^^^^^^^^^^^^^^^^^^^^^^^^

::

   cd /opt/nginx-{release}
   sudo dpkg-buildpackage -uc -b
   ls -la /opt
   sudo dpkg --install /opt/nginx_{release}~{distribution}_amd64.deb

Check if the compilation and installation of the ngx_cache_purge module was successful
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   nginx -V 2>&1 | grep ngx_cache_purge -o

It should now show: ``ngx_cache_purge``.
Show NGINX version including all features compiled and installed, by running the following command:

::

   nginx -V 2>&1 | sed s/" --"/"\n\t--"/g

Mark NGINX to be blocked from further updates via apt-get
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   sudo dpkg --get-selections | grep nginx
    
For every NGINX component listed run ``sudo apt-mark hold <component>``.

Regular checks for NGINX updates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Do a regular visit on the `NGINX news page`_ and proceed in case of updates with items 2 to 5.

Configure NGINX with the ``nginx-cache-purge`` module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Preparation
^^^^^^^^^^^

Create a directory where NGINX will save the cached thumbnails. 
Use any path that fits to your environment. 
Replace ``{path}`` in this example with your path created:
   
::   
   
   sudo mkdir -p /usr/local/tmp/cache   

Configuration
^^^^^^^^^^^^^

.. note:: 
   Please adopt or delete any regex line in the ``map`` block according your needs and the ownCloud version used. As an alternative to mapping, you can use as many ``if`` statements in your server block as necessary:
   
.. code-block:: nginx
   
   set $skip_cache 1;
   if ($request_uri ~* "thumbnail.php")      { set $skip_cache 0; }
   if ($request_uri ~* "/apps/galleryplus/") { set $skip_cache 0; }
   if ($request_uri ~* "/apps/gallery/")     { set $skip_cache 0; }

Add *inside* the ``server{}`` block, as an example of a configuration:
   
.. code-block:: nginx
   
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
   
.. note:: 
   Note regarding the ``fastcgi_pass`` parameter:
   
   Use whatever fits your configuration. In the example above, an ``upstream`` was defined in an NGINX global configuration file. This may look like:
   
.. code-block:: nginx
       
   upstream php-handler {
       server unix:/var/run/php5-fpm.sock;
       # or
       # server 127.0.0.1:9000;
   } 
   
Test the configuration
^^^^^^^^^^^^^^^^^^^^^^

::

   sudo nginx -s reload
   
*  Open your browser and clear your cache.   
*  Login to your ownCloud instance, open the gallery app, move thru your folders and watch while the thumbnails are generated for the first time.
*  You may also watch with, e.g. ``htop`` your system load while the 
   thumbnails are processed.
*  Go to another app or logout and logon again.
*  Open the gallery app again and browse to the folders you accessed before. Your thumbnails should appear more or less immediately.
*  ``htop`` will not show up additional load while processing, compared to the high load before.

Prevent access log entries when accessing thumbnails
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When using Gallery or Gallery+, any access to a thumbnail of a picture will be logged.
This can cause a massive log quantity making log reading challenging. With this approach, you can disable access logging for those thumbnails.

Create a map directive outside your server block like
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::
   Adopt the path queried according to your needs.
   
.. code-block:: nginx

   # do not access log to gallery thumbnails, flooding access logs only, error will be logged anyway
   map $request_uri $loggable {
       default 1;
       ~*\/apps\/gallery\/thumbnails           0;
       ~*\/apps\/galleryplus\/thumbnails       0;
   }


Inside your server block where you define your logs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   
.. code-block:: nginx

   access_log /path-to-your-log combined if=$loggable;
   
.. Links
   
.. _NGINX HTTP SSL Module documentation: http://wiki.nginx.org/HttpSslModule
.. _client denied by server configuration: https://central.owncloud.org/t/htaccesstest-txt-errors-in-logfiles/831
.. _ngx_http_v2_module: http://nginx.org/en/docs/http/ngx_http_v2_module.html
.. _SPDY: https://www.maxcdn.com/one/visual-glossary/spdy/ 
.. _Cache Purge: https://github.com/FRiCKLE/ngx_cache_purge
