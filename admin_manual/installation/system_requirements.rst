===================
System Requirements
===================

Officially Recommended & Supported Options
------------------------------------------

For *best performance*, *stability*, *support*, and *full functionality* we officially recommend and support:

Server
^^^^^^

================= =============================================================
Platform          Options
================= =============================================================
Operating System  Ubuntu 16.04, Debian 7 and 8, SUSE Linux Enterprise Server 12 
                  and 12 SP1, Red Hat Enterprise Linux/Centos 6.5 and 7 
Database          MySQL or MariaDB 5.5+, Oracle 11g, PostgreSQL, & SQLite
Web server        Apache 2.4 with mod_php
PHP Runtime       PHP (5.6+, 7.0, & 7.1)
================= =============================================================

.. note::
   
   - Red Hat Enterprise Linux & Centos 7 are 64-bit only.
   - Oracle 11g is only supported for the Enterprise edition.
   - SQLite is not encouraged for production use.

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
- CentOS 6 & 7 (64-bit only)
- Debian 7.0 & 8.0 & 9.0
- Fedora 24 & 25 & 26
- Ubuntu 16.04 & 16.10 & 17.04
- openSUSE Leap 42.1 & 42.2 & 42.3

.. note::
   For Linux distributions, we support, if technically feasible, the latest 2 versions per platform and the previous `LTS`_.

Alternative (But Unsupported) Options
-------------------------------------

If you are not able to use one or more of the above tools, the following options are also available. 

Web Server
^^^^^^^^^^

- NGINX with PHP-FPM 

Memory Requirements
-------------------

Memory requirements for running an ownCloud server are greatly variable,
depending on the numbers of users and files, and volume of server activity.
ownCloud officially requires a minimum of 128MB RAM. But, we recommend a minimum of 512MB. 

.. note:: *Consideration for low memory environments*
   
  Scanning of files is committed internally in 10k files chunks. 
  Based on tests, server memory usage for scanning greater than 10k files uses about 75MB of additional memory.

Database Requirements
---------------------

The following are currently required if you're running ownCloud together with a MySQL or MariaDB database:

* Disabled or ``BINLOG_FORMAT = MIXED`` or ``BINLOG_FORMAT = ROW`` configured Binary Logging (See: :ref:`db-binlog-label`)
* InnoDB storage engine (The MyISAM storage engine is not supported, see: :ref:`db-storage-engine-label`)
* "READ COMMITED" transaction isolation level (See: :ref:`db-transaction-label`)

.. Links
   
.. _LTS: https://wiki.ubuntu.com/LTS
