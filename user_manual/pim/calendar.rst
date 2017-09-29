======================
Using the Calendar App
======================

The Calendar application is not officially supported and is not enabled by default, in ownCloud |version|. 
If you attempt to enable it, you will see the following error:

.. figure:: ../images/calendar/calendar-app-signature-could-not-get-checked-error.png
   :alt: Error message when attempting to enable the default calendar application.

To enable it, you first need to enable the Marketplace.
To do so, add the following line to ``config/config.php``. 
This setting connects your ownCloud instance with `the ownCloud Marketplace`_.

:: 

  'appstoreurl' => 'https://marketplace.owncloud.com/api/v0',

After saving the changes, reload the ownCloud UI and enable the Calendar application.

.. note:: 
   In case you are sitting behind a firewall and cannot reach the marketplace (or if you prefer to install applications manually) you can install the Calendar app by:
  - Downloading the package from the Marketplace
  - Unpacking the tarball into the ``apps`` folder 
  - Enable the Calendar app, available under disabled apps.

.. note::
   Please also check that you disable and uninstall existing apps from the old app store **before** you installing and enabling the newer versions from the marketplace. If you do not, attempting to uninstall them displays the "*app directory already exists*" error message.
   
.. Links
      
.. _the ownCloud Marketplace: https://marketplace.owncloud.com/
