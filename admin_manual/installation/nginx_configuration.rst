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

Note 1
~~~~~~

``fastcgi_buffers 8 4K;``

- Do not set the number of buffers over 63, in our example it is set to 8.
- When exeeding, big file downloads can possibly consume a lot of system memory over time and cause problems especially on low-mem systems.

Note 2
~~~~~~
 
``fastcgi_ignore_headers X-Accel-Buffering;``

- From ownCloud version 10.0.4 on, a header statement will be sent to nginx not to use buffers to avoid problems with problematic ``fastcgi_buffers`` values. See note above.
- If the values of ``fastcgi_buffers`` are properly set and no problems are expected, you can use this directive to reenable buffering **overriding** the sent header.
- In case you use an earlier version of ownCloud or can´t change the buffers, or can´t remove a existing ignore header statement, you can explicitly enable following directive in the location block ``fastcgi_buffering off;``
- The directives ``fastcgi_ignore_headers X-Accel-Buffering;`` and  ``fastcgi_buffering off;`` are used either or but not together.

ownCloud in the web root of NGINX
=================================

The following config should be used when ownCloud is placed in the web root of 
your NGINX installation.

.. literalinclude:: examples/nginx/default-configuration.conf

ownCloud in a subdir of NGINX
=============================

The following config should be used when ownCloud is not in your web root but placed under a different context root of your NGINX installation such as /owncloud or /cloud. The following configuration assumes it is placed under ``/owncloud`` and that you have ``'overwriteweb root' => '/owncloud',`` set in your ``config/config.php``.

.. literalinclude:: examples/nginx/subdirectory-configuration.conf

Troubleshooting
---------------

JavaScript (.js) or CSS (.css) files not served properly
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A common issue with custom NGINX configs is that JavaScript (.js)
or CSS (.css) files are not served properly leading to a 404 (File not found)
error on those files and a broken webinterface.

This could be caused by the:
   
.. code-block:: nginx

  location ~ \.(?:css|js)$ {

block shown above not located **below** the:
   
.. code-block:: nginx

   location ~ \.php(?:$|/) {

block. Other custom configurations like caching JavaScript (.js)
or CSS (.css) files via gzip could also cause such issues.

Not all of my contacts are synchronized
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check your server timeouts! It turns out that CardDAV sync often fails silently if the request runs into timeouts. With PHP-FPM you might see a "CoreDAVHTTPStatusErrorDomain error 504" which is an "HTTP504 Gateway timeout" error. To solve this, first check the ``default_socket_timeout`` setting in ``/etc/php/7.0/fpm/php.ini`` and increase the above ``fastcgi_read_timeout`` accordingly. Depending on your server's performance a timeout of 180s should be sufficient to sync an addressbook of ~1000 contacts.

Performance Tuning
------------------

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

Configure NGINX to use caching for thumbnails
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This mechanism speeds up thumbnail presentation as it shifts requests to NGINX and minimizes 
php invocations which otherwise would take place for every thumbnail presented every time.

**1 Preparation**

- Create a directory where NGINX will save the cached thumbnails. Use any path that fits to your environment. Replace ``{path}`` ... ``/usr/local/tmp/cachezone`` in this example with your path created:
   
::   
   
   sudo mkdir -p /usr/local/tmp/cachezone
   sudo chown www-data:www-data /usr/local/tmp/cachezone

**2 Configuration**

::

   sudo vi /etc/nginx/sites-enabled/{your-ownCloud-nginx-config-file}
   
- **Option 1:** ``map``

  In the ``http{}`` block, but *outside* the ``server{}`` block:
   
.. code-block:: nginx

   # cache_purge
   fastcgi_cache_path /usr/local/tmp/cache levels=1:2 keys_zone=cachezone:100m inactive=60m;
   map $request_uri $skip_cache {
        default              1;
        ~*\/thumbnail.php    0;
        ~*\/apps\/gallery\/  0;
   }

- **Option 2:** ``if``

  In the ``server{}`` block:

.. code-block:: nginx
   
   set $skip_cache 1;
   if ($request_uri ~* "thumbnail.php")      { set $skip_cache 0; }
   if ($request_uri ~* "/apps/gallery/")     { set $skip_cache 0; }

- **General Config:**

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
       
       # skip_cache
       fastcgi_cache_bypass $skip_cache;
       fastcgi_no_cache $skip_cache;
       fastcgi_cache cachezone;
       fastcgi_cache_valid  60m;
       fastcgi_cache_methods GET HEAD;
   }
   
- The ``fastcgi_pass`` parameter:

  In the example above, an ``upstream`` 
  was defined in an NGINX global configuration file.
  This may look like:

.. code-block:: nginx

     upstream php-handler {
        server unix:/var/run/php5-fpm.sock;
           # or
           # server 127.0.0.1:9000;
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
   
Log Optimisation
----------------

Suppressing ``htaccesstest.txt`` Log Messages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you're seeing meaningless messages in your logfile, for example `client 
denied by server configuration: /var/www/data/htaccesstest.txt 
<https://central.owncloud.org/t/htaccesstest-txt-errors-in-logfiles/831>`_,
add this section to your NGINX configuration to suppress them:
   
.. code-block:: nginx

   location = /data/htaccesstest.txt {
       allow all;
       log_not_found off;
       access_log off;
   }

Prevent access log entries when accessing thumbnails
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When using eg. Gallery, any access to a thumbnail of a picture will be logged.
This can cause a massive log quanity making log reading challenging. With this approach,
you can disable access logging for those thumbnails.

**1 Create a map directive outside your server block like**

   (Adopt the path queried according your needs.)
   
.. code-block:: nginx

   # do not access log to gallery thumbnails, flooding access logs only, error will be logged anyway
   map $request_uri $loggable {
       default                              1;
       ~*\/apps\/gallery\/thumbnails        0;
       ~*\/apps2\/gallery\/thumbnails       0;
   }


**2 Inside your server block where you define your logs**
   
.. code-block:: nginx

   access_log /path-to-your-log-file combined if=$loggable;
   
NGINX: cache purging
--------------------

One of the optimizations for ownCloud when using NGINX as the Web server is to 
combine FastCGI caching with "Cache Purge", a `3rdparty NGINX module 
<http://wiki.nginx.org/3rdPartyModules>`_  that adds the ability to purge 
content from `FastCGI`, `proxy`, `SCGI` and `uWSGI` caches. 
 
The following procedure is based on an Ubuntu 14.04 system. You may need to 
adapt it according your OS type and release.

.. note::
   Unlike Apache, NGINX does not dynamically load modules. All modules needed 
   must be compiled into NGINX. This is one of the reasons for NGINX´s 
   performance. It is expected to have an already running NGINX installation 
   with a working configuration set up as described in the ownCloud 
   documentation.

NGINX module check
~~~~~~~~~~~~~~~~~~

As a first step, it is necessary to check if your NGINX installation has the 
``nginx cache purge`` module already compiled in::
 
 nginx -V 2>&1 | grep ngx_cache_purge -o
 
If your output contains ``ngx_cache_purge``, you can continue with the 
configuration, otherwise you need to manually compile NGINX with the module 
needed.

Compile NGINX with the ``nginx-cache-purge`` module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**1. Preparation:**

::

    cd /opt
    wget http://nginx.org/keys/nginx_signing.key
    sudo apt-key add nginx_signing.key
    sudo vi /etc/apt/sources.list.d/nginx.list


- Add the following lines (if different, replace ``{trusty}`` by your distribution name)

::

    deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx
    deb -src http://nginx.org/packages/mainline/ubuntu/ trusty nginx    

- Then run ``sudo apt-get update``

.. note:: 
   If you're not overly cautious and wish to install the latest and 
   greatest NGINX packages and features, you may have to install NGINX from its 
   mainline repository. From the NGINX homepage: "In general, you should 
   deploy NGINX from its mainline branch at all times." If you would like to 
   use standard NGINX from the latest mainline branch but without compiling in 
   any additional modules, just run ``sudo apt-get install nginx``.   

**2 Download the NGINX source from the ppa repository**

::

    cd /opt
    sudo apt-get build-dep nginx
    sudo apt-get source nginx

**3 Download module(s) to be compiled in and configure compiler arguments**
    
:: 
   
    ls -la
    
- Please replace ``{release}`` with the release downloaded

::

    cd /opt/nginx-{release}/debian
    
- If folder "modules" is not present, do:

::

    sudo mkdir modules
    cd modules
    sudo git clone https://github.com/FRiCKLE/ngx_cache_purge.git
    sudo vi /opt/nginx-{release}/debian/rules
    
- If not present, add the following line at the top somewhere under

::

    #export DH_VERBOSE=1:
    MODULESDIR = $(CURDIR)/debian/modules
   
- At the end of every ``configure`` command add

::

  --add-module=$(MODULESDIR)/ngx_cache_purge
    
- In case, don't forget to escape preceeding lines with a backslash ``\``.
- The parameters may now look like

::
      
   --with-cc-opt="$(CFLAGS)" \
   --with-ld-opt="$(LDFLAGS)" \
   --with-ipv6 \
   --add-module=$(MODULESDIR)/ngx_cache_purge

**4 Compile and install NGINX**

::

   cd /opt/nginx-{release}
   sudo dpkg-buildpackage -uc -b
   ls -la /opt
   sudo dpkg --install /opt/nginx_{release}~{distribution}_amd64.deb

**5 Check if the compilation and installation of the ngx_cache_purge module was successful**
   
::  

   nginx -V 2>&1 | grep ngx_cache_purge -o
    
- It should now show: ``ngx_cache_purge``
    
- Show NGINX version including all features compiled and installed

::

   nginx -V 2>&1 | sed s/" --"/"\n\t--"/g

**6 Mark NGINX to be blocked from further updates via apt-get**

::

   sudo dpkg --get-selections | grep nginx
    
- For every NGINX component listed run ``sudo apt-mark hold <component>``. If you do not mark hold, an ``apt-upgrade`` will overwrite your version with default compiled modules. 

**7 Configuration**

- Please see https://github.com/FRiCKLE/ngx_cache_purge for more details

**8 Regular checks for NGINX updates**

- Do a regular visit on the `NGINX news page <http://nginx.org>`_ and proceed in case of updates with items 2 to 6.




