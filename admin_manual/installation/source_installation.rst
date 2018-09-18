============================
Manual Installation on Linux
============================

Installing ownCloud on Linux from our Open Build Service packages is the preferred method (see :doc:`linux_installation`). 
These are maintained by ownCloud engineers, and you can use your package manager to keep your ownCloud server up-to-date.

.. note:: Enterprise customers should refer to  
   :doc:`../enterprise/installation/install`

If there are no packages for your Linux distribution, or you prefer installing from the source tarball, you can setup ownCloud from scratch using a classic LAMP stack (Linux, Apache, MySQL/MariaDB, PHP). 
This document provides a complete walk-through for installing ownCloud on Ubuntu 14.04 LTS Server with Apache and MariaDB, using `the ownCloud .tar archive <https://owncloud.org/install/>`_.

- :ref:`prerequisites_label`
- :ref:`ubuntu_installation_label`
- :ref:`apache_configuration_label`
- :ref:`enabling_ssl_label`
- :ref:`installation_wizard_label`
- :ref:`strong_perms_label`
- :ref:`selinux_tips_label`
- :ref:`php_ini_tips_label`
- :ref:`php_fpm_tips_label`
- :ref:`other_http_servers_label`

.. note:: 
   Admins of SELinux-enabled distributions such as CentOS, Fedora, and Red Hat Enterprise Linux may need to set new rules to enable installing ownCloud. See :ref:`selinux_tips_label` for a suggested configuration.

.. _prerequisites_label:

Prerequisites
-------------

The ownCloud tar archive contains all of the required third-party PHP libraries. 
As a result, no extra ones are, strictly, necessary. 
However, ownCloud does require that PHP has a set of extensions installed, enabled, and configured. 

This section lists both the required and optional PHP extensions. 
If you need further information about a particular extension, please consult the relevant section of `the extensions section of the PHP manual <http://php.net/manual/en/extensions.php>`_. 

If you are using a Linux distribution, it should have packages for all the required extensions. 
You can check the presence of a module by typing ``php -m | grep -i <module_name>``. 
If you get a result, the module is present.

Required
^^^^^^^^

PHP Version
~~~~~~~~~~~

PHP (5.6+, 7.0, 7.1, & 7.2)

.. WARNING::

   ownCloud recommends the use of PHP 7.2 in new installations.
   Sites using a version earlier than PHP 7.2 are *strongly encouraged* to migrate to PHP 7.2.

PHP Extensions
~~~~~~~~~~~~~~

+----------------------+-------------------------------------------------------------+
| Name                 | Description                                                 |
+======================+=============================================================+
| `Ctype`_             | For character type checking                                 |
+----------------------+-------------------------------------------------------------+
| `cURL`_              | Used for aspects of HTTP user authentication                |
+----------------------+-------------------------------------------------------------+
| `DOM`_               | For operating on XML documents through the DOM API          |
+----------------------+-------------------------------------------------------------+
| `GD`_                | For creating and manipulating image files in a variety of   |
|                      | different image formats, including GIF, PNG, JPEG, WBMP,    |
|                      | and XPM.                                                    |
+----------------------+-------------------------------------------------------------+
| `HASH Message`_      | For working with message digests (hash).                    |
| `Digest Framework`_  |                                                             |
+----------------------+-------------------------------------------------------------+
| `iconv`_             | For working with the iconv character set conversion         |
|                      | facility.                                                   |
+----------------------+-------------------------------------------------------------+
| `intl`_              | Increases language translation performance and fixes        |
|                      | sorting of non-ASCII characters                             |
+----------------------+-------------------------------------------------------------+
| `JSON`_              | For working with the JSON data-interchange format.          |
+----------------------+-------------------------------------------------------------+
| `libxml`_            | This is required for the _DOM_, _libxml_, _SimpleXML_, and  |
|                      | _XMLWriter_ extensions to work. It requires that libxml2,   |
|                      | version 2.7.0 or higher, is installed.                      |
+----------------------+-------------------------------------------------------------+
| `Multibyte String`_  | For working with multibyte character encoding schemes.      |
+----------------------+-------------------------------------------------------------+
| `OpenSSL`_           | For symmetric and asymmetric encryption and decryption,     |
|                      | PBKDF2, PKCS7, PKCS12, X509 and other crypto operations.    |
+----------------------+-------------------------------------------------------------+
| `PDO`_               | This is required for the pdo_msql function to work.         |
+----------------------+-------------------------------------------------------------+
| `Phar`_              | For working with PHP Archives (.phar files).                |
+----------------------+-------------------------------------------------------------+
| `POSIX`_             | For working with UNIX POSIX functionality.                  |
+----------------------+-------------------------------------------------------------+
| `SimpleXML`_         | For working with XML files as objects.                      |
+----------------------+-------------------------------------------------------------+
| `XMLWriter`_         | For generating streams or files of XML data.                |
+----------------------+-------------------------------------------------------------+
| `Zip`_               | For reading and writing ZIP compressed archives and the     |
|                      | files inside them.                                          |
+----------------------+-------------------------------------------------------------+
| `Zlib`_              | For reading and writing gzip (.gz) compressed files.        |
+----------------------+-------------------------------------------------------------+

.. tip::
   The *Phar*, *OpenSSL*, and *cUrl* extensions are mandatory if you want to use `Make`_
   `to setup your ownCloud environment`_, prior to running either the web
   installation wizard, or the command line installer.

Database Extensions
~~~~~~~~~~~~~~~~~~~

============ ====================================================================
Name         Description
============ ====================================================================
`pdo_mysql`_ For working with MySQL & MariaDB.
`pgsql`_     For working with PostgreSQL. It requires PostgreSQL 9.0 or above.
`sqlite`_    For working with SQLite. It requires SQLite 3 or above. This is, 
             usually, not recommended, for performance reasons.
============ ====================================================================

Required For Specific Apps
^^^^^^^^^^^^^^^^^^^^^^^^^^

============ ====================================================================
Name         Description
============ ====================================================================
`ftp`_       For working with FTP storage
`sftp`_      For working with SFTP storage
`imap`_      For IMAP integration
`ldap`_      For LDAP integration
`smbclient`_ For SMB/CIFS integration
============ ====================================================================
  
.. note:: SMB/Windows Network Drive mounts require the PHP module smbclient version 0.8.0+; see
  :doc:`../configuration/files/external_storage/smb`.

Optional
^^^^^^^^

=========== =====================================================================
Extension   Reason
=========== =====================================================================
`Bzip2`_    Required for extraction of applications
`Fileinfo`_ Highly recommended, as it enhances file analysis performance
`Mcrypt`_   Increases file encryption performance
`OpenSSL`_  Required for accessing HTTPS resources
`imagick`_  Required for creating and modifying images and preview thumbnails
=========== =====================================================================

Recommended
^^^^^^^^^^^

For Specific Apps
~~~~~~~~~~~~~~~~~

========= =====================================================================
Extension Reason
========= =====================================================================
`Exif`_   For image rotation in the pictures app
`GMP`_    For working with arbitrary-length integers
========= =====================================================================

For Server Performance
~~~~~~~~~~~~~~~~~~~~~~

For enhanced server performance consider installing one of the following cache extensions:

- `apcu`_
- `memcached`_
- `redis`_ (>= 2.2.6+, required for transactional file locking)

See :doc:`../configuration/server/caching_configuration` to learn how to select 
and configure a memcache.

For Preview Generation
~~~~~~~~~~~~~~~~~~~~~~

- `avconv`_ or `ffmpeg`_
- `OpenOffice`_ or `LibreOffice`_

For Command Line Processing
~~~~~~~~~~~~~~~~~~~~~~~~~~~

========= =====================================================================
Extension Reason
========= =====================================================================
`PCNTL`_  Enables command interruption by pressing ``ctrl-c``
========= =====================================================================

.. NOTE::

  You don’t need the WebDAV module for your Web server (i.e. Apache’s ``mod_webdav``), as ownCloud has a built-in WebDAV server of its own, `SabreDAV`_. 
  If ``mod_webdav`` is enabled you must disable it for ownCloud. (See :ref:`apache_configuration_label` for an example configuration.)

For MySQL/MariaDB
^^^^^^^^^^^^^^^^^

The InnoDB storage engine is required, and MyISAM is not supported, see: :ref:`db-storage-engine-label`.
  
.. _ubuntu_installation_label:  

Install the Required Packages
-----------------------------

.. note::
   **When Are Stable Channel Packages Updated?**
   
   Packages in the supported distributions’ stable channels are not immediately updated following a release. 
   This is because we need to make sure that the release is sufficiently stable, as many people use automatic updates. 
   By waiting a number of business days after a tarball has been released, we are able to make this assessment, based on a number of criteria which include the submitted bug reports from systems administrators.

On Ubuntu 16.04 LTS Server
^^^^^^^^^^^^^^^^^^^^^^^^^^

On a machine running a pristine Ubuntu 16.04 LTS server, install the required and recommended modules for a typical ownCloud installation, using Apache and MariaDB, by issuing the following commands in a terminal:

::

    # If the add-apt-repository command is not available install software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get update

    sudo apt-get install -y apache2 mariadb-server libapache2-mod-php7.2 \
        openssl php-imagick php7.2-common php7.2-curl php7.2-gd \
        php7.2-imap php7.2-intl php7.2-json php7.2-ldap php7.2-mbstring \
        php7.2-mysql php7.2-pgsql php-smbclient php-ssh2 \
        php7.2-sqlite3 php7.2-xml php7.2-zip

**Please note:**

- ``php7.2-common`` provides: ftp, Phar, posix, iconv, ctype
- The Hash extension is available from PHP 5.1.2 by default
- ``php7.2-xml`` provides DOM, SimpleXML, XML, & XMLWriter
- ``php7.2-zip`` provides zlib

Installing smbclient
~~~~~~~~~~~~~~~~~~~~

To install smbclient, you can use the following script.
It first installs PEAR, which at the time of writing only installs version 1.9.4.
However, smbclient requires version 1.9.5.
So the final two commands upgrade PEAR to version 1.9.5 and then install smbclient using Pecl.

::

  #!/usr/bin/expect
  spawn wget -O /tmp/go-pear.phar http://pear.php.net/go-pear.phar
  expect eof

  spawn php /tmp/go-pear.phar

  expect "1-11, 'all' or Enter to continue:"
  send "\r"
  expect eof

  spawn rm /tmp/go-pear.phar

  pear install PEAR-1.9.5
  pecl install smbclient

Installing SSH2
~~~~~~~~~~~~~~~

To install SSH2, which provides SFTP, you can use the following command:

::

  spawn pecl install ssh2

Running Additional Apps?
~~~~~~~~~~~~~~~~~~~~~~~~

If you are planning on running additional apps, keep in mind that you might require additional packages.
See :ref:`prerequisites_label` for details.

.. note::
   During the installation of the MySQL/MariaDB server, you will be prompted to create a root password.
   Be sure to remember your password as you will need it during ownCloud database setup.

Additional Extensions
~~~~~~~~~~~~~~~~~~~~~

::

  apt-get install -y php-apcu php-redis redis-server php7.2-ldap

RHEL (RedHat Enterprise Linux) 7.2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Required Extensions
~~~~~~~~~~~~~~~~~~~

::

  # Enable the RHEL Server 7 repository
  subscription-manager repos --enable rhel-server-rhscl-7-eus-rpms
  
  # Install the required packages
  sudo yum install httpd mariadb-server php72 php72-php \
    php72-php-gd php72-php-mbstring php72-php-mysqlnd

Optional Extensions
~~~~~~~~~~~~~~~~~~~

::

  sudo yum install -y epel-release http://rpms.remirepo.net/enterprise/remi-release-7.rpm yum-utils \
    && sudo yum-config-manager --enable remi-php72 \
    && sudo yum update -y \
    && sudo yum install -y php72-pecl-apcu \
      redis php72-php-pecl-redis php72-php-ldap \
      mariadb-server mariadb

Centos 7
^^^^^^^^

::

  sudo yum install -y -q epel-release http://rpms.remirepo.net/enterprise/remi-release-7.rpm yum-utils \
  && sudo yum-config-manager --enable remi-php72 \
  && sudo yum update -y -q \
  && sudo yum install -y -q \
     httpd mariadb-server php72 php72-php php72-php-gd \
     php72-php-mbstring php72-php-mysqlnd php72-php-cli \
     php72-pecl-apcu redis php72-php-pecl-redis php72-php-common \
     php72-php-ldap mariadb-server mariadb \
  && sudo scl enable php72 bash

SLES (SUSE Linux Enterprise Server) 12
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Required Extensions
~~~~~~~~~~~~~~~~~~~

::

  zypper install -y apache2 apache2-mod_php7 php7-gd php7-openssl \
    php7-json php7-curl php7-intl php7-sodium php7-zip php7-zlib

Optional Extensions
~~~~~~~~~~~~~~~~~~~

::

  zypper install -y php7-ldap

APCu
||||

We are not aware of any officially supported APCu package for SLES 12.
However, if you want or need to install it, then we suggest the following steps:

::

  wget http://download.opensuse.org/repositories/server:/php:/extensions/SLE_12_SP1/ server:php:extensions.repo -O /etc/zypp/repos.d/memcached.repo 
  zypper refresh
  zypper install -y php7-APCu

Redis
|||||

The latest versions of Redis servers have shown to be incompatible with SLES 12. 
Therefore it is currently recommended to download and install version 2.2.7 or a previous release from: https://pecl.php.net/package/redis.
Keep in mind that version 2.2.5 is the minimum version which ownCloud supports.

If you want or need to install it, we suggest the following steps:

::

  zypper refresh
  zypper install -y php7-redis

Install ownCloud
----------------

Now download the archive of the latest ownCloud version:

- Go to the `ownCloud Download Page <https://owncloud.org/install>`_.
- Go to **Download ownCloud Server > Download > Archive file for 
  server owners** and download either the tar.bz2 or .zip archive.
- This downloads a file named owncloud-x.y.z.tar.bz2 or owncloud-x.y.z.zip 
  (where x.y.z is the version number).
- Download its corresponding checksum file, e.g. owncloud-x.y.z.tar.bz2.md5, 
  or owncloud-x.y.z.tar.bz2.sha256. 
- Verify the MD5 or SHA256 sum::
   
    md5sum -c owncloud-x.y.z.tar.bz2.md5 < owncloud-x.y.z.tar.bz2
    sha256sum -c owncloud-x.y.z.tar.bz2.sha256 < owncloud-x.y.z.tar.bz2
    md5sum  -c owncloud-x.y.z.zip.md5 < owncloud-x.y.z.zip
    sha256sum  -c owncloud-x.y.z.zip.sha256 < owncloud-x.y.z.zip
    
- You may also verify the PGP signature::
    
    wget https://download.owncloud.org/community/owncloud-x.y.z.tar.bz2.asc
    wget https://owncloud.org/owncloud.asc
    gpg --import owncloud.asc
    gpg --verify owncloud-x.y.z.tar.bz2.asc owncloud-x.y.z.tar.bz2
  
- Now you can extract the archive contents. Run the appropriate unpacking 
  command for your archive type::

    tar -xjf owncloud-x.y.z.tar.bz2
    unzip owncloud-x.y.z.zip

- This unpacks to a single ``owncloud`` directory. Copy the ownCloud directory to its final destination. When you are running the Apache HTTP server, you may safely install ownCloud in your Apache document root::

    cp -r owncloud /path/to/webserver/document-root

  where ``/path/to/webserver/document-root`` is replaced by the 
  document root of your Web server::
    
    cp -r owncloud /var/www

On other HTTP servers, it is recommended to install ownCloud outside of the document root.

.. _apache_configuration_label:
   
Configure Apache Web Server
---------------------------

On Debian, Ubuntu, and their derivatives, Apache installs with a useful configuration, so all you have to do is create a :file:`/etc/apache2/sites-available/owncloud.conf` file with these lines in it, replacing the **Directory** and other file paths with your own file paths::
   
  Alias /owncloud "/var/www/owncloud/"
   
  <Directory /var/www/owncloud/>
    Options +FollowSymlinks
    AllowOverride All

   <IfModule mod_dav.c>
    Dav off
   </IfModule>

   SetEnv HOME /var/www/owncloud
   SetEnv HTTP_HOME /var/www/owncloud

  </Directory>
  
Then create a symlink to :file:`/etc/apache2/sites-enabled`::

  ln -s /etc/apache2/sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf
  
Additional Apache Configurations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- For ownCloud to work correctly, we need the module ``mod_rewrite``. Enable it 
  by running::

    a2enmod rewrite
  
  Additional recommended modules are ``mod_headers``, ``mod_env``, ``mod_dir`` and ``mod_mime``
  
  ::
  
    a2enmod headers
    a2enmod env
    a2enmod dir
    a2enmod mime
  
  .. note::
     If you want to use `the OAuth2 app`_, then `mod_headers`_ must be installed and
     enabled.
  
- You must disable any server-configured authentication for ownCloud, as it uses Basic authentication internally for DAV services. If you have turned on authentication on a parent folder (via, e.g., an ``AuthType Basic`` directive), you can disable the authentication specifically for the ownCloud entry. Following the above example configuration file, add the following line in the ``<Directory`` section

  ::

    Satisfy Any

- When using SSL, take special note of the ``ServerName``. You should specify one in the  server configuration, as well as in the ``CommonName`` field of the certificate. If you want your ownCloud to be reachable via the internet, then set both of these to the domain you want to reach your ownCloud server.

- Now restart Apache

  ::

     service apache2 restart

- If you're running ownCloud in a sub-directory and want to use CalDAV or CardDAV clients make sure you have configured the correct :ref:`service-discovery-label` URLs.

.. _apache-mpm-label:

Multi-Processing Module (MPM)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`Apache prefork`_ has to be used. Don’t use a threaded ``MPM`` like ``event`` or ``worker`` with ``mod_php``,
because PHP is currently `not thread safe`_.

.. _enabling_ssl_label:

Enable SSL
----------

.. note:: You can use ownCloud over plain HTTP, but we strongly encourage you to use SSL/TLS to encrypt all of your server traffic, and to protect user's logins and data in transit.

Apache installed under Ubuntu comes already set-up with a simple self-signed certificate. 
All you have to do is to enable the ``ssl`` module and the default site. 
Open a terminal and run::

     a2enmod ssl
     a2ensite default-ssl
     service apache2 reload

.. note:: 
   Self-signed certificates have their drawbacks - especially when you plan to make your ownCloud server publicly accessible. You might want to consider getting a certificate signed by a commercial signing authority. Check with your domain name registrar or hosting service for good deals on commercial certificates.   
    
.. _installation_wizard_label:
    
Run the Installation Wizard
---------------------------

After restarting Apache, you must complete your installation by running either the Graphical Installation Wizard or on the command line with the ``occ`` command. 
To enable this, temporarily change the ownership on your ownCloud directories to your HTTP user (see :ref:`strong_perms_label` to learn how to find your HTTP user)::

 chown -R www-data:www-data /var/www/owncloud/
 
.. note:: Admins of SELinux-enabled distributions may need to write new SELinux rules to complete their ownCloud installation; see 
   :ref:`selinux_tips_label`. 

To use ``occ`` see :doc:`command_line_installation`. 
To use the graphical Installation Wizard see :doc:`installation_wizard`.

.. warning::
   Please know that ownCloud's data directory **must be exclusive to ownCloud** and not be modified manually by any other process or user.

.. _strong_perms_label:

Set Strong Directory Permissions
--------------------------------

After completing the installation, you must immediately :ref:`set the directory permissions <post_installation_steps_label>` in your ownCloud installation as strictly as possible for stronger security. 
After you do so, your ownCloud server will be ready to use.

.. _managing_trusted_domains_label:

Managing Trusted Domains
------------------------

All URLs used to access your ownCloud server must be whitelisted in your ``config.php`` file, under the ``trusted_domains`` setting. 
Users are allowed to log into ownCloud only when they point their browsers to a URL that is listed in the ``trusted_domains`` setting. 

.. note:: 
   This setting is important when changing or moving to a new domain name.
   You may use IP addresses and domain names.
 
A typical configuration looks like this:

.. code-block:: php

  'trusted_domains' => [
     0 => 'localhost', 
     1 => 'server1.example.com', 
     2 => '192.168.1.50',
  ],

The loopback address, ``127.0.0.1``, is automatically whitelisted, so as long as you have access to the physical server you can always log in. 
In the event that a load-balancer is in place, there will be no issues as long as it sends the correct ``X-Forwarded-Host`` header. 

.. note::
 For further information on improving the quality of your ownCloud installation, please see the :doc:`configuration_notes_and_tips` guide.

.. Links

.. _SabreDav: http://sabre.io/
.. _to setup your ownCloud environment: https://doc.owncloud.com/server/latest/developer_manual/general/devenv.html
.. _Apache prefork: https://httpd.apache.org/docs/2.4/mod/prefork.html
.. _not thread safe: https://secure.php.net/manual/en/install.unix.apache2.php

.. Apache Modules
.. _mod_headers: http://httpd.apache.org/docs/current/mod/mod_headers.html

.. PHP Extension Links

.. _Bzip2: https://php.net/manual/en/book.bzip2.php
.. _Ctype: https://secure.php.net/manual/en/book.ctype.php
.. _DOM: https://secure.php.net/manual/en/book.dom.php
.. _Exif: https://php.net/manual/en/book.exif.php
.. _Fileinfo: https://php.net/manual/en/book.fileinfo.php
.. _GD: https://php.net/manual/en/book.image.php
.. _GMP: https://php.net/manual/en/book.gmp.php
.. _HASH: https://secure.php.net/manual/en/book.hash.php
.. _HASH Message: http://php.net/manual/en/function.hash.php
.. _Digest Framework: http://php.net/manual/en/function.hash.php
.. _Iconv: https://php.net/manual/en/book.iconv.php
.. _JSON: https://php.net/manual/en/book.json.php
.. _Mcrypt: https://php.net/manual/en/book.mcrypt.php
.. _Multibyte String: https://php.net/manual/en/book.mbstring.php
.. _OpenSSL: https://php.net/manual/en/book.openssl.php
.. _PCNTL: https://secure.php.net/manual/en/book.pcntl.php
.. _PDO: https://secure.php.net/manual/en/book.pdo.php
.. _Phar: https://secure.php.net/manual/en/book.phar.php
.. _POSIX: https://php.net/manual/en/book.posix.php
.. _SimpleXML: https://php.net/manual/en/book.simplexml.php
.. _XMLWriter: https://php.net/manual/en/book.xmlwriter.php
.. _Zip: https://php.net/manual/en/book.zip.php 
.. _Zlib: https://php.net/manual/en/book.zlib.php
.. _cURL: https://php.net/manual/en/book.curl.php
.. _ftp: https://secure.php.net/manual/en/book.ftp.php
.. _imap: https://secure.php.net/manual/en/book.imap.php
.. _intl: https://php.net/manual/en/book.intl.php
.. _ldap: https://secure.php.net/manual/en/book.ldap.php
.. _libxml: https://php.net/manual/en/book.libxml.php
.. _pdo_mysql: https://secure.php.net/manual/en/ref.pdo-mysql.php
.. _pgsql: https://secure.php.net/manual/en/ref.pgsql.php
.. _sftp: https://secure.php.net/manual/de/book.ssh2.php
.. _smbclient: https://pecl.php.net/package/smbclient
.. _sqlite: https://secure.php.net/manual/en/ref.sqlite.php
.. _apcu: https://secure.php.net/manual/en/book.apcu.php
.. _memcached: https://secure.php.net/manual/en/book.memcached.php
.. _redis: https://pecl.php.net/package/redis
.. _imagick: https://secure.php.net/manual/en/book.imagick.php
   
.. Executable Links
   
.. _avconv: https://libav.org/
.. _ffmpeg: https://ffmpeg.org/
.. _OpenOffice: https://www.openoffice.org/
.. _LibreOffice: https://www.libreoffice.org/
.. _Make: https://www.gnu.org/software/make/

.. Forum Links
   
.. _in the forums: https://central.owncloud.org/t/no-basic-authentication-headers-were-found-message/819
.. _the OAuth2 app: https://marketplace.owncloud.com/apps/oauth2
