=============================
Preferred Installation Method
=============================

For production environments, we recommend the installation from the tar archive. 
This applies in particular to scenarios, where the web server, storage and database are on separate machines. 

In this constellation, all dependencies and requirements are managed by your operating system's package manager, while the ownCloud code itself is maintained in a sequence of simple steps as documented in our instructions for the :doc:`Manual Installation on Linux <source_installation>` and the :doc:`Manual ownCloud Upgrade <../maintenance/manual_upgrade>`.
The package installation is for single-server setups only.

Repositories
------------

You may use either of the following repositories for ownCloud 10.0:

* `<https://download.owncloud.org/download/repositories/stable/owncloud/>`_
* `<https://download.owncloud.org/download/repositories/10.0/owncloud/>`_

When you use the Stable repo, you never have to change it as it always tracks 
the current stable ownCloud version through all major releases: 9.0, 9.1 
and so on. (Major releases are indicated by the second number, so 8.0, 8.1, 
8.2, 9.0, and 9.1 were all major releases.)

If you wish to track a specific major release, such as 9.1 or 10.0, then use 
that repo. That way you won't accidentally find yourself looking at an upgrade 
to the next major release before you're ready.

Installing ownCloud Enterprise Edition
--------------------------------------

See :doc:`../enterprise/installation/install` for instructions on 
installing ownCloud Enterprise edition.

Downgrading
-----------

Downgrading is not supported and risks corrupting your data! If you want to 
revert to an older ownCloud version, install it from scratch and then restore 
your data from backup. Before doing this, file a support ticket (if you have 
paid support) or ask for help in the ownCloud forums to see if your issue can be 
resolved without downgrading.

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
   https://download.owncloud.org/download/repositories/10.0/owncloud/
   
