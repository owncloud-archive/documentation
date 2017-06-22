==========================
Transactional File Locking
==========================

ownCloud's Transactional File Locking mechanism locks files to avoid 
file corruption during normal operation. It performs these functions:

* Operates at a higher level than the filesystem, so you don't need to use a 
  filesystem that supports locking
* Locks parent directories so they cannot be renamed during any activity on 
  files inside the directories
* Releases locks after file transactions are interrupted, for 
  example when a sync client loses the connection during an upload
* Manages locking and releasing locks correctly on shared files during changes 
  from multiple users
* Manages locks correctly on external storage mounts
* Manages encrypted files correctly

Transactional File locking will not prevent multiple users from editing the same 
document, nor give notice that other users are working on the same document. 
Multiple users can open and edit a file at the same time and Transactional File 
locking does not prevent this. 
Rather, it prevents simultaneous file saving.

.. note:: Transactional file locking is in ownCloud core, and replaces the old 
   File Locking app. The File Locking app has been removed from ownCloud in 
   version 8.2.1. If your ownCloud server still has the File Locking app, you 
   must visit your Apps page to verify that it is disabled; the File Locking 
   app and Transactional File Locking cannot both operate at the same time.
  
File locking is enabled by default, using the database locking backend. 
This places a significant load on your database. Using ``memcache.locking`` relieves the database load and improves performance. 
Admins of ownCloud servers with heavy workloads should install :doc:`a memory cache <../server/caching_configuration>`. 

