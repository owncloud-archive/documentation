==============
Memory Caching
==============

You can significantly improve ownCloud server performance by using memory caching. 
This is the process of storing frequently-requested objects in-memory for faster retrieval later.
There are two types of memory caching available: 

**A PHP opcode Cache (OPcache):** An opcode cache stores compiled PHP scripts so they don't need to be re-compiled every time they are called. These compiled PHP scripts are stored in-memory, on the server on which they’re compiled.

**A Data Cache:** A data cache stores copies of *data*, *templates*, and other types of *information-based files*.
Depending on the cache implementation, it can be either *local*, or specific, to one server, or *distributed* across multiple servers. 
This cache type is ideal when you have a scale-out installation.

Supported Caching Backends
--------------------------

The caching backends supported by ownCloud are:

* :ref:`APCu <apcu-label>`: This is a local cache for systems running PHP 5.6 and up. APCu 4.0.6 and up is required. Alternatively you can use `the Zend OPCache`. However, **it is not a data cache**, only an opcode cache.
* :ref:`Redis <redis-label>`: This is a distributed cache for multi-server ownCloud installations. Version 2.2.6 or higher of the PHP Redis extension is required.
* :ref:`Memcached <memcached-label>`: This is a distributed cache for multi-server ownCloud installations.

.. note:: 
   You may use *both* a local and a distributed cache. 
   The recommended ownCloud caches are APCu and Redis. 

.. note::
   If you do not install and enable a local memory cache you will see a warning on your ownCloud admin page.
   If you enable only a distributed cache in your ``config.php`` (``memcache.distributed``) and not a local cache (``memcache.local``) you will still see the cache warning.
 
Cache Directory Location
~~~~~~~~~~~~~~~~~~~~~~~~

The cache directory defaults to ``data/$user/cache`` where ``$user`` is the current user. 
You may use the ``'cache_path'`` directive in ``config.php`` (See :doc:`config_sample_php_parameters`) to select a different location.
    
Cache Types
-----------
    
.. _apcu-label:
    
APCu
~~~~

PHP 5.6 and up include the Zend OPcache in core, and on most Linux distributions it is enabled by default. 
However, it *does not* bundle a data cache. 
Given that, we recommend that you use APCu instead. APCu is a data cache *and* is available in most Linux distributions. 

Installing APCu
^^^^^^^^^^^^^^^

.. code-block:: console
   
   # On RedHat/CentOS/Fedora systems running PHP 5.6 
   yum install rh-php56-php-devel
   pecl install apcu 

   # On RedHat/CentOS/Fedora systems running PHP 7.0 
   yum install rh-php70-php-devel
   pecl install apcu 

   # On Debian/Ubuntu/Mint systems
   apt-get install php-apcu 

.. note::

   On Ubuntu 14.04 LTS, the APCu version is 4.0.2. 
   This is too old to use with ownCloud, which requires ownCloud 4.0.6+. 
   You can install 4.0.7 from Ubuntu backports with the following command:

   .. code-block:: console

      apt-get install php5-apcu/trusty-backports

After APCu’s installed, enable the extension by creating a configuration file for it, using the following commands.

.. code-block:: console

   cat << EOF > /etc/opt/rh/rh-php70/php.d/20-apcu.ini
   ; APCu php extension
   extension=apcu.so
   EOF
   
With that done, assuming that you don't encounter any errors, restart Apache and the extension is ready to use.

.. _redis-label:

Redis
~~~~~

`Redis <http://redis.io/>`_ is an excellent modern memory cache to use for both distributed caching and as a local cache for :doc:`Transactional File Locking <../../configuration/files/files_locking_transactional>`, because it guarantees that cached objects are available for as long as they are needed.

The Redis PHP module must be at least version 2.2.6 or higher. 
If you are running a Linux distribution that does not package the supported versions of this module — or does not package Redis at all — see :ref:`install_redis_label`.

.. note::
   Debian Jessie users, please see this `GitHub discussion <https://github.com/owncloud/core/issues/20675#issuecomment-159202901>`_ if you have problems with LDAP authentication when using Redis.

Installing Redis on Debian-based Distributions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On Debian/Ubuntu/Mint run the following command:

.. code-block:: console

   apt-get install redis-server php5-redis

The installer will automatically launch Redis and configure it to launch at startup.

.. note:: 
   If you’re running ownCloud on Ubuntu 14.04, which does not package the required version of ``php5-redis``, then work through `this guide on Tech and Me <https://www.techandme.se/how-to-configure-redis-cache-in-ubuntu-14-04-with-owncloud/>`_ to see how to install and configure it.

Installing Redis on RedHat, CentOS, and Fedora
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On RedHat, CentOS, and Fedora run the following commands to install Redis: 

.. code-block:: console

   yum install rh-php70-php-devel rh-redis32-redis
   pecl install redis 

Unlike on Debian-based distributions, Redis will not start automatically on *RedHat*, *Centos*, and *Fedora*. 
Given that, you must use your service manager to both start Redis, and to launch it at boot time as a daemon.
To do so, run the following commands:

.. code-block:: console

   systemctl start rh-redis32-redis
   systemctl enable rh-redis32-redis
 
You can verify that the Redis daemon is running using either of the following two commands:

.. code-block:: console

   ps ax | grep redis
   netstat -tlnp | grep redis

When it’s running, enable the Redis extension by creating a configuration file for it, using the following commands.

.. code-block:: console

   cat << EOF > /etc/opt/rh/rh-php70/php.d/20-redis.ini
   ; Redis php extension
   extension=redis.so
   EOF

After that, assuming that you don't encounter any errors, restart Apache and the extension is ready to use.

Additional notes for Redis vs. APCu on Memory Caching
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

APCu is faster at local caching than Redis. 
If you have enough memory, use APCu for memory caching and Redis for file locking. 
If you are low on memory, use Redis for both.

..  _install_redis_label:     

Installing Redis on other distributions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
These instructions are adaptable for any distribution that does not package the supported version, or that does not package Redis at all, such as SUSE Linux Enterprise Server and RedHat Enterprise Linux.

.. note::
   The `Redis PHP module <https://pecl.php.net/package/redis>`_ must be at least version 2.2.6.

On Debian/Mint/Ubuntu
=====================

Use ``apt-cache`` to see the available ``php5-redis`` version, or the version of your installed package:

.. code-block:: console

   apt-cache policy php5-redis
 
On CentOS and Fedora 
====================

The ``yum`` command shows available and installed version information:

.. code-block:: console

   yum search php-pecl-redis

.. _memcached-label:

Memcached
~~~~~~~~~

Memcached is a reliable old-timer for shared caching on distributed servers. 
It performs well with ownCloud with one exception: it is not suitable to use with :doc:`Transactional File Locking <../../configuration/files/files_locking_transactional>`.
This is because it does not store locks, and data can disappear from the cache at any time.
Given that, Redis is the best memory cache to use. 

.. note:: Be sure to install the **memcached** PHP module, and not *memcache*, as 
   in the following examples. ownCloud supports only the **memcached** PHP 
   module.

Installing Memcached
^^^^^^^^^^^^^^^^^^^^

On Debian/Ubuntu/Mint
=====================

On Debian/Ubuntu/Mint run the following command:

.. code-block:: console

   apt-get install memcached php5-memcached

.. note:: 
   The installer will automatically start ``memcached`` and configure it to launch at startup.

On RedHat/CentOS/Fedora
=======================

On RedHat/CentOS/Fedora run the following command: 

.. code-block:: console

   yum install memcached php-pecl-memcache 

It will not start Memcached automatically after the installation or on subsequent reboots as a daemon, so you must do so yourself .
To do so, run the following command:

.. code-block:: console
   
   systemctl start memcached
   systemctl enable memcached
 
You can verify that the Memcached daemon is running using one of the following commands: 

.. code-block:: console

   ps ax | grep memcached
   netstat -tlnp | grep memcached
   
With the extension installed, you now need to configure it, by creating a configuration file for it. 
You can do so using the command below, substituting ``FILE_PATH`` with one from the list below the command.

.. code-block:: console

   cat << EOF > FILE_PATH
   ; Memcached PHP extension
   extension=memcached.so
   EOF

Configuration File Paths
^^^^^^^^^^^^^^^^^^^^^^^^

=========== ===============================================
PHP Version Filename
=========== ===============================================
5.6         ``/etc/opt/rh/rh-php56/php.d/25-memcached.ini``
7.0         ``/etc/opt/rh/rh-php70/php.d/25-memcached.ini``
=========== ===============================================

After that, assuming that you don't encounter any errors: 

#. Restart your Web server
#. Add the appropriate entries to ``config.php`` (which you can find an example of below)
#. Refresh your ownCloud admin page 
   
Configuring Memory Caching
--------------------------
   
Memory caches must be explicitly configured in ownCloud by:

#. Installing and enabling your desired cache (whether that be the PHP extension and/or the caching server).
#. Adding the appropriate entry to ownCloud’s ``config.php``.

See :doc:`config_sample_php_parameters` for an overview of all possible config parameters.
After installing and enabling your chosen memory cache, verify that it is active by running :ref:`label-phpinfo`.

APCu Configuration
~~~~~~~~~~~~~~~~~~

To use APCu, add this line to ``config.php``:

.. code-block:: php

   'memcache.local' => '\OC\Memcache\APCu',
 
With that done, refresh your ownCloud admin page, and the cache warning should disappear.  

Redis Configuration
~~~~~~~~~~~~~~~~~~~

This example ``config.php`` configuration uses Redis for the local server cache:

.. code-block:: php

   'memcache.local' => '\OC\Memcache\Redis',
   'redis' => [
       'host' => 'localhost',
       'port' => 6379,
   ],
  'memcache.locking' => '\OC\Memcache\Redis', // Add this for best performance

If you want to connect to Redis configured to listen on an Unix socket, which is recommended if Redis is running on the same system as ownCloud, use this example configuration:

.. code-block:: php

  'memcache.local' => '\OC\Memcache\Redis',
  'redis' => [
       'host' => '/var/run/redis/redis.sock',
       'port' => 0,
  ],

Redis is very configurable; consult `the Redis documentation <http://redis.io/documentation>`_ to learn more.

.. _transactional-file-locking-label:

Memcached Configuration
~~~~~~~~~~~~~~~~~~~~~~~

This example uses APCu for the local cache, Memcached as the distributed memory cache, and lists all the servers in the shared cache pool with their port numbers:

.. code-block:: php

   'memcache.local' => '\OC\Memcache\APCu',
   'memcache.distributed' => '\OC\Memcache\Memcached',
   'memcached_servers' => [
        ['localhost', 11211],
        ['server1.example.com', 11211],
        ['server2.example.com', 11211], 
    ], 

Configuration Recommendations Based on Type of Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Small/Private Home Server
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php

    // Only use APCu
    'memcache.local' => '\OC\Memcache\APCu', 

Small Organization, Single-server Setup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use APCu for local caching, Redis for file locking

.. code-block:: php

   'memcache.local' => '\OC\Memcache\APCu',
   'memcache.locking' => '\OC\Memcache\Redis',
   'redis' => [
       'host' => 'localhost',
       'port' => 6379,
   ],

Large Organization, Clustered Setup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use Redis for everything except a local memory cache. 
Use the server's IP address or hostname so that it is accessible to other hosts:

.. code-block:: php

  'memcache.distributed' => '\OC\Memcache\Redis',
  'memcache.locking' => '\OC\Memcache\Redis',
  'memcache.local' => '\OC\Memcache\APCu',
  'redis' => [
      'host' => 'server1',      // hostname example
      'host' => '12.34.56.78',  // IP address example
      'port' => 6379,
  ],

Configuring Transactional File Locking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`Transactional File Locking <../../configuration/files/files_locking_transactional>` prevents simultaneous file saving.
To use it, you have to enable it in ``config.php`` as in the following example, which uses Redis as the cache backend:

.. code-block:: php

  'filelocking.enabled' => true,
  'memcache.locking' => '\OC\Memcache\Redis',
  'redis' => [
       'host' => 'localhost',
       'port' => 6379,
       'timeout' => 0.0,
       'password' => '', // Optional, if not defined no password will be used.
   ],

.. note:: 
   For enhanced security it is recommended to configure Redis to require a password. 
   See http://redis.io/topics/security for more information.

Caching Exceptions
------------------

If ownCloud is configured to use either Memcached or Redis as a memory cache, please be aware that you may encounter issues with functionality. 
When these occur, it is usually a result of PHP being incorrectly configured, or the relevant PHP extension not being available.

In the table below, you can see all of the known reasons for reduced or broken functionality related to caching.

+---------------------------------------------+------------------------------------------------------------------+
| Setup/Configuration                         | Result                                                           |
+=============================================+==================================================================+
| If file locking is enabled, but the locking | The application will not be usable                               |
| cache class is missing, then an exception   |                                                                  |
| will appear in the web UI                   |                                                                  |
+---------------------------------------------+------------------------------------------------------------------+
| If file locking is enabled and the locking  | There will be a white page/exception in web UI. It               |
| cache is configured, but the PHP module     | will be a full page issue, and the application will not be       |
| missing.                                    | usable                                                           |
+---------------------------------------------+------------------------------------------------------------------+
| All enabled, but the Redis server is not    | The application will be usable. But any file operation will      |
| running                                     | return a **"500 Redis went away"** exception                     |
+---------------------------------------------+------------------------------------------------------------------+
| If Memcache is configured for "local" and   | There will be a white page and an exception written to the logs, |
| "distributed", but the class is missing     | This is because autoloading needs the missing class. So there is |
|                                             | no way to show a page                                            |
+---------------------------------------------+------------------------------------------------------------------+
