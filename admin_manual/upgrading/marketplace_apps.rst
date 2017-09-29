================================
Upgrade Marketplace Applications
================================

To upgrade Marketplace applications, please refer to the documentation below, as applicable for your ownCloud setup.

Single-Server Environment
-------------------------

To upgrade Marketplace applications when running ownCloud in a single server environment, you can use use the :ref:`Market app <apps_commands_label>`, specifically by running ``market:upgrade``.
This will install new versions of your installed apps if updates are available in the marketplace.

.. note::
   The user running the update command, which will likely be your webserver user, needs write permission for the ``/apps`` folder. 
   If they don’t have write permission, the command may report that the update was successful, however it may silently fail.

Clustered/Multi-Server Environment
----------------------------------

The :ref:`Market app <market_commands_label>`, both the UI and command line, are not, *currently*, designed to operate on clustered installations.
Given that, you will have to update the applications on each server in the cluster individually. 
There are several ways to do this.
But here is a concise approach:

#. Download the latest server release (whether `the tarball`_ or `the zip archive`_).
#. Download your installed apps from `the ownCloud marketplace`.
#. Combine them together into one installation source, such as *a Docker or VM image*, or *an Ansible script*, etc.
#. Apply the combined upgrade across all the cluster nodes in your ownCloud setup.

.. Links
   
.. _the tarball: https://download.owncloud.org/community/owncloud-10.0.2.tar.bz2
.. _the zip archive: https://download.owncloud.org/community/owncloud-10.0.2.zip
.. _the ownCloud marketplace: https://marketplace.owncloud.com/
