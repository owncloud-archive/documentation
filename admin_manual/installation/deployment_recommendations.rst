===================================
ownCloud Deployment Recommendations
===================================

What is the best way to install and maintain ownCloud? The answer to that is 
*"it depends"* because every ownCloud customer has their own 
particular needs and IT infrastructure. ownCloud and the LAMP stack are 
highly-configurable, so we will present three typical scenarios and make 
best-practice recommendations for both software and hardware.

General Recommendations
-----------------------

.. note:: Whatever the size of your organization, always keep one thing in mind: 
   the amount of data stored in ownCloud will only grow. Plan ahead.

Consider setting up a scale-out deployment, or using Federated Cloud Sharing to 
keep individual ownCloud instances to a manageable size.

* Operating system: Ubuntu 16.04 LTS.
* Web server: Apache 2.4.
* Database: MySQL/MariaDB with InnoDB storage engine (MyISAM is not supported, see: :ref:`db-storage-engine-label`)
* PHP 7.

Small Workgroups or Departments
-------------------------------

* Number of users
   Up to 150 users.

* High availability level
   Zero-downtime backups via filesystem snapshots, component failure leads to 
   interruption of service. Alternative backup scheme: 
   nightly backups with service interruption.

Recommended System Setup
^^^^^^^^^^^^^^^^^^^^^^^^

One machine running the application server, Web server, database server and 
local storage.

Authentication via an existing LDAP or Active Directory server.

.. figure:: images/deprecs-1.png
   :alt: Network diagram for small enterprises.

* Components
   One server with at least 2 CPU cores, 16GB RAM, local storage as needed.

* Operating system
   Enterprise-grade Linux distribution with full support from OS vendor. We 
   recommend Ubuntu 16.04 LTS. Other distributions are also supported (e.g. 
   RedHat or SuSE) but they may not ship all the required dependencies in their 
   official repositories and therefore it may be necessary to enable third party 
   repositories for modules like APCu and Redis.

* SSL Configuration
   The SSL termination is done in Apache. A standard SSL certificate is 
   needed, installed according to the Apache documentation.

* Load Balancer
   None. 

* Database
   We currently recommend MySQL / MariaDB, as our customers have had good experiences 
   with these when moving to a Galera cluster to scale the DB. (InnoDB storage engine, MyISAM is 
   not supported, see: :ref:`db-storage-engine-label`)

* Authentication
   User authentication via one or several LDAP or Active Directory servers. (See
   `User Authentication with LDAP`_ for information on configuring ownCloud to 
   use LDAP and AD.)

* Session Management
   Local session management on the application server. PHP sessions are stored 
   in a tmpfs mounted at the operating system-specific session storage 
   location. You can find out where that is by running ``grep -R 
   'session.save_path' /etc/php5`` and then add it to the ``/etc/fstab`` file, 
   for example: 
   ``echo "tmpfs /var/lib/php5/pool-www tmpfs defaults,noatime,mode=1777 0 0" 
   >> /etc/fstab``.

* Memory Caching
   We recommend:
   - APC/APCu for local caching. 
   - Redis for Transactional File Locking and distributed caching, running on a dedicated server. 
   A memcache speeds up server performance, and ownCloud supports four 
   memcaches; refer to `Configuring Memory Caching`_ for information on 
   selecting and configuring a memcache.

* Storage
   Local storage.

Mid-sized Enterprises
---------------------

* Number of users
   150 to 1,000 users.

* High availability level
   Every component is fully redundant and can fail without service interruption. 
   Backups without service interruption

Recommended System Requirements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

2 to 4 application servers.

A cluster of two database servers.

Storage on an NFS server, or an object store that is S3 compatible.

Authentication via an existing LDAP or Active Directory server.

.. figure:: images/deprecs-2.png
   :alt: Network diagram for mid-sized enterprise.

* Components
   * 2 to 4 application servers with 4 sockets and 32GB RAM.
   * 2 DB servers with 4 sockets and 32GB RAM.
   * 1 HAproxy load balancer with 2 sockets and 16GB RAM.
   * NFS storage server as needed.

* Operating system
   Enterprise-grade Linux distribution with full support from OS vendor. We 
   recommend Ubuntu 16.04 LTS. Other distributions are also supported (e.g. 
   RedHat or SuSE) but they may not ship all the required dependencies in their 
   official repositories and therefore it may be necessary to enable third party 
   repositories for modules like APCu and Redis.

* SSL Configuration
   The SSL termination is done in the HAProxy load balancer. A standard SSL 
   certificate is needed, installed according to the `HAProxy documentation`_.

* Load Balancer
   HAProxy running on a dedicated server in front of the application servers. 
   Sticky session needs to be used because of local session management on the 
   application servers. 

* Database
   We recommend MySQL/MariaDB, either as a Galera cluster with master-master replication or as a master-slave setup with automatic failover. (InnoDB storage engine, MyISAM is not supported, see: :ref:`db-storage-engine-label`)

* Authentication
   User authentication via one or several LDAP or Active Directory servers. 
   (See `User Authentication with LDAP`_  for information on configuring 
   ownCloud to use LDAP and AD.)
 
* LDAP 
   Read-only slaves should be deployed on every application server for 
   optimal scalability

* Session Management
   Session management on the application server. PHP sessions are stored 
   in a tmpfs mounted at the operating system-specific session storage 
   location. You can find out where that is by running ``grep -R 
   'session.save_path' /etc/php5`` and then add it to the ``/etc/fstab`` file, 
   for example: 
   ``echo "tmpfs /var/lib/php5/pool-www tmpfs defaults,noatime,mode=1777 0 0" 
   >> /etc/fstab``.

* Memory Caching
   We recommend:
   - APC/APCu for local caching. 
   - Redis for Transactional File Locking and distributed caching, running on a dedicated server. 
   A memcache speeds up server performance, and ownCloud supports four 
   memcaches; refer to `Configuring Memory Caching`_ for information on 
   selecting and configuring a memcache.
 
* Storage
   Use an off-the-shelf NFS solution, such as IBM Elastic Storage or RedHat 
   Ceph.

Large Enterprises and Service Providers
---------------------------------------

* Number of users
   5,000 to >100,000 users.
 
* High availabily level
   Every component is fully redundant and can fail without service interruption.
   Backups without service interruption  
 
Recommended System Requirements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

More than 4 application/web servers.

A cluster of two or more database servers.

Storage on an NFS server, or an object store that is S3 compatible.

Cloud federation for a distributed setup over several data centers.

Authentication via an existing LDAP or Active Directory server, or SAML.

.. figure:: images/deprecs-3.png
   :scale: 60%
   :alt: Network diagram for large enterprise. 

* Components
   * more than 4 application servers with 4 sockets and 64GB  RAM.
   * 4 DB servers with 4 sockets and 64GB RAM
   * 2 Hardware load balancer, for example BIG IP from F5
   * NFS storage server as needed.

* Operating system
   Enterprise-grade Linux distribution with full support from OS vendor. We 
   recommend Ubuntu 16.04 LTS. Other distributions are also supported (e.g. 
   RedHat or SuSE) but they may not ship all the required dependencies in their 
   official repositories and therefore it may be necessary to enable third party 
   repositories for modules like APCu and Redis.

* SSL Configuration
   The SSL termination is done in the load balancer. A standard SSL certificate 
   is needed, installed according to the specific load balancer's documentation. 

* Load Balancer
   A redundant hardware load-balancer with heartbeat, for example `F5 Big-IP`_. 
   This runs two load balancers in front of the application servers.

* Database
   We recommend MySQL/MariaDB, either as a Galera cluster with master-master replication or as a master-slave setup with automatic failover. (InnoDB storage engine, MyISAM is not supported, see: :ref:`db-storage-engine-label`)

* Authentication
   User authentication via one or several LDAP or Active Directory 
   servers, or SAML/Shibboleth. (See `User Authentication with LDAP`_ and 
   `Shibboleth Integration`_.) 

* LDAP
   Read-only slaves should be deployed on every application server for 
   optimal scalability.

* Session Management
   Redis should be used for the session management storage.

* Caching
   We recommend:
   - APC/APCu for local caching. 
   - Redis for Transactional File Locking and distributed caching, running on a dedicated server. 
   A memcache speeds up server performance, and ownCloud supports four 
   memcaches; refer to `Configuring Memory Caching`_ for information on 
   selecting and configuring a memcache.
 
* Storage
   An off-the-shelf NFS solution should be used. Examples are IBM Elastic 
   Storage or RedHat Ceph. Optionally, an S3 compatible object store can also 
   be used.
 
Hardware Considerations
-----------------------

* Solid-state drives (SSDs) are mandatory for optimum I/O performance.
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

* No high availability options.
* The amount of data in ownCloud tends to grow continually. Eventually, a 
  single machine will not scale; I/O performance decreases and becomes a 
  bottleneck with multiple up- and downloads, even with solid-state drives.

Scale-Out Deployment
^^^^^^^^^^^^^^^^^^^^

Provider setup:

* DNS round robin to HAProxy servers (2-n, SSL offloading, static resource caching)
* Distribution of traffic among web servers means less load per server (2-n)
* Redis for shared session storage (2-n)
* Database cluster with single Master, multiple slaves and proxy to split 
  requests accordingly (2-n)
* GPFS or Ceph via phprados (2-n, 3 to be safe, Ceph 10+ nodes to see speed 
  benefits under load)

Pros:

* Components can be scaled as needed.
* High availability.
* Test upgrades can be performed more easily.

Cons:

* More complicated to setup.
* Network becomes the bottleneck (10GB Ethernet recommended).
* Currently DB filecache table will grow rapidly, making migrations painful in 
  case the table is altered.

What About Nginx?
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Could be used instead of HAproxy as the load balancer.

Software Considerations
-----------------------

Operating System
^^^^^^^^^^^^^^^^

ownCloud is dependent on distributions that offer an easy way to install the various 
components in up-to-date versions. From our experience, we strongly recommend to 
use Ubuntu 16.04 LTS, since all the required dependencies are included out of the box. 
Canonical, the parent company of Ubuntu Linux, also offers enterprise service and 
support.

ownCloud has a partnership with RedHat and SUSE for customers who need commercial 
support. CentOS is the community-supported free-of-cost Red Hat Enterprise Linux 
clone. openSUSE is community-supported, and includes many of the same system 
administration tools as SUSE Linux Enterprise Server.

Web server
^^^^^^^^^^

Taking Apache and Nginx as the contenders, Apache with mod_php is currently the 
best option, as Nginx does not support all features necessary for enterprise 
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

What about the other DBMS?

* PostgreSQL is a good alternative to MySQL/MariaDB (alter table does not lock table, which 
  makes migration less painful), although master-slave setup are very uncommon.
* Sqlite is adequate for simple testing, and for low-load single-user 
  deployments. It is not adequate for production systems.
* Microsoft SQL Server is not a supported option.
* Oracle DB is the de facto standard at large enterprises and is fully
  supported with ownCloud Enterprise Edition only.

.. note:: A Single Master DB is a single point of failure, because it does not scale

          When the master fails a slave can become a new master. However, the increased 
          complexity carries some risks: Multi-master has the risk of split brain, and 
          deadlocks. ownCloud tries to solve the problem of deadlocks with high-level transactional 
          file locking.


File Storage
------------

While many customers are starting with NFS, sooner or later that requires scale-out storage. Currently the options are DRBD, GPFS or GlusterFS, or an object store protocol like S3 (supported in Enterprise Edition only) or Swift. S3 also allows access to Ceph Storage.

Session Storage
---------------

* Redis: provides persistence, nice graphical inspection tools available, 
  supports ownCloud high-level file locking.

* If Shibboleth is a requirement you must use Memcached, and it can also be 
  used to scale-out shibd session storage (see `Memcache StorageService`_).

References
----------

`Database High Availability`_
   
`Performance enhancements for Apache and PHP`_

`How to Set Up a Redis Server as a Session Handler for PHP on Ubuntu 14.04`_
  

.. _Maintenance: 
   https://doc.owncloud.com/server/9.1/admin_manual/maintenance/index.html
.. _User Authentication with LDAP:
   https://doc.owncloud.com/server/9.1/admin_manual/configuration_user/    
   user_auth_ldap.html
.. _Configuring Memory Caching: 
   https://doc.owncloud.com/server/9.1/admin_manual/configuration_server/ 
   caching_configuration.html
.. _ownCloud Server or Enterprise Edition:  
   https://owncloud.com/community-or-enterprise/
.. _F5 Big-IP: https://f5.com/products/big-ip/

.. _Shibboleth Integration: 
   https://doc.owncloud.com/server/9.1/admin_manual/enterprise_user_management/
   user_auth_shibboleth.html
.. _Memcache StorageService:  
   https://wiki.shibboleth.net/confluence/display/SHIB2/
   NativeSPStorageService#NativeSPStorageService-MemcacheStorageService
   
.. _Database High Availability: 
   http://www.severalnines.com/blog/become-mysql-dba-blog-series-database-high-
   availability
.. _Performance enhancements for Apache and PHP: 
   http://blog.bitnami.com/2014/06/performance-enhacements-for-apache-and.html  
.. _How to Set Up a Redis Server as a Session Handler for PHP on Ubuntu 14.04: 
   https://www.digitalocean.com/community/tutorials/how-to-set-up-a-redis-server
   -as -a-session-handler-for-php-on-ubuntu-14-04
.. _HAProxy documentation:
   http://www.haproxy.org/#docs
