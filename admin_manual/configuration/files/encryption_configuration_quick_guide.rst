====================================
Encryption Configuration Quick Guide
====================================

Encryption Types
----------------

ownCloud provides two encryption types:

- **Master Key:** there is only one key (or key pair) and all files are encrypted using that key pair. This is **highly recommended** for **new** instances to avoid **restrictions** in functionality of user key encryption.

- **User-specific Key:** every user has their own private/public key pairs; the private key is protected by the user's password. This **will be removed in future a release**.

Master Key
~~~~~~~~~~

- The **recommended** type of encryption.
- Best to activate on new instances with no data.
- If you have existing data, use **encrypt all** command. Depending on the amount of existing data, this operation can take a long time.

Activation
^^^^^^^^^^

::

	occ maintenance:singleuser --on
	occ app:enable encryption
	occ encryption:enable
	occ encryption:select-encryption-type masterkey -y
	occ encryption:encrypt-all
	occ maintenance:singleuser --off

Status
^^^^^^

::

	occ encryption:status

Decryption
^^^^^^^^^^

Depending on the amount of existing data, this operation can take a long time.
::

	occ maintenance:singleuser --on
 	occ encryption:decrypt-all
 	occ maintenance:singleuser --off

Deactivation
^^^^^^^^^^^^

::

	occ encryption:disable
	# ignore the "already disabled" message
	occ app:disable encryption

If the master key has been compromised or exposed, you can recreate it.
You will need the current master key for it.

::

	occ encryption:recreate-master-key


User-Specific Key
~~~~~~~~~~~~~~~~~

Activation
^^^^^^^^^^

::

	occ maintenance:singleuser --on
	occ app:enable encryption
	occ encryption:enable
	occ encryption:select-encryption-type user-keys
	occ encryption:encrypt-all
	occ maintenance:singleuser --off


After User-specific encryption is enabled, users must log out and log back in to trigger the automatic personal encryption key generation process.

Recovery Key
^^^^^^^^^^^^

- Go to the "_Encryption_" section of your Admin page.
- Set a recovery key password.
- Ask the users to opt-in to the recovery key.

If a user decides not to opt-in to the recovery key and forgets or loses their password, **the user's data cannot be decrypted**.
This leads to **permanent data loss**.

They need to:

- Go to the "**Personal**" page
- Enable the Recovery Key

Status
^^^^^^

::

	occ encryption:status

Decrypt
^^^^^^^

::

 	occ maintenance:singleuser --on
 	occ encryption:decrypt-all
 	#enter **Recovery Key** for **each user**
 	# Recovery Key is a password set by the admin
 	occ maintenance:singleuser --off

Deactivation
^^^^^^^^^^^^

::

	occ encryption:disable
	# ignore the "already disabled" message
	occ app:disable encryption
