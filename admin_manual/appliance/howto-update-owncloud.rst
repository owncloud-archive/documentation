======================
How to Update ownCloud 
======================

There are three options to update an ownCloud installation hosted on an ownCloud X Appliance:

- `Use the Univention Management Console`_
- `Use the Command Line`_
- `Use the Web UI`_

Use the Univention Management Console
-------------------------------------

Using the Univention Management Console, there are two ways to upgrade an
existing ownCloud installation:

- `In-place Upgrade`_
- `Uninstall the Existing Version and Install the New Version`_

In-place Upgrade
~~~~~~~~~~~~~~~~

To perform an in-place upgrade, after logging in to the Univention server, under "**Administration**", click the first option labeled "**System and domain settings**".
This takes you to the Univention Management Console.
From there, click the "**Software**" shortcut (1), and then click "**Software update**" (2).

.. image:: ../images/appliance/ucs/upgrade-owncloud/univention-management-console-software-update-highlighted.png   

This will load the Software update management panel, after a short time scanning for available updates.
If an update is available, under "**App Center updates**" you will see "**There are App Center updates available**".
If one is, as in the image below, click "**ownCloud**" which takes you to the ownCloud application. 

.. image:: ../images/appliance/ucs/upgrade-owncloud/univention-software-update-dashboard.png

When there, part-way down the page you'll see the "**Manage local installation**" section. 
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

Uninstall the Existing Version and Install the New Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open your ownCloud X Appliance and go to the "**System and Domain Settings**" dashboard.
Then, after logging in, click "**Installed Applications**", and then click ownCloud. 

.. image:: ../images/appliance/ucs/upgrade-owncloud/installed-applications-owncloud.png

This takes you to the ownCloud app settings page.
From there, begin uninstalling ownCloud by clicking "**UNINSTALL**" under "**Manage local installations**"

.. image:: ../images/appliance/ucs/upgrade-owncloud/begin-owncloud-uninstall.png

This takes you to an uninstall confirmation page. 
On that page, click UNINSTALL on the lower left-hand side of the page.

.. image:: ../images/appliance/ucs/upgrade-owncloud/confirm-owncloud-uninstall.png

, responding to the required confirmations, until the process is finished.
Then, click on "**Close**" in the upper right corner.

.. note::  
   Your data and users will remain.

.. image:: ../images/appliance/ucs/upgrade-owncloud/app-center-search-for-owncloud.png

Following that, go to "**Software - Appcenter**", and search for "*ownCloud*". 
At the moment, two matching results will be returned.
Pick the one that does not contain a version number.

To confirm the version number, scroll to the bottom of the page, and in the More
information section, look for the version string, next to Installed version, as
in the screenshot below.

.. image:: ../images/appliance/ucs/upgrade-owncloud/owncloud-app-version-confirmation.png

If it is the right version, click "**INSTALL**".
Then the License Agreement is displayed.
If you agree to it, click "**ACCEPT LICENSE**".
This will display an installation confirmation screen.
To confirm the installation, click "**INSTALL**".

.. image:: ../images/appliance/ucs/upgrade-owncloud/owncloud-confirm-install.png

The installation will then be carried out.
When it is finished, you will have the latest version of ownCloud installed.

Use the Command Line
--------------------

.. note::  
   Your data and users will remain.

Upgrading from the command line is also available.
To do so, login to your ownCloud X Appliance, either via ssh or directly on the server. 

Is an Upgrade Available?
~~~~~~~~~~~~~~~~~~~~~~~~

Once logged in, check if there is an upgrade available, by running the ``univention-app list`` command.

The command lists the available versions of ownCloud, along with the installed version.
For example, the example below shows that four versions of ownCloud, and that version ``10.0.1-20170523`` is installed.
The output of the command lists the available versions in ascending order.

::

  root@ucs-9446:~# univention-app list owncloud
  owncloud
    Name: ownCloud
    Versions:
      10.0.1-20170523
        Installed: ucs-9446.setts.intranet
      10.0.1-copy
      10.0.1-testing
      10.0.3-20170918
  
Another way to know if ownCloud is upgradable, is by running the command ``univention-app info``.
This command lists information about the current state of the App Center itself.
However, it also lists the currently installed version of ownCloud, along with if it's upgradable.

::

  root@ucs-9446:~# univention-app info
  UCS: 4.2-1 errata165
  App Center compatibility: 4
  Installed: 4.1/owncloud=10.0.1-20170523
  Upgradable: owncloud
  
Upgrade ownCloud  
~~~~~~~~~~~~~~~~

If an upgrade is available, you need to run the ``univention-app upgrade``, as in the example below. 

::

  univention-app upgrade owncloud
  
This command takes some time to complete, primarily based on the appliance's network connection speed.
However, it should not take more than a few minutes.

Confirm That the Upgrade was Successful
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After the upgrade has completed (if it was successful) as a sanity check, run ``univention-app info``, to confirm the currently installed version of ownCloud.  
As in the example below, you should see that the installed version is now higher than before, and that ownCloud is no longer upgradable.

::

  root@ucs-9446:~# univention-app info
  UCS: 4.2-1 errata165
  App Center compatibility: 4
  Installed: 4.1/owncloud=10.0.3-20170918
  Upgradable: 
  
You can also run ``univention-app list owncloud`` again, as below, to ensure that the latest version has been installed.

:: 

  owncloud
    Name: ownCloud
    Versions:
      10.0.1-20170523
      10.0.1-copy
      10.0.1-testing
      10.0.3-20170918
        Installed: ucs-9446.setts.intranet
        
After the upgrade completes, you can then login to ownCloud just as you usually would.
