=========================
Deployment Considerations
=========================

Hardware 
--------

* Solid-state drives (SSDs) for I/O.
* Separate hard disks for storage and database, SSDs for databases.
* Multiple network interfaces to distribute server synchronisation and backend 
  traffic across multiple subnets.

Single Machine / Scale-Up Deployment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The single-machine deployment is widely used in the community.

Pros:

* Easy setup: no session storage daemon, use tmpfs and memory caching to 
  enhance performance, local storage.
* No network latency to consider.
* To scale buy a bigger CPU, more memory, larger hard drive, or additional hard 
  drives.

Cons:

* Fewer high availability options.
* The amount of data in ownCloud tends to continually grow. Eventually a 
  single machine will not scale; I/O performance decreases and becomes a 
  bottleneck with multiple up- and downloads, even with solid-state drives.

Scale-Out Deployment
^^^^^^^^^^^^^^^^^^^^

Provider setup:

* DNS round robin to HAProxy servers (2-n, SSL offloading, cache static 
  resources)
* Least load to Apache servers (2-n)
* Memcached/Redis for shared session storage (2-n)
* Database cluster with single Master, multiple slaves and proxy to split 
  requests accordingly (2-n)
* GPFS or Ceph via phprados (2-n, 3 to be safe, Ceph 10+ nodes to see speed 
  benefits under load)

Pros:

* Components can be scaled as needed.
* High availability.
* Test migrations easier.

Cons:

* More complicated to setup.
* Network becomes the bottleneck (10GB Ethernet recommended).
* Currently DB filecache table will grow rapidly, making migrations painful in 
  case the table is altered.

What About NGINX / PHP-FPM?
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Could be used instead of HAproxy as the load balancer.
But on uploads stores the whole file on disk before handing it over to PHP-FPM.

A Single Master DB is Single Point of Failure, Does Not Scale
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When master fails another slave can become master. However, the increased 
complexity carries some risks: Multi-master has the risk of split brain, and 
deadlocks. ownCloud tries to solve the problem of deadlocks with high-level 
file locking.

Software
--------

Operating System
^^^^^^^^^^^^^^^^

We are dependent on distributions that offer an easy way to install the various 
components in up-to-date versions. ownCloud has a partnership with RedHat 
and SUSE for customers who need commercial support. Canonical, the parent 
company of Ubuntu Linux, also offers enterprise service and support. Debian 
and Ubuntu are free of cost, and include newer software packages. CentOS is the 
community-supported free-of-cost Red Hat Enterprise Linux clone. openSUSE is 
community-supported, and includes many of the same system administration tools 
as SUSE Linux Enterprise Server.

Web server
^^^^^^^^^^

Taking Apache and NGINX as the contenders, Apache with mod_php is currently the 
best option, as NGINX does not support all features necessary for enterprise 
deployments. Mod_php is recommended instead of PHP_FPM, because in scale-out 
deployments separate PHP pools are simply not necessary.

Relational Database
^^^^^^^^^^^^^^^^^^^

More often than not the customer already has an opinion on what database to 
use. In general, the recommendation is to use what their database administrator 
is most familiar with. Taking into account what we are seeing at customer 
deployments, we recommend MySQL/MariaDB in a master-slave deployment with a 
MySQL proxy in front of them to send updates to master, and selects to the 
slave(s).

The second best option is PostgreSQL (alter table does not lock table, which 
makes migration less painful) although we have yet to find a customer who uses a 
master-slave setup.

What about the other DBMS?

* Sqlite is adequate for simple testing, and for low-load single-user 
  deployments. It is not adequate for production systems.
* Microsoft SQL Server is not a supported option.
* Oracle DB is the de facto standard at large enterprises and is fully
  supported with ownCloud Enterprise Edition only.

File Storage
------------

While many customers are starting with NFS, sooner or later that requires scale-out storage. Currently the options are GPFS or GlusterFS, or an object store protocol like S3 (supported in Enterprise Edition only) or Swift. S3 also allows access to Ceph Storage.

Session Storage
---------------

* Redis: provides persistence, nice graphical inspection tools available, 
  supports ownCloud high-level file locking.
   
* If Shibboleth is a requirement you must use Memcached, and it can also be 
  used to scale-out shibd session storage (see `Memcache StorageService`_).

.. Links
   
.. _Memcache StorageService:  
   https://wiki.shibboleth.net/confluence/display/SHIB2/
   NativeSPStorageService#NativeSPStorageService-MemcacheStorageService
   
