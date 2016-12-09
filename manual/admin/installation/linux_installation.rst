===================================
Preferred Linux Installation Method
===================================

For production environments, we recommend the installation from the tar archive. 
This applies in particular to scenarios, where the Web server, storage and database are on separate machines. 
In this constellation, all dependencies and requirements are managed by the package management 
of your operating system, while the ownCloud code itself is maintained in a sequence of simple steps 
as documented in our instructions for the :doc:`Manual Installation on Linux <source_installation>` and the :doc:`Manual ownCloud Upgrade <../maintenance/manual_upgrade>`.

The package installation is for single-server setups only.

Changes in ownCloud 9
---------------------

Linux distribution packages (from `Open Build Service`_) have been divided into 
multiple packages for ownCloud 9: ``owncloud``, ``owncloud-deps`` and ``owncloud-files``. 

Install the metapackage ``owncloud`` to get a complete installation with all dependencies.

The ``owncloud-files`` package installs only ownCloud, without Apache, database, 
or PHP dependencies. 

The ``owncloud-deps`` packages install all dependencies: Apache, PHP, and MySQL. 
``owncloud-deps`` is not intended to be installed by itself, but rather is 
pulled in by the metapackage ``owncloud``. 

``owncloud-files`` is available for the following distributions, but not 
``owncloud-deps``.

You will have to install your own LAMP stack first. This 
allows you to create your own custom LAMP stack without dependency conflicts 
with the ownCloud package. Browse 
`<http://download.owncloud.org/download/repositories/9.1/owncloud/>`_ to find 
the ``owncloud-files`` package for your distro:

* Ubuntu 14.04, 16.04
* Debian 7, 8
* RHEL 6, 7
* CentOS 6 SCL, 7
* SLES 12, 12 SP1
* openSUSE 13.2, Leap 42.1

ownCloud packages with dependencies are available for the following Linux distributions:

* Ubuntu 14.04, 16.04
* Debian 8
* RHEL 7
* CentOS 7
* SLES 12
* openSUSE 13.2, Leap 42.1

Repositories for Fedora, openSUSE Tumbleweed and Ubuntu 15.04 were dropped. If 
you use Fedora, use the tar archive with your own LAMP stack. openSUSE 
users can rely on LEAP packages for Tumbleweed.

Follow the instructions on the download page to install ownCloud. Then run the 
Installation Wizard to complete your installation. (see 
:doc:`installation_wizard`).

.. warning:: Do not move the folders provided by these packages after the 
   installation, as this will break updates.

See the :doc:`system_requirements` for the recommended ownCloud setup and 
supported platforms.

Repos: Stable or Major Release?
-------------------------------

You may use either of the following repositories for ownCloud 9.1:

* `<https://download.owncloud.org/download/repositories/stable/owncloud/>`_
* `<https://download.owncloud.org/download/repositories/9.1/owncloud/>`_

When you use the Stable repo, you never have to change it as it always tracks 
the current stable ownCloud version through all major releases: 8.2, 9.0, 
and so on. (Major releases are indicated by the second number, so 8.0, 8.1, 
8.2, and 9.0 were all major releases.)

If you wish to track a specific major release, such as 9.0 or 9.1, then use 
that repo. That way you won't accidentally find yourself looking at an upgrade 
to the next major release before you're ready.

Installing ownCloud Enterprise Edition
--------------------------------------

See :doc:`../enterprise_installation/linux_installation` for instructions on 
installing ownCloud Enterprise edition.

Downgrading Not Supported
-------------------------

Downgrading is not supported and risks corrupting your data! If you want to 
revert to an older ownCloud version, install it from scratch and then restore 
your data from backup. Before doing this, file a support ticket (if you have 
paid support) or ask for help in the ownCloud forums to see if your issue can be 
resolved without downgrading.

BINLOG_FORMAT = STATEMENT
-------------------------

If your ownCloud installation fails and you see this in your ownCloud log::

 An unhandled exception has been thrown: exception ‘PDOException’ with message 
 'SQLSTATE[HY000]: General error: 1665 Cannot execute statement: impossible to 
 write to binary log since BINLOG_FORMAT = STATEMENT and at least one table 
 uses a storage engine limited to row-based logging. InnoDB is limited to 
 row-logging when transaction isolation level is READ COMMITTED or READ 
 UNCOMMITTED.'

See :ref:`db-binlog-label`.

Additional Installation Guides and Notes
----------------------------------------

See :doc:`installation_wizard` for important steps such as choosing the best 
database and setting correct directory permissions.

See :doc:`selinux_configuration` for a suggested configuration for 
SELinux-enabled distributions such as Fedora and CentOS.

If your distribution is not listed, your Linux distribution may maintain its 
own 
ownCloud packages, or you may prefer to install from source code (see 
:doc:`source_installation`).

**Archlinux:** The current `stable version`_ is in the 
official community repository, and more packages are in 
the `Arch User Repository`_.

.. _stable version: https://www.archlinux.org/packages/community/any/owncloud
.. _Arch User Repository: https://aur.archlinux.org/packages/?O=0&K=owncloud

**Mageia:** The `Mageia Wiki`_ has a good page on installing ownCloud from the 
Mageia software repository.

.. _Mageia Wiki: https://wiki.mageia.org/en/OwnCloud

**Running ownCloud in a subdirectory**: If you're running ownCloud in a 
subdirectory and want to use CalDAV or CardDAV clients make sure you have 
configured the correct :ref:`service-discovery-label` URLs.

**Note for MySQL/MariaDB environments**: Please refer to :ref:`db-binlog-label`
on how to correctly configure your environment if you have binary logging enabled.


.. _Open Build Service: 
   https://download.owncloud.org/download/repositories/9.2/owncloud/
   
