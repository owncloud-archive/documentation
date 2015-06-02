===========================
Using the Files Locking App
===========================

The Files Locking application enables ownCloud to lock files while reading or 
writing to and from backend storage. The purpose of the app is to avoid file 
corruption during normal operation. Operating at a very low level in ownCloud, 
this application requests and respects file system locks. For example, when 
ownCloud is writing an uploaded file to the server, ownCloud requests a write 
lock. If the underlying storage supports locking, ownCloud will request and 
maintain an exclusive write lock for the duration of this write operation. When 
completed, ownCloud will then release the lock through the filesystem. If the 
file system does not support locking, there is no need to enable this 
application as any lock requested by ownCloud will not be honored in the 
underlying filesystem.

The Files Locking app has no configuration options; all you need to do is 
enable or disable it on your Apps page.

.. figure:: ../images/files_locking_app.png

We recommend using `Redis <http://redis.io/>`_ as your ownCloud memcache when 
you enable the Files Locking app. Memcached, the popular distributed memory 
caching system, is not suitable for a file locking app because it is designed 
to improve dynamic Web site performance. It is not designed to store locks, and 
data can disappear from the cache at any time. Redis is more than an object 
cache like Memcached; it is also a key-value store, so it guarantees that 
cached objects are available for as long as they are needed. Redis is available 
on most Linux distributions, and requires a simple configuration in your 
``config.php`` file, like this example::

 'memcache.local' => '\OC\Memcache\redis',
 'redis' => array(
	'host' => 'localhost', 
	// can also be a unix domain socket: 
        '/tmp/redis.sock'
	'port' => 6379,
	'timeout' => 0.0,
	// Optional, if undefined SELECT will not run and will use Redis 
        // Server's default DB Index.
	'dbindex' => 0, 
 ),
 
See ``config.sample.php`` to see configuration examples for all memcaches. 
