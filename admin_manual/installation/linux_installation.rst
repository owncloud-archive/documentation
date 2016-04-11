===================================
Preferred Linux Installation Method
===================================

Changes in 9.0
--------------

Linux distribution packages (from `Open 
Build Service`_) have been divided into two packages for ownCloud 
9, ``owncloud-deps`` and ``owncloud-files``. The ``owncloud-files`` package 
installs only ownCloud, with no Apache, database, or PHP dependencies. To 
install a complete system, including dependencies (Apache, PHP) install the 
metapackage ``owncloud``. Install your desired database separately, before you 
install ownCloud.

Split packages are available for the following Linux distributions:

* CentOS 7                      
* Debian 8 
* RHEL 7 
* SLES 12 
* Ubuntu 14.04, 15.10
* openSUSE 13.2, Leap 42.1

``owncloud-files`` is available for the following distributions. You will 
have to install your own LAMP stack first. This allows you to create your own custom LAMP
stack without dependency conflicts with the ownCloud package. Browse 
`<http://download.owncloud.org/download/repositories/9.0/owncloud/>`_ to 
find the ``owncloud-files`` package for your distro:

* CentOS 6, 7
* Debian 7
* RHEL 6
* SLES 12
* Ubuntu 12.04, 14.10

Repositories for Fedora, openSUSE Tumbleweed and Ubuntu 15.04 were dropped. If you use
Fedora, the CentOS 7 packages will most likely work (the owncloud-files one at least).
openSUSE users similarly can rely on LEAP packages for Tumbleweed and Ubuntu 15.04 users
can use 15.10 ones.

Follow the instructions on the download page to install ownCloud. Then run the 
Installation Wizard to complete your installation. (see 
:doc:`installation_wizard`).

.. warning:: Do not move the folders provided by these packages after the 
   installation, as this will break updates.

See the :doc:`system_requirements` for the recommended ownCloud setup and 
supported platforms.

Repos: Stable or Version?
-------------------------

You may use either of the following repositories for ownCloud 9:

* `<https://download.owncloud.org/download/repositories/stable/owncloud/>`_
* `<https://download.owncloud.org/download/repositories/9.0/owncloud/>`_

When you use the Stable repo, you never have to change it as it always tracks 
the current stable ownCloud version through all major releases: 8.2, 9.0, 
and so on. (Major releases are indicated by the second number, so 8.0, 8.1, 
8.2, and 9.0 were all major releases.)

If you wish to track a specific major release, such as 8.2 or 9.0, then use 
that repo. That way you won't accidentally find yourself looking at an upgrade 
to the next major release before you're ready.

Installing ownCloud Enterprise Subscription
-------------------------------------------

See :doc:`../enterprise_installation/linux_installation` for instructions on 
installing ownCloud Enterprise Subscription.

Downgrading Not Supported
-------------------------

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

**Debian/Ubuntu:** The package installs an additional Apache config file to 
``/etc/apache2/conf-available/owncloud.conf`` which contains an ``Alias`` to the 
owncloud installation directory as well as some more needed configuration 
options.

.. _here is a guide: https://www.techandme.se/virtualhost-443/

**Installation notes for ownCloud 9 + PHP 7:**
If you are planning to install ownCloud together with PHP 7 you have to install the ownCloud files separately and do the rest of the configuration yourself. So instead of using ``apt-get install owncloud`` you use ``apt-get install owncloud-files``.
The manual installation consists of making the Apache config, it's not that hard, and `here is a guide`_

**Running ownCloud in a subdir**: If you're running ownCloud in a subdir and
want to use CalDAV or CardDAV clients make sure you have configured the correct 
:ref:`service-discovery-label` URLs.

**Note for MySQL/MariaDB environments**: Please refer to :ref:`db-binlog-label`
on how to correctly configure your environment if you have binary logging enabled.


.. _Open Build Service: 
   https://download.owncloud.org/download/repositories/9.0/owncloud/
   
