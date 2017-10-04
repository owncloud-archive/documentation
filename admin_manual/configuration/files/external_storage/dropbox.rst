=======
Dropbox
=======

To connect Dropbox to your ownCloud installation requires four steps to be completed. 

1. :ref:`Install the "External Storage: Dropbox" app from the ownCloud Marketplace <dropbox_install_step_one_label>`
2. :ref:`Create a Dropbox app <dropbox_install_step_two_label>`
3. :ref:`Create a Dropbox storage share <dropbox_install_step_three_label>`
4. :ref:`Use the Dropbox share <dropbox_install_step_four_label>`

.. _dropbox_install_step_one_label:

Step One - Install the "External Storage: Dropbox" app from the ownCloud Marketplace
------------------------------------------------------------------------------------

To install the `External Storage: Dropbox <https://marketplace.owncloud.com/apps/files_external_dropbox>_` app, from the ownCloud UI click "Market" from the main drop-down menu.
Then, locate the app in the "Storage" category.
Like any other application in the Marketplace, click "INSTALL" to begin the installation process.
Assuming that the process completes successfully, the "INSTALL" button changes to read "UNINSTALL".

.. _dropbox_install_step_two_label:

Step Two - Create a Dropbox app 
--------------------------------

Next, you need to create a Dropbox app. 
To do that, `open the new app creation form <https://www.dropbox.com/developers/apps/create>`_, where you see three questions:

1. Choose an API
2. Choose the type of access you need
3. Name your app

Under "Choose an API", choose the first option, titled "Dropbox API".
Then, under "Choose the type of access you need", choose the first preference: "App folder - Access to a single folder created specifically for your app."
For "Name your app", in the field marked "App name", give your app a meaningful, but short, name.

With all of the required details filled out, click the blue "Create app" button, in the bottom, right-hand corner.
After you do that, the settings page for the application loads. 

.. image:: ../../../images/configuration/files/external_storage/dropbox/app-configuration.png
   :alt: Dropbox app configuration settings

From that page, you need to add the hostname of your ownCloud installation as an OAuth2 redirect URI. 

.. _dropbox_install_step_three_label:

Step Three - Create a Dropbox Share
-----------------------------------
  
To create a Dropbox share, under "admin -> Settings -> Admin -> Storage", check the "Enable external storage" checkbox, if it's not already checked.
Then, in the dropdown list under "External storage", click the first "Dropbox" option. 

.. NEXT RELEASE TODO - remove the following note in the 10.0.4 release, if the internal Dropbox functionality is deprecated

.. note:: 
   There are two Dropbox options in the dropdown list, as Dropbox functionality is currently part of ownCloud's core. 
   However, the internal Dropbox functionality should be removed in ownCloud 10.0.4.

Then, you need to provide a name for the folder in the "Folder name" field, and a "client key" and "client secret", located in the "Configuration" column. 
The client key and client secret values are the "App key" and "App secret" fields which you saw earlier in your Dropbox app's configuration settings page.

After you have added these three settings, click "Grant access".
ownCloud then interacts with Dropbox's API to set up the new shared folder.
If the process is successful, a green circle icon appears, at the far left-hand side of the row, next to the folder's name.

.. image:: ../../../images/configuration/files/external_storage/dropbox/successful-connection-to-dropbox.png
   :alt: A Dropbox share successfully created.

Other Options
^^^^^^^^^^^^^

If you want to restrict access to the share to a select list of users and groups, you can add them to the field in the "Available for" column. 

.. _dropbox_install_step_four_label:

Step Four - Using the Dropbox Share
-----------------------------------

After a Dropbox-backed share is created, a new folder is available under "All Files". 
It has the name that you gave it when you created the share, and it is represented by an external share folder icon, as in the image below.

.. image:: ../../../images/configuration/files/external_storage/dropbox/successful-connection-to-dropbox.png
   :alt: A Dropbox share successfully created.
   
This links to a new folder in your Dropbox account, under "Dropbox > Apps", with the name of the Dropbox app that you created.    

.. image:: ../../../images/configuration/files/external_storage/dropbox/dropbox-share-available.png
   :alt: A new Dropbox share is available.
   
Now, if you add files and folders in either the new Dropbox folder or the new ownCloud folder, after being synced, they will be visible inside the other.

.. image:: ../../../images/configuration/files/external_storage/dropbox/dropbox-apps-folders.png
   :alt: The Dropbox Apps folders.

