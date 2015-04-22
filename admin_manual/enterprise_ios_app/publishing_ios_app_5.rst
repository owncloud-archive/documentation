============================
Create Provisioning Profiles
============================

The next phase is to create three provisioning profiles. These are the profiles 
that you will email to branding@owncloud.com after building your branded app 
with the ownBrander app on `<https://customer.owncloud.com>`_. 
Go to **Provisioning Profiles > All**, then click the plus button (top right) 
to open the *Add iOS Provisioning Profile* screen. Select **Ad Hoc** and click 
**Continue**.

.. figure:: ../images/cert-35.png
   :scale: 70%
   
   *click to enlarge*
   
On the **Select App ID** screen select your first App ID that you created and 
click **Continue**. (You should have created three App IDs, and the first one 
has the shortest name.)

.. figure:: ../images/cert-36.png
   :scale: 70%
   
   *click to enlarge*

Select the certificate that you created at the beginning and click **Continue**.

.. figure:: ../images/cert-38.png
   :scale: 70%
   
   *click to enlarge*

   
   
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


QUESTIONS    

1. Can the customer test their ad hoc app on iOS simulators?
2. How do they find UDIDs?
3. How do they get to a production release?
4. How do they use Xcode to upload to the Apple Store?
5. How do they manage upgrades?

https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/
AppDistributionGuide/Introduction/Introduction.html