===================
Impersonating Users
===================

Sometimes you may need to use your ownCloud installation as another user, whether to help users debug an issue or to get a better understanding of what they see when they use their ownCloud account.
The ability to do so is a feature delivered via an ownCloud app called `Impersonate <https://marketplace.owncloud.com/apps/impersonate>`_. 

.. note::
   This functionality is available only to administrators.

Installing the Application
--------------------------

To install it, from the Market in your ownCloud installation, filter down the list of available apps to the **Tools** category, and in the filtered list click on the **Impersonate** app. 

.. image:: ../images/apps/impersonate/impersonate-uninstalled.png 
   :alt: The ownCloud Marketplace Impersonate app.

In the bottom right-hand corner of the Impersonate app’s details click the blue ``Install`` button, and the app will install in your ownCloud installation shortly afterward

.. image:: ../images/apps/impersonate/impersonate-installed.png 
   :alt: The ownCloud Marketplace Impersonate app is installed.

Impersonating a User
--------------------

When installed, you can then impersonate users; in effect, you will be logged in as said user. 
To do so, go to the Users list, where you will now see a new column available called "**Impersonate**", as in the screenshot below.

.. image:: ../images/apps/impersonate/picking-a-user-to-impersonate.png 
   :alt: Picking a user to Impersonate.

Click the gray head icon next to the user that you want to impersonate.
Doing so will log you in as that user, temporarily pausing your current session. 
You will see a notification at the top of the page that confirms you’re now logged in as (or impersonating) that user.

.. image:: ../images/apps/impersonate/impersonating-a-user.png 
   :alt: Impersonating a user.

Anything that you see until you log out will be what that user would see. 

Ending an Impersonation
-----------------------

When you’re ready to stop impersonating the user, log out and you will return to your normal user session.

.. Links
   
.. _Marketplace: https://marketplace.owncloud.com/
