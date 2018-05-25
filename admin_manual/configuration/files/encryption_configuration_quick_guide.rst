====================================
Encryption Configuration Quick Guide
====================================
 
Encryption Types
----------------

ownCloud provides two encryption types:

- **User specific Key:** every user has their own private/public key pairs, and the private key is protected by the user's password.

- **Master Key:** there is only one key (or key pair) and all files are encrypted using that key pair.
  
How To Enable Encryption
------------------------

It's your choice what type of encryption you want to use.

How to enable **Master Key** encryption:

::

  occ app:enable encryption
  occ encryption:enable
  occ encryption:select-encryption-type masterkey
  occ encryption:encrypt-all

How to enable **User specific Key** encryption:

::

  occ app:enable encryption
  occ encryption:enable
  occ encryption:select-encryption-type user-keys
  occ encryption:encrypt-all 


After encryption is enabled, your users must also log out and log back in to trigger the automatic personal encryption key genaration process. 

How To Enable Users File **Recovery Keys**
------------------------------------------

Go to the Encryption section of your Admin page and set a recovery key password. This is important for the case that a user forgets his password. Without the recovery key all of the users data would be lost at that point.

You then need to ask your users to opt-in to the Recovery Key. If a user decides not to opt-in or forgets about it his data would be lost if he ever forgets his password.

They need to

- go to the "**Personal**" page 
- enable the recovery key
 
View Current Encryption **Status**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Get the current encryption status and the loaded encryption module::

 occ encryption:status 

**Decrypt** Files For All Users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
How to decrypt **Master Key** encryption::

 occ maintenance:singleuser --on
 occ encryption:decrypt-all
 occ maintenance:singleuser --off

How to enable **User specific Key** encryption::

 occ maintenance:singleuser --on
 occ encryption:decrypt-all
 #enter **Recovery Key** for **each user**
 occ maintenance:singleuser --off

Disabling Encryption
--------------------

When you decrypted all the files, encryption will be turned off.
