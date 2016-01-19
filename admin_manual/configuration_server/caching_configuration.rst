==========================
Configuring Memory Caching
==========================

You can significantly improve your ownCloud server performance with memory 
caching, where frequently-requested objects are stored in memory for faster 
retrieval. There are two types of caches to use: a PHP opcode cache, which is 
commonly called *opcache*, and data caching for your Web server. If you do not 
install and enable a local memcache you will see a warning on your ownCloud 
admin page. A memcache is not required and you may ignore the warning if you 
prefer.

.. note:: If you enable only a distributed cache in 
   your ``config.php`` (``memcache.distributed``) and not a 
   local cache (``memcache.local``) you will still see the cache warning.

A PHP opcache stores compiled PHP scripts so they don't need to be re-compiled 
every time they are called. PHP bundles the Zend OPcache in core since version 
5.5, so you don't need to install an opcache.

If you are using PHP 5.4, which is the oldest supported PHP version for 
ownCloud, you may install the Alternative PHP Cache (APC). This is both an 
opcache and data cache. APC has not been updated since 2012 and is essentially 
dead, and PHP 5.4 is old and lags behind later releases. If it is possible 
to upgrade to a later PHP release that is the best option.

Data caching is supplied by the Alternative PHP Cache, user (APCu) in PHP 
5.5+, Memcached, or Redis.

ownCloud supports multiple memory caching backends, so you can choose the type 
of memcache that best fits your needs. The supported caching backends are:

* `APC <http://php.net/manual/en/book.apc.php>`_ 
   A local cache for systems running PHP 5.4.
* `APCu <https://pecl.php.net/package/APCu>`_, APCu 4.06 and up required.
   A local cache for systems running PHP 5.5 and up.
* `Memcached <http://www.memcached.org/>`_ 
   Distributed cache for multi-server ownCloud installations.
* `Redis <http://redis.io/>`_, PHP module 2.2.5 and up required.
   For distributed caching.

These are supported but not recommended:

* `XCache <http://xcache.lighttpd.net/>`_ 
* `ArrayCache <http://www.arbylon.net/projects/knowceans-tools/doc/org/knowceans/util/ArrayCache.html>`_
   
Memcaches must be explicitly configured in ownCloud 8.1 and up by installing 
and enabling your desired cache, and then adding the appropriate entry to 
``config.php`` (See :doc:`config_sample_php_parameters` for an overview of
all possible config parameters).

You may use both a local and a distributed cache. Recommended caches are APCu 
and Redis. After installing and enabling your chosen memcache, verify that it is 
active by running :ref:`label-phpinfo`.
   
APC
---

APC is only for systems running PHP 5.4 and older. The oldest supported PHP 
version in ownCloud is 5.4.

.. note:: RHEL 6 and CentOS 6 ship with PHP 5.3 and must be upgraded to PHP 
   5.4 to run ownCloud. See :doc:`../installation/php_54_installation`.

On Red Hat/CentOS/Fedora systems running PHP 5.4, install ``php-pecl-apc``. On 
Debian/Ubuntu/Mint systems install ``php-apc``. Then restart your Web server. 
 
After restarting your Web server, add this line to your ``config.php`` file::

 'memcache.local' => '\OC\Memcache\APC',
 
Refresh your ownCloud admin page, and the cache warning should disappear.

APCu
----

PHP 5.5 and up includes the Zend OPcache in core, and on most Linux 
distributions it is enabled by default. However, it does 
not bundle a data cache. APCu is a data cache, and it is available in most 
Linux distributions. On Red Hat/CentOS/Fedora systems running PHP 5.5 and up 
install ``php-pecl-apcu``. On Debian/Ubuntu/Mint systems install ``php5-apcu``. 
Then restart your Web server.
 
The version of APCu must be 4.0.6 and up.

After restarting your Web server, add this line to your ``config.php`` file::

 'memcache.local' => '\OC\Memcache\APCu',
 
Refresh your ownCloud admin page, and the cache warning should disappear.

.. finish this later. too vexing to bother with now.
.. Enabling PHP opcache
.. ^^^^^^^^^^^^^^^^^^^^
..
.. Use :ref:`label-phpinfo` to see if your PHP opcache is already enabled by 
.. searching for ``opcache.enable``. If it says ``on`` then it is enabled and 
.. you don't need to do anything. Figure 1 is from Linux Mint 17; the Zend 
.. OPcache is enabled by default and ``phpinfo`` displays status and statistics.
..
.. .. figure:: images/cache-1.png
..   :alt: The Zend OPcache section displays opcode cache status and statistics.
..  
..   *Figure 1: Zend OPcache status in phpinfo*
..   
.. If it is not enabled, then go into    

Memcached
---------

Memcached is a reliable oldtimer for shared caching on distributed servers, 
and performs well with ownCloud with one exception: it is not suitable to use 
with :doc:`Transactional File Locking <../configuration_files/files_locking_transactional>`
because it does not store locks, and data can disappear from the cache at any time
(Redis is the best for this). 

.. note:: Be sure to install the **memcached** PHP module, and not memcache, as 
   in the following examples. ownCloud supports only the **memcached** PHP 
   module.

Setting up Memcached is easy. On Debian/Ubuntu/Mint install ``memcached`` and 
``php5-memcached``. The installer will automatically start ``memcached`` and 
configure it to launch at startup.

On Red Hat/CentOS/Fedora install ``memcached`` and 
``php-pecl-memcached``. It will not start automatically, so you must use 
your service manager to start ``memcached``, and to launch it at boot as a 
daemon.
 
You can verify that the Memcached daemon is running with ``ps ax``::

 ps ax | grep memcached
 19563 ? Sl 0:02 /usr/bin/memcached -m 64 -p 11211 -u memcache -l 
 127.0.0.1

Restart your Web server, add the appropriate entries to your 
``config.php``, and refresh your ownCloud admin page. This example uses APCu 
for the local cache, Memcached as the distributed memcache, and lists all the 
servers in the shared cache pool with their port numbers::

 'memcache.local' => '\OC\Memcache\APCu',
 'memcache.distributed' => '\OC\Memcache\Memcached',
 'memcached_servers' => array(
      array('localhost', 11211),
      array('server1.example.com', 11211),
      array('server2.example.com', 11211), 
      ), 

Redis
-----

Redis is an excellent modern memcache to use for both distributed caching, and 
as a local cache for :doc:`Transactional File Locking 
<../configuration_files/files_locking_transactional>` because it guarantees 
that cached objects are available for as long as they are needed.

.. note::
  | The Redis PHP module must be version 2.2.5 and up.
  | Please note that the Redis versions 2.2.5 - 2.2.7 will only work for:
  
  .. code-block:: bash
   
   PHP version 6.0.0 or older
   PHP version 5.2.0 or newer
  
  See also: https://pecl.php.net/package/redis

Server Preparation
^^^^^^^^^^^^^^^^^^

- On Debian/Ubuntu/Mint, install Redis with:
  
  | ``apt-get install redis-server``
  | ``apt-get install php5-redis``.

  The installer will automatically launch ``redis-server`` and configure it to launch at startup.

.. note::
  | On Ubuntu 14.04 (Trusty), the ``php5-redis`` version is too old and not supported.
  | You can check what version you have installed with:
  
  .. code-block:: bash
  
   apt-show-versions php5-redis
   php5-redis:amd64/trusty 2.2.4-1build2 uptodate
  
  | This example shows an outdated version. 
  | If you have this version, you must uninstall this version with: 
  
  .. code-block:: bash
  
   apt-get remove php5-redis

  and install a newer version of Redis. 
    
  One solution option is to look for a PPA. See `Ubuntu launchpad <https://launchpad.net/ubuntu/+source/php-redis>`_.
  
  Another solution option is using the PECL/PEAR PHP extension repository:
    
  .. code-block:: bash
  
   apt-get install php-pear php5-dev make
   pecl install redis
  
  
  Check if the extension is enabled, if not do:
  
  .. code-block:: bash
  
   echo extension=redis.so > /etc/php5/mods-available/redis.ini

  If you use Apache enable it with:
  
  .. code-block:: bash
  
    php5enmod redis


- On Red Hat/CentOS/Fedora, install ``redis`` and ``php-pecl-redis``. It will not 
  start automatically, so you must use your service manager to start 
  ``redis``, and to launch it at boot as a daemon.

| 

You can verify that the Redis daemon is running with ``ps ax``::
 
 ps ax | grep redis
 22203 ? Ssl    0:00 /usr/bin/redis-server 127.0.0.1:6379 
 
| You may also check the presence of the PHP Redis configuration links in the corresponding subdirectories of php ``cli`` and ``fpm``. If you use nginx, you most likely also use fpm.
| 
| Examples based on Ubuntu:
| 
| For ``fpm``, the link is found at ``/etc/php5/fpm/conf.d``:

.. code-block:: bash
  
  20-redis.ini -> ../../mods-available/redis.ini

If the link is not present, create it with:

.. code-block:: bash
  
  cd /etc/php5/fpm/conf.d
  ln -s ../../mods-available/redis.ini /etc/php5/fpm/conf.d/20-redis.ini

| Do the same for ``cli``. 
| You can check PHP-cli-Redis with the command below, after that you should see "OK".

.. code-block:: bash
  
  php -r "if (new Redis() == true){ echo \"\r\n OK \r\n\"; }"

| Restart your Web server and if needed ``php5-fpm``.
| 
| If you later want to monitor the commands processed by the Redis server, we recommend
| reading `Monitoring Redis <http://redis.io/commands/MONITOR>`_.
| 

Instance Preparation
^^^^^^^^^^^^^^^^^^^^
 
| Add the appropriate entries to your ``config.php``, and refresh your ownCloud admin page.
| 
| Here are some example configurations:

- Use Redis for the local server cache:
  
  ::
  
    'memcache.local' => '\OC\Memcache\Redis',
    'redis' => array(
         'host' => 'localhost',
         'port' => 6379,
         'password' => '', // Optional, if not defined no password will be used.
         ),

- For best performance, use Redis for file locking by adding this:
  
  ::
  
    'memcache.locking' => '\OC\Memcache\Redis',

- If you want to connect to Redis configured to listen on an unix socket (which is recommended if Redis is running on the same system as ownCloud), use the following configuration:
  
  ::
  
    'memcache.local' => '\OC\Memcache\Redis',
    'redis' => array(
         'host' => '/var/run/redis/redis.sock',
         'port' => 0,
          ),

.. note:: For enhanced security it is recommended to configure Redis to require
   a password. See http://redis.io/topics/security for more information.

.. note:: Consider reading `Performance tips for Redis Cache Server <https://www.techandme.se/performance-tips-for-redis-cache-server>`_

Redis is very configurable; consult `the Redis documentation 
<http://redis.io/documentation>`_ to learn more. 

If you are on Ubuntu you can also follow `this guide 
<https://www.techandme.se/how-to-configure-redis-cache-in-ubuntu-14-04-with-owncloud/>`_ for a complete installation from scratch. 

Cache Directory Location
------------------------

The cache directory defaults to ``data/$user/cache`` where ``$user`` is the 
current user. You may use the ``'cache_path'`` directive in ``config.php``
(See :doc:`config_sample_php_parameters`) to select a different location.

Recommendation Based on Type of Deployment
------------------------------------------

Small/private home server
^^^^^^^^^^^^^^^^^^^^^^^^^

Only use APCu::

    'memcache.local' => '\OC\Memcache\APCu',

Small organization, single-server setup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use APCu for local caching, Redis for file locking::

 'memcache.local' => '\OC\Memcache\APCu',
 'memcache.locking' => '\OC\Memcache\Redis',
  'redis' => array(
       'host' => 'localhost',
       'port' => 6379,
        ),

Large organization, clustered setup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use Redis for everything except local memcache::

  'memcache.distributed' => '\OC\Memcache\Redis',
  'memcache.locking' => '\OC\Memcache\Redis',
  'memcache.local' => '\OC\Memcache\APCu',
  'redis' => array(
       'host' => 'localhost',
       'port' => 6379,
        ),
