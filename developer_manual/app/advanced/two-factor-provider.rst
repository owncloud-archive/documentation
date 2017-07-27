====================
Two-Factor Providers
====================

.. sectionauthor:: Christoph Wurst <christoph@owncloud.com>

Two-factor authentication providers apps are used to plug custom second factors into the ownCloud core. 
The following code was taken from the `two-factor test app`_.

.. _`two-factor test app`: https://github.com/ChristophWurst/twofactor_test

Implementing a Two-Factor Authentication Provider
-------------------------------------------------

Two-factor authentication providers must implement the ``OCP\Authentication\TwoFactorAuth\IProvider`` interface. 
The example below shows a minimalist example of such a provider.

.. code-block:: php

   <?php

   namespace OCA\TwoFactor_Test\Provider;

   use OCP\Authentication\TwoFactorAuth\IProvider;
   use OCP\IUser;
   use OCP\Template;

   class TwoFactorTestProvider implements IProvider {

       /**
        * Get unique identifier of this 2FA provider
        *
        * @return string
        */
       public function getId() {
           return 'test';
       }

       /**
        * Get the display name for selecting the 2FA provider
        *
        * @return string
        */
       public function getDisplayName() {
           return 'Test';
       }

       /**
        * Get the description for selecting the 2FA provider
        *
        * @return string
        */
       public function getDescription() {
           return 'Use a test provider';
       }

       /**
        * Get the template for rending the 2FA provider view
        *
        * @param IUser $user
        * @return Template
        */
       public function getTemplate(IUser $user) {
           // If necessary, this is also the place where you might want
           // to send out a code via e-mail or SMS.

           // 'challenge' is the name of the template
           return new Template('twofactor_test', 'challenge');
       }

       /**
        * Verify the given challenge
        *
        * @param IUser $user
        * @param string $challenge
        */
       public function verifyChallenge(IUser $user, $challenge) {
           if ($challenge === 'passme') {
               return true;
           }
           return false;
       }

       /**
        * Decides whether 2FA is enabled for the given user
        *
        * @param IUser $user
        * @return boolean
        */
       public function isTwoFactorAuthEnabledForUser(IUser $user) {
           // 2FA is enforced for all users
           return true;
       }

   }

Registering a Two-Factor Authentication Provider
------------------------------------------------

You need to inform the ownCloud core that the app provides two-factor authentication functionality. 
Two-factor providers are registered via ``info.xml``.

.. code-block:: xml

 <two-factor-providers>
     <provider>OCA\TwoFactor_Test\Provider\TwoFactorTestProvider</provider>
 </two-factor-providers>
