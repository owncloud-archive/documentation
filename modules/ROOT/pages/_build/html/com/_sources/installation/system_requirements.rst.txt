===================
System Requirements
===================

Officially Recommended & Supported Options
------------------------------------------

For *best performance*, *stability*, *support*, and *full functionality* we officially recommend and support:

Server
^^^^^^

================= =================================================================================
Platform          Options
================= =================================================================================
Operating System  Ubuntu 16.04, 17.04 and 17.10; Debian 7, 8 and 9; SUSE Linux Enterprise Server 12 
                  with SP1, SP2 and SP3; Red Hat Enterprise Linux/Centos 6.9, 7.3 and 7.4;
                  Fedora 26, 27 and 28; open Suse Tumbleweed and Leap 42.1, 42.2, 42.3
Database          MySQL or MariaDB 5.5+, Oracle 11g, PostgreSQL, & SQLite
Web server        Apache 2.4 with ``prefork`` :ref:`apache-mpm-label` and ``mod_php``
PHP Runtime       PHP (5.6+, 7.0, & 7.1)
================= =================================================================================

.. important:: 

    For the future release of ownCloud 10.1, a minimum php version of 7.1 is needed.
    If you use Ubuntu 16.04:

    - PHP 7.1 is only available via ppa. To add a ppa to your system, use this command: ``sudo add-apt-repository ppa:user/ppa-name``.
    - PHP 7.2 standard installable, but you have to install some mandatory modules yourself, like `intl`_.

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

- Edge (current version on Windows 10)
- IE11+ (except Compatibility Mode)
- Firefox 57+ or 52 ESR
- Chrome 64+
- Safari 10+

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
- Fedora 26 & 27
- Ubuntu 16.04 & 17.04 & 17.10
- openSUSE Leap 42.2 & 42.3

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
.. _intl: http://php.net/manual/en/intro.intl.php
