Manual Installation
-------------------

If you do not want to use packages, here is how you setup ownCloud on
from scratch using a classic :abbr:`LAMP (Linux, Apache, MySQL, PHP)` setup:

Prerequisites
~~~~~~~~~~~~~

.. note:: This tutorial assumes you have terminal access to the machine you want
          to install owncloud on. Although this is not an absolute requirement,
          installation without it is highly likely to require contacting your
          hoster (e.g. for installing required modules).

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

*Recommended* packages:

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

For enhanced performance (*optional* / select only one of the following):

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
  
For example, on a machine running a pristine Ubuntu 12.04.4 LTS server, you would
install the required and recommended modules for a typical owncloud install by
issuing the following commands in a terminal:
::

	sudo apt-get install apache2 mysql-server libapache2-mod-php5
	sudo apt-get install php5-gd php5-json php5-mysql php5-curl
	sudo apt-get install php5-intl php5-mcrypt php5-imagick

At the execution of each of the above commands you might be prompted whether you
want to continue; press "Y" for Yes (that is if your system language is english.
You might have to press a different key if you have a different system language).

At the installation of the mysql server, you will be prompted for a root password.
Be sure to remember that password for later use.

This installs the packages for the ownCloud core system. If you are planning on
running additional apps, keep in mind that they might require additional packages.
See the list above for details.

As webserver, apache will be used, and mysql as database engine. If you want to
use a different web- or database server, you'll have to consult the documentation
of your distributions or of the respective softwares on which packages to install.

.. note:: You don’t need any WebDAV support module for your web server (i.e.
          apache’s mod_webdav) to access your ownCloud data via WebDAV. ownCloud
          has built-in WebDAV server of its own.

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

	sudo cp -r owncloud /path/to/your/webserver/document-root

to copy the ownCloud files to their final destination directly inside the
document root of your webserver.

If you don't know where your webserver's document root is located, consult its
documentation. For apache, see e.g. here:
`http://www.cyberciti.biz/faq/howto-find-unix-linux-apache-documentroot/`.
For Ubuntu for example, this would usually be /var/www.

.. note:: The above assumes you want to install ownCloud into a subdirectory
          "owncloud" on your webserver. For installing it anywhere else, you'll
          have to adapt the above commands accordingly.
          
.. note:: You can also install ownCloud in a directory outside of the document
          root. You will then however have to either set up a link to the
          owncloud folder from somewhere in the document root (provided your
          apache configuration allows linking), or create an alias for it in
          the apache configuration. See your webserver documentation on how to
          do so.

Set the Directory Permissions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The owner of your web server must own the apps/, data/ and config/ directories
in your ownCloud install. You can do this by running the following command for
the apps, data and config directories.

For Debian-based distributions like Ubuntu, Debian or Linux Mint and Gentoo use::

	sudo chown -R www-data:www-data /path/to/your/owncloud/install/data
  
For the typical install location in /var/www as  given above, you would e.g. run::

	sudo chown -R www-data:www-data /var/www/owncloud

For ArchLinux should run (as root)::

	chown -R http:http /path/to/your/owncloud/install/data

Fedora users should run (as root)::

	chown -R apache:apache /path/to/your/owncloud/install/data

.. note:: The **data/** directory will only be created after setup has run
          (see below) and is not present by default in the tarballs.
When using an NFS mount for the data directory, do not change ownership as above.
The simple act of mounting the drive will set proper permissions for ownCloud to
write to the directory. Changing ownership as above could result in some issues
if the NFS mount is lost.

Web Server Configuration
~~~~~~~~~~~~~~~~~~~~~~~~

.. note:: You can use ownCloud without SSL/TLS support, but we strongly encourage
          you not to do that. If you don't use it, and you for example access your
          ownCloud over an unsecured WiFi, everyone can grab your authentication
          data or the content of files synchronized while on the WiFi.

Apache is the recommended web server.

Apache Configuration
********************

Enabling SSL
............

The following basic guide will just describe how to set up a basic self-signed
certificate.

.. note:: It is recommended to get a certificate signed by an official signing
          authority. https://www.startssl.com for example provides free basic
          certificates.

If you are running apache under Ubuntu (because you for example have installed
it with the apt-get install commands given above), it is already set-up with a
simple self-signed certificate.


All you have to do is enable the ssl module and the according site. Open
a terminal and run
::

	sudo a2enmod ssl
	sudo a2ensite default-ssl
	sudo service apache2 reload

If you are using a different distribution, check their documentation on how to
enable SSL.

Configuring ownCloud
....................

Since there was a change in the way version 2.2 and 2.4 are configured,
you'll have to find out which apache version you are using.

Usually you can do this by running
::

	sudo apachectl -v
    
or

	apache2 -v
    
Example output:
::

	Server version: Apache/2.2.22 (Ubuntu)
	Server built:   Jul 12 2013 13:37:10

This would indicate an apache of the 2.2 branch (as e.g. you will find on Ubuntu 12.04 LTS).

Example config for Apache 2.2:

.. code-block:: xml

    <Directory /path/to/your/owncloud/install>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>


Example config for Apache 2.4:

.. code-block:: xml

    <Directory /path/to/your/owncloud/install>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>

This config entry needs to go into the configuration file of the "site" you want
to use.

On a Ubuntu system, this typically could be the "default-ssl" site.
Edit the file /etc/apache2/sites-available/default-ssl with your favorite editor
(note that you'll need root permissions to modify that file). For example,
in a Terminal, run:
::

	sudo nano /etc/apache2/sites-available/default-ssl

Add the entry shown above immediately before the line containing
::

	</VirtualHost>

(this should be one of the last lines in the file).


For owncloud to work correctly, we need the module mod_rewrite.
Enable it by running::

	sudo a2enmod rewrite

In distributions that do not come with a2enmod the :file:`/etc/httpd/httpd.conf`
needs to be changed to enable **mod_rewrite**

Then restart apache. For Ubuntu systems (or distributions using upstartd), run::

	sudo service apache2 restart

For systemd systems (Fedora, ArchLinux, OpenSUSE), run::

	systemctl restart httpd.service

In order for the maximum upload size to be configurable, the .htaccess file in the
ownCloud folder needs to be made writable by the server.

You should make sure that any built-in WebDAV module of your web server is disabled
(at least for the ownCloud directory), as it will interfere with ownCloud's
built-in WebDAV support.

If you need the WebDAV support in the rest of your configuration, you can turn it off
specifically for the ownCloud entry by adding the following line in the
configuration of your ownCloud. In above "<Directory ..." code, add the following line
directly after the "allow from all" / "Require all granted" line):
::

	Dav Off

Furthermore, you need to disable any server-configured authentication for owncloud, as
it's internally using Basic authentication for its *DAV services.
If you have turned on authentication on a parent folder (via e.g. an "AuthType Basic"
directive), you can turn off the authentication specifically for the ownCloud entry;
to do so, in above "<Directory ..." code, add the following line directly after the
"allow from all" / "Require all granted" line):
::

	Satisfy Any

A minimal site configuration on Ubuntu 12.04 might look like this:

.. code-block:: xml
	<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerName YourServerName
		ServerAdmin webmaster@localhost
		DocumentRoot /var/www
		<Directory />
			Options FollowSymLinks
			AllowOverride None
		</Directory>
		<Directory /var/www/>
			Options Indexes FollowSymLinks MultiViews
			AllowOverride None
			Order allow,deny
			allow from all
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/error.log
		LogLevel warn
		CustomLog ${APACHE_LOG_DIR}/ssl_access.log combined
		SSLEngine on
		SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
		SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
		<FilesMatch "\.(cgi|shtml|phtml|php)$">
			SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
			SSLOptions +StdEnvVars
		</Directory>
		BrowserMatch "MSIE [2-6]" \
			nokeepalive ssl-unclean-shutdown \
			downgrade-1.0 force-response-1.0
		BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
		<Directory /var/www/owncloud>
			Options Indexes FollowSymLinks MultiViews
			AllowOverride All
			Order allow,deny
			Allow from all
			# add any possibly required additional directives here
			# e.g. the Satisfy directive:
			Satisfy Any
		</Directory>
	</VirtualHost>
	</IfModule>

When using ssl, take special note on the ServerName. You should specify one in the
server configuration, as well as in the CommonName field of the certificate. If you want
your owncloud to be reachable via the internet, then set both these to the domain you
want to reach your owncloud under.

.. note:: By default, the certificates' CommonName will get set to the host name at the time
          when the ssl-cert package was installed.

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

To enable SSL support:
-  Remove the server block containing the redirect
-  Change **listen 443 ssl** to **listen 80;**
-  Remove **ssl_certificate** and **ssl_certificate_key**.
-  Remove **fastcgi_params HTTPS on;**

.. note:: If you want to effectively increase maximum upload size you will also
          have to modify your **php-fpm configuration** (**usually at
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
