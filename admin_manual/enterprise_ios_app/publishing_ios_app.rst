===================================================
Distributing Your Branded iOS App (Enterprise Only)
===================================================

Creating and distributing your branded iOS ownCloud app involves a number of 
interdependent steps. You must create three Bundle IDs, three provisioning 
profiles, create a p12 file, use ownBrander to create your branded app, and 
then email your provisioning profiles and p12 file to branding@owncloud.com. We 
use these to build your app, and then in 24-48 hours your new branded app is in 
your account on `<https://customer.owncloud.com/owncloud>`_.

The process for digitally signing your branded iOS app involves a large number 
of steps, which are detailed in this chapter over several pages. Follow them 
exactly and in order, as Apple has specific requirements which must be met.

Prerequisites
=============

* A Mac OS X computer with Xcode (free download) and Keychain Access 
  (included in Utilities)
* An account on `<https://developer.apple.com>`_
* An ownCloud Enterprise Subscription, with the ownBrander app enabled on 
  `<https://customer.owncloud.com/owncloud>`_
  
Procedure
=========

1. Apple requires that all iOS apps are digitally signed in a specific 
   manner, so start by creating a Certificate Signing Request (CSR) using 
   Keychain Access on your Mac, and the certificate tool on your 
   `<https://developer.apple.com>`_ account. 

2. Create three Bundle IDs, an App Group, three provisioning profiles, and a 
   p12 certificate.

3. Customize your branded iOS app on
   `<https://customer.owncloud.com/owncloud/index.php/apps/ownbrander>`_, then 
   email your three provisioning profiles and p12 file to branding@owncloud.com
   
4. Distribute your new branded app (ad hoc) to testers.

5. When it passes testing, upload (production) to the Apple store with Xcode.

Register on developer.apple.com
===============================

See `<https://developer.apple.com/programs/ios/>`_ for detailed information on 
registering and signing iOS apps. It costs $99 per year.