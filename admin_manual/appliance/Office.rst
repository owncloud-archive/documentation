Working on Documents in the Appliance
=====================================

If you want to create/edit documents in the appliance you can choose between **Collabora** and **OnlyOffice**.
Here is how you install and configure them in the Appliance.

.. important::

   You have to access ownCloud with the domain name using HTTPS in order for these instructions to work.

How to Install Collabora
------------------------

1. Connect to your appliance via IP or FQDN, e.g., by using 172.16.40.100 or ``my_owncloud_appliance``.
2. Login into the management console, e.g., click on the domain and system settings, type in the Administrator as username and the password which you set.
3. Go to "**Applications/Software**" and then "**Appcenter**".
4. Search for "**Collabora Online Development Edition**" or select it from the application list.
5. Install "**Collabora Online Development Edition**".

Now you can use Collabora within ownCloud.
Start by creating a new Document.

Updating Collabora
~~~~~~~~~~~~~~~~~~

When a new version of is available, just update the app.
You don't have to make any changes or adjustments.

How to Install OnlyOffice
-------------------------

1. Connect to your appliance via IP or FQDN, e.g., 172.16.40.100 or ``my_owncloud_appliance``.
2. Login into the management console, e.g., click on the domain and system settings, type in the Administrator as username and the password you set.
3. Go to "**Applications/Software**" and then "**Appcenter**".
4. Search for "**OnlyOffice**" or select it from the application list.
5. Install OnlyOffice.
6. Go to ``ownCloud -> Market -> Tools -> Install OnlyOffice``.
7. Go to ``Settings -> General``.
8. Enter the OnlyOffice server address in the following format:

::

  https://<your-domain-name/onlyoffice-documentserver/

9. Click on save to save your settings.
10. Now you can create a new document by clicking on the **Plus** button.
