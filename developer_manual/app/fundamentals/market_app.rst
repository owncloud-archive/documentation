==========
Market App
==========

Since ownCloud X (10.0.0) every ownCloud instance gets shipped with the market app. 
This app makes it easy to manage your applications out of the box.
To connect your market app with the ownCloud Marketplace: 

- Get you API key under "My Account" 
- Inside the market app go to "Settings" 
- Paste your API key and click on "Save"

You are now able to maintain any app in ``downloads/installations/updates`` from your ownCloud installation directly.

ownCloud Instances in Protected Environments (DMZ)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To use the market app your ownCloud instance must have an internet connection. 
If your instance is running in a protected environment (DMZ or similar) you cannot use the market app. 
You need to upload the apps manually in this case. 
Every app can be downloaded manually from the marketplace.
