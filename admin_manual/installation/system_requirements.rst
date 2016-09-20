===================
System Requirements
===================

Memory
------

Memory requirements for running an ownCloud server are greatly variable, 
depending on the numbers of users and files, and volume of server activity. 
ownCloud needs a minimum of 128MB RAM, and we recommend a minimum of 512MB.

Recommended Setup for Running ownCloud
--------------------------------------

For best performance, stability, support, and full functionality we recommend:

* Ubuntu 16.04
* MySQL/MariaDB
* PHP 5.6 +
* Apache 2.4 with mod_php

Supported Platforms
-------------------

* Server: Linux (Debian 7 and 8, SUSE Linux Enterprise Server 12 and 12 SP1, Red Hat Enterprise Linux/Centos 6.5 and 7 (7 is 64-bit only), Ubuntu 14.04 LTS, 16.04 LTS)
* Web server: Apache 2.4 with mod_php
* Databases: MySQL/MariaDB 5.5+; Oracle 11g (ownCloud Enterprise edition only); PostgreSQL
* PHP 5.4 + required
* Hypervisors: Hyper-V, VMware ESX, Xen, KVM
* Desktop: Windows 7+, Mac OS X 10.7+ (64-bit 
  only), Linux (CentOS 6.5, 7 (7 is 64-bit only), Ubuntu 12.04+, Fedora 20+, openSUSE 12.3+, Debian 7 & 8).
* Mobile apps: iOS 7+, Android 4+
* Web browser: IE11+ (except Compatibility Mode), Firefox 14+, Chrome 18+, 
  Safari 5+

See :doc:`source_installation` for minimum software versions for installing 
ownCloud.

Database Requirements for MySQL / MariaDB
-----------------------------------------

The following is currently required if you're running ownCloud together with a MySQL / MariaDB database:

* Disabled or BINLOG_FORMAT = MIXED configured Binary Logging (See: :ref:`db-binlog-label`)
* InnoDB storage engine (MyISAM is not supported, see: :ref:`db-storage-engine-label`)
* "READ COMMITED" transaction isolation level (See: :ref:`db-transaction-label`)
