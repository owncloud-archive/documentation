==================================
Linux Package Manager Installation 
==================================

.. note::
   Package managers should only be used for single-server setups.
   For production environments, we recommend installing from `the tar archive`_.

Available Packages
------------------

The recommended package to use is ``owncloud-files``. 
It only installs ownCloud, and does not install Apache, a database, or any of the required PHP dependencies.

Installing ownCloud Community Edition
-------------------------------------

First, install your own LAMP stack, as doing so allows you to create your own custom LAMP stack without dependency conflicts with the ownCloud package.
Then, `update package manager’s configuration <http://download.owncloud.org/download/repositories/10.0/owncloud/>`_.

Configurations are available for the following Linux distributions:

* Ubuntu 14.04 & 16.04
* Debian 7 & 8
* RHEL 6 & 7
* CentOS 7.2 & 7.3
* SLES 11SP4 & 12SP2
* openSUSE Leap 42.2 & 42.3

.. note::
   Repositories for Fedora, openSUSE Tumbleweed, and Ubuntu 15.04 have been dropped. 
   If you use Fedora, use `the tar archive`_ with your own LAMP stack. 
   openSUSE users can rely on LEAP packages for Tumbleweed.

Once your package manager has been updated, follow the rest of the instructions on the download page to install ownCloud. 
Once ownCloud's installed, run :doc:`the Installation Wizard <installation_wizard>` to complete your installation.

.. note::
   See the :doc:`system_requirements` for the recommended ownCloud setup and supported platforms.

.. warning:: 
   Do not move the folders provided by these packages after the installation, as
   this will break updates.

What is the Correct Version?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Package versions are composed of a major, a minor, and a patch number, such as 9.0, 9.1, 10.0, 10.0.1, and 10.0.2. 
The second number represents a major release, and the third number represents a minor release.

Major Releases
^^^^^^^^^^^^^^

If you want to follow either of the most recent major releases, then substitute ``version`` with either 9.0 or 10.0.

Minor Releases
^^^^^^^^^^^^^^

If you want to follow any of the four most recent patch releases, then substitute ``version`` with one of 10.0.1, 10.0.2, 10.0.3, or 10.0.4.
Following a minor release avoids you accidentally upgrading to the next major release before you're ready.

The Latest Stable Version
^^^^^^^^^^^^^^^^^^^^^^^^^

Alternatively you can use ``stable`` for the latest stable version.
If you do, you never have to change it as it always tracks the current stable ownCloud version through all major releases. 

Installing ownCloud Enterprise Edition
--------------------------------------

See :doc:`../enterprise/installation/install` for instructions on installing ownCloud Enterprise edition.

Downgrading
-----------

Downgrading is not supported and risks corrupting your data! 
If you want to revert to an older ownCloud version, install it from scratch and then restore your data from backup. 
Before doing this, file a support ticket (`if you have paid support`_) or ask for help in the ownCloud forums to see if your issue can be resolved without downgrading.

Additional Guides and Notes
---------------------------

See :doc:`installation_wizard` for important steps, such as choosing the best database and setting correct directory permissions.
See :doc:`selinux_configuration` for a suggested configuration for SELinux-enabled distributions such as Fedora and CentOS.

If your distribution is not listed, your Linux distribution may maintain its own ownCloud packages or you may prefer to :doc:`install from source <source_installation>`.

Archlinux
~~~~~~~~~

The current `stable version`_ is in the official community repository, and more packages are in the `Arch User Repository`_.

Mageia
~~~~~~

The `Mageia Wiki`_ has a good page on installing ownCloud from the Mageia software repository.

Note for MySQL/MariaDB environments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please refer to :ref:`db-binlog-label` on how to correctly configure your environment if you have binary logging enabled.

Running ownCloud in a sub-directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you're running ownCloud in a sub-directory and want to use CalDAV or CardDAV clients, make sure you have configured the correct :ref:`service discovery <service-discovery-label>` URLs.

.. Links

.. _Open Build Service: 
   https://download.owncloud.org/download/repositories/10.0/owncloud/
.. _the tar archive: https://owncloud.org/download/#owncloud-server-tar-ball
.. _stable version: https://www.archlinux.org/packages/community/any/owncloud
.. _Arch User Repository: https://aur.archlinux.org/packages/?O=0&K=owncloud
.. _Mageia Wiki: https://wiki.mageia.org/en/OwnCloud
.. _the semantic versioning rules: https://semver.org/
.. _if you have paid support: https://owncloud.com/pricing/
