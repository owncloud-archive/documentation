===================
System Requirements
===================

Memory
------

Memory requirements for running an ownCloud server are greatly variable,
depending on the numbers of users and files, and volume of server activity.
ownCloud officially requires a minimum of 128MB RAM. But, we recommend
a minimum of 512MB. 

.. note:: *Consideration for low memory environments*
   
  Scanning of files is committed internally in 10k files chunks. 
  Based on tests, server memory usage for scanning greater than 10k files uses about 75MB of additional memory.

Recommended Setup for Running ownCloud
--------------------------------------

For *best performance*, *stability*, *support*, and *full functionality* we
officially recommend and support:

================= =============================================================
Platform          Options
================= =============================================================
Operating System  Ubuntu 16.04
Database          MySQL or MariaDB 5.5+
Web server        Apache 2.4 with mod_php
PHP Runtime       PHP (5.6+ or 7.0+)
================= =============================================================

Supported Platforms
-------------------

If you are not able to use one or more of the above tools, the following
options are also supported. 

Server
^^^^^^

- Debian 7 and 8
- SUSE Linux Enterprise Server 12 and 12 SP1
- Red Hat Enterprise Linux/Centos 6.5 and 7 (**7 is 64-bit only**)
- Ubuntu 14.04 LTS

Web Server
^^^^^^^^^^

- Apache 2.4 with mod_php

Databases
^^^^^^^^^

- Oracle 11g (**Enterprise edition only**)
- PostgreSQL

Hypervisors 
^^^^^^^^^^^

- Hyper-V
- VMware ESX
- Xen
- KVM

Desktop
^^^^^^^

- Windows 7+
- Mac OS X 10.7+ (64-bit only)


- Ubuntu 16.10
- Ubuntu 16.04
- Ubuntu 14.04
- Debian 7.0
- Debian 8.0
- CentOS 7
- Fedora 24
- Fedora 25
- openSUSE Leap 42.1
- openSUSE Leap 42.2

.. note::
   For Linux distributions, we support, if technically feasible, the latest 2 versions per platform and the previous `LTS`_.

Mobile 
^^^^^^

- iOS 9.0+
- Android 4.0+

Web Browser 
^^^^^^^^^^^

- IE11+ (except Compatibility Mode)
- Firefox 14+
- Chrome 18+
- Safari 5+

See :doc:`source_installation` for minimum software versions for installing
ownCloud.

Database Requirements for MySQL / MariaDB
-----------------------------------------

The following are currently required if you're running ownCloud together with a MySQL or MariaDB database:

* Disabled or ``BINLOG_FORMAT = MIXED`` or ``BINLOG_FORMAT = ROW`` configured Binary Logging (See: :ref:`db-binlog-label`)
* InnoDB storage engine (The MyISAM storage engine is not supported, see: :ref:`db-storage-engine-label`)
* "READ COMMITED" transaction isolation level (See: :ref:`db-transaction-label`)

.. Links
   
.. _LTS: https://wiki.ubuntu.com/LTS
