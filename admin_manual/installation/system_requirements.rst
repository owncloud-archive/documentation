===================
System Requirements
===================

Officially Recommended & Supported Options
------------------------------------------

For *best performance*, *stability*, *support*, and *full functionality* we officially recommend and support:

Server
^^^^^^

+-----------------------+-----------------------------------------------------------------------+
| Platform              | Options                                                               |
+=======================+=======================================================================+
| Operating System      | - Centos Linux 6 and 7                                                |
|                       | - Debian 7 and 8                                                      |
|                       | - Fedora 27 and 28                                                    |
|                       | - Red Hat Enterprise Linux 6 and 7                                    |
|                       | - SUSE Linux Enterprise Server 12 with SP1, SP2 and SP3               |
|                       | - openSUSE Tumbleweed and Leap 15.0, 42.3                             |
|                       | - Ubuntu 16.04 and 18.04                                              |
+-----------------------+-----------------------------------------------------------------------+
| Database              | - MySQL or MariaDB 5.5+                                               |
|                       | - Oracle 11g                                                          |
|                       | - PostgreSQL                                                          |
|                       | - SQLite                                                              |
+-----------------------+-----------------------------------------------------------------------+
| Web server            | - Apache 2.4 with ``prefork`` :ref:`apache-mpm-label` and ``mod_php`` |
+-----------------------+-----------------------------------------------------------------------+
| PHP Runtime\ :sup:`*` | - 5.6, 7.0, 7.1 & 7.2                                                 |
+-----------------------+-----------------------------------------------------------------------+

.. note:: \*\ We strongly encourage you to migrate to PHP 7.1+.

.. Distribution Release Schedules

.. - Debian: https://wiki.debian.org/LTS
.. - Ubuntu: https://www.ubuntu.com/info/release-end-of-life
.. - Fedora: https://en.wikipedia.org/wiki/Fedora_version_history
.. - openSUSE: https://en.opensuse.org/Lifetime
.. - Red Hat / Fedora: https://access.redhat.com/articles/3078
.. - SUSE: https://www.suse.com/releasenotes/
.. - Mozilla: https://wiki.mozilla.org/Release_Management/Calendar

.. important::

    For the future release of ownCloud 10.1, a minimum php version of 7.1 is needed.
    If you use Ubuntu 16.04:

    - PHP 7.1 or 7.2 is only available via ppa. To add a ppa to your system, use this command: ``sudo add-apt-repository ppa:user/ppa-name``.

.. note::

   - Red Hat Enterprise Linux & Centos 7 are 64-bit only.
   - Oracle 11g is only supported for the Enterprise edition.
   - SQLite is not encouraged for production use.

Mobile
^^^^^^

- iOS 9.0+
- Android 4.0+

.. _supported-browsers-label:

Web Browser
^^^^^^^^^^^
.. Only the latest versions from desktop and mobile apps are supported


- Edge (current version on Windows 10)
- IE11+ (except Compatibility Mode)
- Firefox 62 or 60.2 ESR
- Google Chrome 68+
- Safari 11

Hypervisors
^^^^^^^^^^^

- Hyper-V
- VMware ESX
- Xen
- KVM

Desktop
^^^^^^^

- Windows 7, 8+
- Mac OS X 10.12+ (**64-bit only**)
- CentOS 6 & 7 (64-bit only)
- Debian 7 & 8
- Fedora 27 & 28
- Ubuntu 16.04 & 18.04
- openSUSE Leap 15.0, 42.3

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
* "READ COMMITTED" transaction isolation level (See: :ref:`db-transaction-label`)

.. Links

.. _LTS: https://wiki.ubuntu.com/LTS
.. _intl: http://php.net/manual/en/intro.intl.php

