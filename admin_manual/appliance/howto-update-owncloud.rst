======================
How to Update ownCloud 
======================

There are three options to update an ownCloud installation hosted on an ownCloud X Appliance:

- `Use the Univention Management Console`_
- `Use the Command Line`_
- `Use the Web UI`_

Use the Univention Management Console
-------------------------------------

After logging in to the Univention server, under "**Administration**", click the first option labeled "**System and domain settings**".
This takes you to the Univention Management Console.
From there, click the "**Software**" shortcut (1), and then click "**Software update**" (2).

.. image:: ../images/appliance/ucs/upgrade-owncloud/univention-management-console-software-update-highlighted.png   

This will load the Software update management panel, after a short time scanning for available updates.
If an update is available, under "**App Center updates**" you will see "**There are App Center updates available**".
If one is, as in the image below, click "**ownCloud**" which takes you to the ownCloud application. 

.. image:: ../images/appliance/ucs/upgrade-owncloud/univention-software-update-dashboard.png

When there, part-way down the page you’ll see the "**Manage local installation**" section. 
Under there, click "**UPGRADE**".

.. image:: ../images/appliance/ucs/upgrade-owncloud/owncloud-app-ready-for-update.png   

Before the upgrade starts, a prompt appears titled "**App Installation notes**". 
This is nothing to be concerned about. 
So check the checkbox "**Do not show this message again**".
Then click "**CONTINUE**".

.. image:: ../images/appliance/ucs/upgrade-owncloud/owncloud-update-app-installation-notes.png

Next an upgrade confirmation page appears.
To accept the confirmation, click "**UPGRADE**" on the far right-hand side of the confirmation page.

.. image:: ../images/appliance/ucs/upgrade-owncloud/confirm-owncloud-upgrade.png

This launches the upgrade process, which requires no manual intervention.
When the upgrade completes, the ownCloud app page will be visible again, but without the "**UPGRADE**" button.
Now, login to ownCloud by clicking the "**OPEN**" button, on the far right-hand side of the page.

Use the Command Line
--------------------

For upgrade via the web interface see below.
This is a documentation on how to upgrade the ownCloud App from 9.1.4 to 10.0.3 in UCS
First you will need to login to your UCS (Univention Corporate Server) instance, either via ssh or directly on your server.
You will need the credentials of the administrator account you have created during the UCS setup.
This are the Commands you will need:

::

  univention-app remove owncloud82
  univention-app install owncloud

To remove the old App and install the new one. 
Your data and users will remain.

Optional commands

::

  # When your Time is out of sync
  # When you get errors on the update command
  timedatectl set-ntp true 

  # When you change the scripts
  univention-app update

Use the Web UI
--------------

Go to the System and Domain Settings

Enter the Administrator Password

Go to your installed ownCloud App

De-install the ownCloud app 9.1

Confirm and wait until the process is finished

Click on "Close" in the upper right corner

Go to Software - Appcenter

Find the app "ownCloud"

Install the app "ownCloud"

Accept the License Agreement

Confirm the Installation

Read the Installations-Hints

Wait until the installation is done. Now you should have the latest version of the ownCloud App

