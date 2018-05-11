============
Google Drive
============

ownCloud uses OAuth 2.0 to connect to Google Drive. This requires configuration
through Google to get an app ID and app secret, as ownCloud registers itself
as an app.

All applications that access a Google API must be registered through the 
`Google Cloud Console <https://console.developers.google.com/>`_. Follow along carefully 
because the Google interface is a bit of a maze and it's easy to get lost. 

If you already have a Google account, such as Groups, Drive, or Mail, you can 
use your existing login to log into the Google Cloud Console. After logging in 
click  the **Create Project** button.

.. figure:: images/google_drive/001.png
   :alt: Google Cloud Console

.. figure:: images/google_drive/002.png
   :alt: Create Project


Give your project a name, and either accept the default **Project ID** or 
create your own, then click the **Create** button. For this example a random name was chosen, "owncloud-04-27". However, feel free to choose your own name.

.. figure:: images/google_drive/003.png
   :alt: Choose a name

After your project is created, click on the notifications bell and select your project.

.. figure:: images/google_drive/004.png
   :alt: Notification bell

Go to Api overview to select google's API.

.. figure:: images/google_drive/005.png
   :alt: API

.. figure:: images/google_drive/006.png
   :alt: Google API

.. figure:: images/google_drive/007.png
   :alt: Enable

Now you must create your credentials.

.. figure:: images/google_drive/008.png
   :alt: Create Credentials

First, select "Web Browser" and "User data".

.. figure:: images/google_drive/009.png
   :alt: Access type and Data

The next screen that opens is **Create OAuth 2.0 Client ID**. Enter your app name. 

.. figure:: images/google_drive/010.png
   :alt: Access type and Data

**Authorized JavaScript Origins** is your root domain, 
for example ``https://example.com``, without a trailing slash. 
Examples::

  https://example.com
  http://example.com
  IP/owncloud  

You need to configure **Authorized Redirect URIs**, and they must be in this form::

  https://example.com/owncloud/index.php/settings/admin?sectionid=storage
  https://example.com/owncloud/index.php/settings/personal?sectionid=storage

If you are configuring storage as an Administrator - choose the admin URI, if you are a user and configuring a storage
- pick the personal URI.

If you are not sure what your exact URIs are - here is a quick guide to figure it out.

**Authorized JavaScript Origins**

This is just the address you access your ownCloud server at, where you see the login screen.

.. figure:: images/google_drive/011.png
   :alt: text

**Authorized Redirect URIs**

If you have not already enabled the Google Drive storage, here is how you do it:

.. figure:: images/google_drive/011.png
   :alt: Login in ownCloud

.. figure:: images/google_drive/012.png
   :alt: Go to Storage in the Settings

.. figure:: images/google_drive/013.png
   :alt: Enable external Storage

.. figure:: images/google_drive/014.png
   :alt: Select Google Drive from dropdown menu

.. figure:: images/google_drive/015.png
   :alt: Now you have your Google Drive App enabled

.. figure:: images/google_drive/016.png
   :alt: The URL from this page is the one you have to enter in the **Authorized Redirect URIs**

Here is the correct result:

.. figure:: images/google_drive/017.png
   :alt: Client ID

Now we have to create a consent screen. This is the information in the screen Google shows you when you connect your new Google app to ownCloud the first time.

.. figure:: images/google_drive/018.png
   :alt: Choose a Project Name

Now you can download the credentials as a JSON file.

.. figure:: images/google_drive/019.png
   :alt: Download your Credentials

You can see either open this file with the editor of your choice (SublimeText for example), or you can put in in your web browser. This is when you do the later:   

.. figure:: images/google_drive/020.png
   :alt: Credentials

Enter the Client ID and Client Secret in the app and press **Grant Access**.

Now you have everything you need to mount your Google Drive in ownCloud. 

Your consent page appears when ownCloud makes a successful connection. 

Click **Allow**.

.. figure:: images/google_drive/021.png
   :alt: Grant Access

When you see the green light confirming a successful connection
you're finished.

.. figure:: images/google_drive/022.png
   :alt: All Green

.. figure:: images/google_drive/023.png
   :alt: Your Google Drive Folder

See :doc:`../external_storage_configuration_gui` for additional mount 
options and information.

See :doc:`auth_mechanisms` for more information on authentication schemes.
603026686136-qnv9ooocacrkrh1vs0cht83eprgm2sbb.apps.googleusercontent.com
