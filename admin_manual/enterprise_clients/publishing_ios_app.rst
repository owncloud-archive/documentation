===================================================
Distributing Your Branded iOS App (Enterprise Only)
===================================================

########## **Please See Questions At the End** ###########

Creating and distributing your branded iOS ownCloud app involves a number of 
interdependent steps. First you must create three provisioning profiles, then 
use ownBrander to create your branded app, and then email your provisioning 
profiles to branding@owncloud.com.

Prerequisites
-------------

* A Mac OS X computer with Xcode (free download) and Keychain Access (Utilities)
* An account on developer.apple.com
* An ownCloud Enterprise Subscription & the ownBrander app on 
  customer.owncloud.com
  
Procedure
---------

1. Create a digital signing infrastructure on developer.apple.com. Apple 
   requires that all iOS apps are digitally signed.

2. Create three provisioning profiles.

3. Create your branded iOS app on
   https://customer.owncloud.com/owncloud/index.php/apps/ownbrander, then email 
   your three provisioning profiles to branding@owncloud.com
   
4. Distribute your new branded app (ad hoc) to testers

5. When it passes testing, upload (production) to the Apple store with Xcode

Register on developer.apple.com
-------------------------------

See https://developer.apple.com/programs/ios/ for detailed information. It 
costs $99 per year.

Create provisioning profiles
----------------------------

1. Create a .certSigningRequest (CSR) file
    * Open Keychain Access from Utilities    
    * From Keychain Access toolbar select Keychain Access -> Preference
    * Open Keychain Access > Certificate Assistant > Request a 
      Certificate From a Certificate Authority
    * Enter email address and common name that you used to register in the iOS 
      Developer Program
    * Keep CA Email blank and select "Saved to disk" and "Let me specify key 
      pair information"
    * Click Continue
    * Choose a filename & destination on your hard drive
    * Click Save
    * In the next window, set "Key Size" value to "2048 bits"
    * Set "Algorithm" to "RSA"
    * Click Continue

This will create and save your certSigningRequest file (CSR) to your hard drive. 
A public and private key will also be created in Keychain Access with the Common 
Name entered.

2. Create ".cer" file in iOS developer account
    * Login to https://developer.apple.com/
    * Go to member center > certificates, identifiers, & profiles
    * iOS Apps > Certificates > + button
    * Production > App Store and Ad Hoc, Continue
    * 'About Creating a Certificate Signing Request (CSR)' Continue
    * Generate your certificate > Choose File > Generate
    * new key is ios_distribution.cer. download and save
    
3. Create App IDs        
    * Identifiers > App IDs, + to create new app ID
    * Name, auto Team ID, bundle ID, Continue, confirm done
    * Identifiers > App Groups, create app group, click done
    * Identifiers > App IDs, edit app, add to App Group
    * "You have successfully updated the App Groups associations with your App 
      ID." 
    * Identifiers > App IDs, create new DocumentProvider BundleID
    * "This App ID is now registered to your account and can be used in your 
      provisioning profiles."
    * Edit DocumentProvider and add to App Group
    * "You have successfully updated the App Groups associations with your App 
      ID"
    * Identifiers > App IDs, create new bundleID.DocumentProviderFileProvider. 
    * Add to App Group

4. Create Provisioning Profiles
    * Provisioning Profiles > +, Ad Hoc, Select App ID from dropdown menu, 
      generate, download
    * Provisioning Profiles > +, Ad Hoc, Select the bundleID.DocumentProvider  
      from dropdown menu, generate, download, click Add Another
    * Provisioning Profiles > +, Ad Hoc, Select the  
      bundleID.DocumentProviderFileProvider from dropdown menu, generate, 
      download
    
5.  Register device UDIDs; you must register all devices that you will test 
    your ad hoc app on   
    
6.  Go to customer.owncloud.com and use the ownBrander app to create your 
    branded iOS ownCloud app. You will need the Application Name, Bundle ID, 
    and App Group from your developer.apple.com account. You will also need 
    several graphical images in specific sizes, which you can see in your 
    ownBrander wizard.
    
7.  When you have created your app, email your three provisioning profiles to 
    branding@owncloud.com. In 24-48 hours your new app will be on your files 
    page on customer.owncloud.com.

##########################
######  QUESTIONS ########
##########################

1. Can the customer test their ad hoc app on iOS simulators?
2. How do they find UDIDs?
3. How do they get to a production release?
4. How do they use Xcode to upload to the Apple Store?
5. How do they manage upgrades?

