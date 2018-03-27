===================================
How to Upgrade Your ownCloud Server
===================================

We recommend that you keep your ownCloud server up to date.
When an update is available for your ownCloud server, you will see a notification at the top of your ownCloud Web interface.
When you click the notification, it will bring you here.

Before beginning an upgrade, please keep the following points in mind:

- Review :doc:`the release notes </release_notes>` for important information about the needed migration steps during that upgrade to help ensure a smooth upgrade process.
- Skipping major releases is not supported. However *you can* migrate from 9.0.9 straight to 10.0.
- Downgrading is not supported.
- Upgrading is disruptive, as your ownCloud server will be put into :ref:`maintenance mode <maintenance_mode_label>`.
- Large installations may take several hours to complete the upgrade.
- Downgrading **is not supported** as it risks corrupting your data. If you want to revert to an older ownCloud version, make a new, fresh installation and then restore your data from backup. Before doing this, file a support ticket (if you have paid support) or ask for help in the ownCloud forums to resolve your issue without downgrading.

Prerequisites
-------------

We strongly recommend that you always maintain :doc:`regular backups <backup>` as well as make a fresh backup before every upgrade.
We also recommend that you review any installed third-party apps for compatibility with the new ownCloud release.
Ensure that they are all disabled before beginning the upgrade.
After the upgrade is complete re-enable any which are compatible with the new release.

.. warning::
   Install unsupported apps at your own risk.

.. _owncloud.org/install/: https://owncloud.org/install/

Upgrade Options
---------------

There are three ways to upgrade your ownCloud server:

#. **(Recommended)** Perform a :doc:`manual upgrade <manual_upgrade>`, using `the latest ownCloud release <owncloud.org/install/>`_.
#. Use your distribution's :doc:`package manager <package_upgrade>`, in conjunction with our official ownCloud repositories. **Note:** This approach should not be used unattended nor in clustered setups.
#. Use the :doc:`Updater App <update>`. This is needed in scenarios where the admin does not have access to the command line. It is recommended for shared hosting environments and for users who want an easy way to track different release channels.

.. note::
   Enterprise customers will use their Enterprise software repositories to maintain their ownCloud servers, rather than the Open Build Service. Please see :doc:`../enterprise/installation/install` for more information.

.. Links

.. _Alias: https://httpd.apache.org/docs/current/mod/mod_alias.html#alias
.. _DocumentRoot: https://httpd.apache.org/docs/current/mod/core.html#documentroot
.. _VirtualHost: https://httpd.apache.org/docs/current/mod/core.html#virtualhost
