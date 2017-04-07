==================================================
Installing & Upgrading ownCloud Enterprise Edition
==================================================

The recommended method for installing and maintaining your ownCloud Enterprise edition is with your Linux package manager. 
Configure your package manager to use the ownCloud Enterprise repository, import the signing key, and then install and update ownCloud packages like any other software package. 

Please refer to the ``README - ownCloud Package Installation.txt`` document in your account at `Customer.owncloud.com 
<https://customer.owncloud.com/owncloud/>`_ account for instructions on setting up your Linux package manager.

After you have completed your initial installation of ownCloud as detailed in the README, follow the instructions in :doc:`../../installation/installation_wizard` to finish setting up ownCloud.

To upgrade your Enterprise server, refer to :doc:`../../maintenance/upgrade`.

Manual Installation
-------------------

Download the ownCloud archive from your account at https://customer.owncloud.com/owncloud, then follow the instructions at :doc:`../../installation/source_installation`.

SELinux
~~~~~~~

Linux distributions that use SELinux need to take some extra steps so that 
ownCloud will operate correctly under SELinux. Please see 
:doc:`../../installation/selinux_configuration` for some recommended configurations.

License Keys
------------

Introduction
~~~~~~~~~~~~

You'll need to install a license key to use ownCloud Enterprise Edition. 
There are two types of license keys: one is a free 30-day trial key. 
The other is a full license key for Enterprise customers.

You can `download and try ownCloud Enterprise for 30 days for free 
<https://owncloud.com/download/>`_, which auto-generates a free 30-day key. 
When this key expires your ownCloud installation is not removed, so when you become an Enterprise customer you can enter your new key to regain access. 
See `How to Buy ownCloud <https://owncloud.com/how-to-buy-owncloud/>`_ for sales and contact information.

Configuration
~~~~~~~~~~~~~

Once you get your Enterprise license key, it needs to be copied to your ownCloud configuration file, ``config/config.php`` file like this example::

  'license-key' => 'test-20150101-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-YYYYYY’,

Each running instance of ownCloud requires a license key. 
Keys will work across upgrades without issue, so new keys will not be required when you upgrade your ownCloud Enterprise to a new version.

Supported ownCloud Enterprise Edition Apps
------------------------------------------

See :doc:`../../installation/apps_supported` for a list of supported apps.

.. note:: 3rd party and unsupported apps must be disabled before performing a 
   system upgrade. Then install the upgraded versions, and after the 
   upgrade is complete re-enable them.

