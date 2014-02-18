Manual Installation
-------------------

If you do not want to use packages, here is how you setup ownCloud on from scratch
using a classic :abbr:`LAMP (Linux, Apache, MySQL, PHP)` setup:

Prerequisites
~~~~~~~~~~~~~

This tutorial assumes you have terminal access to the machine you want to install
owncloud on. Although this is not an absolute requirement, installation without it
is highly likely to require contacting your hoster (e.g. for installing required
modules).

To run ownCloud, your web server must have the following installed:

* PHP (>= 5.3.3 minimum, 5.4 or higher recommended)
* PHP module ctype
* PHP module dom
* PHP module GD
* PHP module iconv
* PHP module JSON
* PHP module libxml
* PHP module mb multibyte
* PHP module SimpleXML
* PHP module zip
* PHP module zlib

Database connectors (pick at least one):

* PHP module sqlite (>= 3)
* PHP module mysql
* PHP module pgsql (requires PostgreSQL >= 9.0)

And as *recommended* packages:

* PHP module curl (highly recommended, some functionality, e.g. http user authentication, depends on this)
* PHP module fileinfo (highly recommended, enhances file analysis performance)
* PHP module bz2 (recommended, required for extraction of apps)
* PHP module intl (increases language translation performance)
* PHP module mcrypt (increases file encryption performance)
* PHP module openssl (required for accessing HTTPS resources)

Required for specific apps (if you use the mentioned app, you must install that package):

* PHP module ldap (for ldap integration)
* smbclient (for SMB storage)
* PHP module ftp (for FTP storage)

Recommended for specific apps (*optional*):

* PHP module exif (for image rotation in pictures app)

For enhanced performance (*optional* / select one of the following):

* PHP module apc
* PHP module apcu
* PHP module xcache

For preview generation (*optional*):

* PHP module imagick
* avconv or ffmpeg
* OpenOffice or libreOffice

Please check your distribution, operating system or hosting partner documentation
on how to install/enable these modules.


If you are running Ubuntu 10.04 LTS you will need to update your PHP from
this `PHP PPA`_:

::

  sudo add-apt-repository ppa:ondrej/php5
  sudo apt-get update
  sudo apt-get install php5
  
For example, on an Ubuntu 12.04 LTS machine, you would install the required and
recommended modules for a typical owncloud install using apache and mysql
(without any special apps - see list above for details) by issuing the following
command in the terminal:
::

  sudo apt-get install apache2 mysql-server libapache2-mod-php5 php5-gd php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-imagick


**Note:** You don’t need any WebDAV support of your web server (i.e. apache’s mod_webdav)
to access your ownCloud data via WebDAV, ownCloud has a WebDAV server built in.
In fact, you should make sure that any built-in WebDAV module of your web server
is disabled (at least for the ownCloud directory), as it can interfere with
ownCloud's built-in WebDAV support.

Download, extract and copy ownCloud to Your Web Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

First, download the archive of the latest ownCloud version:

* Navigate to `http://owncloud.org/install`
* Click "Tar or Zip file"
* In the opening dialog, chose the "Linux" link.

This will download a file named owncloud-x.y.z.tar.bz2 (where x.y.z is the
version number of the current latest version). Save this file on the machine
you want to install ownCloud on. If that's a different machine than the one you
are currently working on, use e.g. FTP to transfer the downloaded archive file
there. Note down the directory where you put the file.

Then you have to extract the archive contents. Open a terminal on the machine
you plan to run owncloud on, and run:
::

  cd path/to/downloaded/archive
  tar -xjf owncloud-x.y.z.tar.bz2

where path/to/downloaded/archive is to be replaced by the path where you put
the downloaded archive, and x.y.z of course has to be replaced by the actual
version number as in the file you have downloaded.
  
Finally - if you haven't already extracted the files in the document root
of your webserver - execute also the following command::

  cp -r owncloud /path/to/your/webserver/document-root

If you don't know where your webserver's document root is located, consult
its documentation. For apache, see e.g. here:
`http://www.cyberciti.biz/faq/howto-find-unix-linux-apache-documentroot/`
For Ubuntu for example, this would usually be /var/www.

Set the Directory Permissions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The owner of your web server must own the apps/, data/ and config/ directories
in your ownCloud install. You can do this by running the following command for
the apps, data and config directories.

For Debian based distributions like Ubuntu, Debian or Linux Mint and Gentoo use::

  chown -R www-data:www-data /path/to/your/owncloud/install/data

For ArchLinux use::

  chown -R http:http /path/to/your/owncloud/install/data

Fedora users should use::

  chown -R apache:apache /path/to/your/owncloud/install/data

.. note:: The **data/** directory will only be created after setup has run (see below) and is not present by default in the tarballs.
When using an NFS mount for the data directory, do not change ownership as above.  The simple act of mounting the drive will set proper permissions for ownCloud to write to the directory.  Changing ownership as above could result in some issues if the NFS mount is lost.

Web Server Configuration
~~~~~~~~~~~~~~~~~~~~~~~~

Apache is the recommended web server.

Apache Configuration
********************

Example Apache 2.2:

.. code-block:: xml

    <Directory /path/to/your/owncloud/install>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>


Example Apache 2.4:

.. code-block:: xml

    <Directory /path/to/your/owncloud/install>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>


Enable mod_rewrite::

	a2enmod rewrite

In distributions that do not come with a2enmod the :file:`/etc/httpd/httpd.conf` needs to be changed to enable **mod_rewrite**

Then restart apache. For Ubuntu systems (or distributions using upstartd) use::

	service apache2 restart

For systemd systems (Fedora, ArchLinux, OpenSUSE) use::

	systemctl restart httpd.service

In order for the maximum upload size to be configurable, the .htaccess file in the ownCloud folder needs to be made writable by the server.



Nginx Configuration
*******************

-  You need to insert the following code into **your nginx config file.**
-  Adjust **server_name**, **root**, **ssl_certificate** and **ssl_certificate_key** to suit your needs.
-  Make sure your SSL certificates are readable by the server (see `http://wiki.nginx.org/HttpSslModule`_).

.. code-block:: python

    upstream php-handler {
            server 127.0.0.1:9000; 
            #server unix:/var/run/php5-fpm.sock;
    }

    server {
            listen 80;
            server_name cloud.example.com;
            return 301 https://$server_name$request_uri;  # enforce https
    }

    server {
            listen 443 ssl;
            server_name cloud.example.com;

            ssl_certificate /etc/ssl/nginx/cloud.example.com.crt;
            ssl_certificate_key /etc/ssl/nginx/cloud.example.com.key;

            # Path to the root of your installation
            root /var/www/;

            client_max_body_size 10G; # set max upload size
            fastcgi_buffers 64 4K;

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

            location ~ ^/(data|config|\.ht|db_structure\.xml|README) {
                    deny all;
            }

            location / {
                    # The following 2 rules are only needed with webfinger
                    rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
                    rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

                    rewrite ^/.well-known/carddav /remote.php/carddav/ redirect;
                    rewrite ^/.well-known/caldav /remote.php/caldav/ redirect;

                    rewrite ^(/core/doc/[^\/]+/)$ $1/index.html;

                    try_files $uri $uri/ index.php;
            }

            location ~ ^(.+?\.php)(/.*)?$ {
                    try_files $1 = 404;

                    include fastcgi_params;
                    fastcgi_param SCRIPT_FILENAME $document_root$1;
                    fastcgi_param PATH_INFO $2;
                    fastcgi_param HTTPS on;
                    fastcgi_pass php-handler;
            }

            # Optional: set long EXPIRES header on static assets
            location ~* ^.+\.(jpg|jpeg|gif|bmp|ico|png|css|js|swf)$ {
                    expires 30d;
                    # Optional: Don't log access to assets
                    access_log off;
            }

    }

.. note:: You can use ownCloud without SSL/TLS support, but we strongly encourage you not to do that:

-  Remove the server block containing the redirect
-  Change **listen 443 ssl** to **listen 80;**
-  Remove **ssl_certificate** and **ssl_certificate_key**.
-  Remove **fastcgi_params HTTPS on;**

.. note:: If you want to effectively increase maximum upload size you will also have to modify your **php-fpm configuration** (**usually at
          /etc/php5/fpm/php.ini**) and increase **upload_max_filesize** and
          **post_max_size** values. You’ll need to restart php5-fpm and nginx
	  services in order these changes to be applied.

Lighttpd Configuration
**********************

This assumes that you are familiar with installing PHP application on
lighttpd.

It is important to note that the **.htaccess** files used by ownCloud to protect the **data** folder are ignored by
lighttpd, so you have to secure it by yourself, otherwise your **owncloud.db** database and user data are publicly
readable even if directory listing is off. You need to add two snippets to your lighttpd configuration file:

Disable access to data folder::

    $HTTP["url"] =~ "^/owncloud/data/" {
         url.access-deny = ("")
       }

Disable directory listing::

    $HTTP["url"] =~ "^/owncloud($|/)" {
         dir-listing.activate = "disable"
       }

Yaws Configuration
******************

This should be in your **yaws_server.conf**. In the configuration file, the
**dir_listings = false** is important and also the redirect from **/data**
to somewhere else, because files will be saved in this directory and it
should not be accessible from the outside. A configuration file would look
like this

.. code-block:: xml

    <server owncloud.myserver.com/>
            port = 80
            listen = 0.0.0.0
            docroot = /var/www/owncloud/src
            allowed_scripts = php
            php_handler = <cgi, /usr/local/bin/php-cgi>
            errormod_404 = yaws_404_to_index_php
            access_log = false
            dir_listings = false
            <redirect>
                    /data == /
            </redirect>
    </server>


The apache **.htaccess** file that comes with ownCloud is configured to
redirect requests to nonexistent pages. To emulate that behaviour, you
need a custom error handler for yaws. See this `github gist for further instructions`_ on how to create and compile that error handler.

Hiawatha Configuration
**********************

Add **WebDAVapp = yes** to the ownCloud virtual host. Users accessing
WebDAV from MacOS will also need to add **AllowDotFiles = yes**.

Disable access to data folder::

    UrlToolkit {
        ToolkitID = denyData
        Match ^/data DenyAccess
    }



Microsoft Internet Information Server (IIS)
*******************************************

See :doc:`installation_windows` for further instructions.

Follow the Install Wizard
~~~~~~~~~~~~~~~~~~~~~~~~~
Open your web browser and navigate to your ownCloud instance. If you are
installing ownCloud on the same machine as you will access the install wizard
from, the url will be: http://localhost/ (or http://localhost/owncloud).

For basic installs we recommend SQLite as it is easy to setup (ownCloud will do it for you). For larger installs you
should use MySQL or PostgreSQL. Click on the Advanced options to show the configuration options. You may enter admin
credentials and let ownCloud create its own database user, or enter a preconfigured user.  If you are not using apache
as the web server, please set the data directory to a location outside of the document root. See the advanced
install settings.


.. _PHP PPA: https://launchpad.net/~ondrej/+archive/php5
.. _github gist for further instructions: https://gist.github.com/2200407
.. _`http://wiki.nginx.org/HttpSslModule`: http://wiki.nginx.org/HttpSslModule
