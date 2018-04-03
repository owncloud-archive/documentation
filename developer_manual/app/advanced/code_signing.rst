============
Code Signing
============

.. sectionauthor:: Lukas Reschke <lukas@owncloud.com>

ownCloud supports code signing for the core releases, and for ownCloud 
applications. 
Code signing gives our users an additional layer of security by ensuring that nobody other than authorized individuals can push updates.

It also ensures that all upgrades have been executed properly, so that no files are left behind, and all old files are properly replaced. 
In the past, invalid updates were a significant source of errors when updating ownCloud.

FAQ
---

Why Did ownCloud Add Code Signing?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By supporting Code Signing we add another layer of security which ensures that 
nobody, other than authorized individuals, can push updates for applications. 
This ensures proper upgrades.

Do We Lock Down ownCloud?
^^^^^^^^^^^^^^^^^^^^^^^^^

The ownCloud project is open source and always will be. 
We do not want to make it more difficult for our users to run ownCloud. 
Any code signing errors on upgrades will not prevent ownCloud from running, but will display a warning on the Admin page. 
For applications that are not tagged "Official" the code signing process is optional.

Is ownCloud Not Open Source Anymore?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ownCloud project is open source and always will be. 
The code signing process is optional, though highly recommended. 
The code check for the core parts of ownCloud is enabled when the ownCloud release version branch has been set to stable.

For custom distributions of ownCloud it is recommended to change the release version branch in version.php to something else than "stable".

Is Code Signing Mandatory For Apps?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Code signing is optional for all third-party applications. 
Applications with a tag of "Official" on https://marketplace.owncloud.com/ require code signing.

Technical details
-----------------

ownCloud uses a X.509 based approach to handle authentication of code. 
Each ownCloud release contains the certificate of a shipped ownCloud Code Signing Root Authority. 
The private key of this certificate is only accessible to the project leader, who may grant trusted project members with a copy of this private key.

This Root Authority is only used for signing certificate signing requests (CSRs) for additional certificates. 
Certificates issued by the Root Authority must always to be limited to a specific scope, usually the application identifier. 
This enforcement is done using the ``CN`` attribute of the certificate.

Code signing is then done by creating a  ``signature.json`` file with the following content:

.. literalinclude:: examples/signature.json
   :language: json

**hashes**: This is an array of all files in the folder with their corresponding SHA-512 hashes.

**certificate**: This is the certificate used for signing.

- It has to be issued by the ownCloud Root Authority
- Its CN needs to be permitted to perform the required action. 

**signature**: This is a signature of the hashes which can be verified using the certificate.
Having the certificate bundled within the ``signature.json`` file has the advantage that even if a developer loses their certificate, future updates can still be ensured by having a new certificate issued.

How Code Signing Affects Apps in the ownCloud Marketplace
---------------------------------------------------------

- Unsigned apps can't be uploaded to the marketplace. They can be installed manually, but the warning: ``"Integrity check failed"``, will always be visible.
- Apps which have been signed in a previous release **MUST** be code-signed in all future releases as well, otherwise the update will be refused.

How to Get Your App Signed
--------------------------

The following commands require that you have OpenSSL installed on your machine. 
Ensure that you keep all generated files to sign your application. 
The following examples will assume that you are trying to sign an application named **"contacts"**.

Firstly, generate a private key and CSR.
This can be done with the following command.

::

  # Replace "contacts" with your application identifier.
  ``openssl req -nodes -newkey rsa:4096 -keyout contacts.key -out contacts.csr -subj "/CN=contacts"``

Then, post the CSR on https://github.com/owncloud/appstore-issues, and configure your GitHub account to show your mail address in your profile. 
ownCloud might ask you for further information to verify that you're the legitimate owner of the application. 
Make sure to keep the private key file (``contacts.key``) secret and not disclose it to any third-parties.
   
ownCloud will then provide you with the signed certificate.

Finally, run ``./occ integrity:sign-app`` to sign your application, and specify your private and the public key as well as the path to the application. 
A valid example looks like: 

:: 

  ./occ integrity:sign-app --privateKey=/Users/lukasreschke/contacts.key --certificate=/Users/lukasreschke/CA/contacts.crt --path=/Users/lukasreschke/Programming/contacts``

The occ tool will store a ``signature.json`` file within the ``appinfo`` folder of your application. 
Then compress the application folder, naming it ``contacts.tar.gz``, and upload it to https://marketplace.owncloud.com/. 
Be aware that making any changes to the application, after it has been signed, requires it to be signed again. 
So if you do not want to have some files shipped remove them before running the signing command.

In case you lose your certificate please submit a new CSR as described above and mention that you have lost the previous one. 
ownCloud will revoke the old certificate.

If you maintain an app together with multiple people it is recommended to designate a release manager responsible for the signing process as well as the uploading to `marketplace <https://marketplace.owncloud.com/>`_. 
If case this is not feasible, and multiple certificates are required, ownCloud can create them on a case by case basis. 
We do not recommend developers to share their private key.

Errors
------

The following errors can be encountered when trying to verify a code signature.
For information about how to get access to those results please refer to `the Issues section of the ownCloud Server Administration manual`_.

``INVALID_HASH``

- The file has a different hash than specified within ``signature.json``. This
  usually happens when the file has been modified after writing the signature 
  data.

``MISSING_FILE``

- The file cannot be found but has been specified within ``signature.json``. 
  Either a required file has been left out, or ``signature.json`` needs to be 
  edited.

``EXTRA_FILE``

- The file does not exist in ``signature.json``. This usually happens when a 
  file has been removed and ``signature.json`` has not been updated.

``EXCEPTION``

- Another exception has prevented the code verification. There are currently
  these following exceptions:

  - ``Signature data not found.```

    - The app has mandatory code signing enforced but no ``signature.json`` 
      file has been found in its ``appinfo`` folder.

  - ``Certificate is not valid.``

    - The certificate has not been issued by the official ownCloud Code 
      Signing Root Authority.

  - ``Certificate is not valid for required scope. (Requested: %s, current: 
    %s)``

    - The certificate is not valid for the defined application. Certificates 
      are only valid for the defined app identifier and cannot be used for 
      others.

  - ``Signature could not get verified.``

    - There was a problem with verifying the signature of ``signature.json``.

.. Links

.. _the Issues section of the ownCloud Server Administration manual: https://doc.owncloud.com/server/latest/admin_manual/issues/code_signing.html#fixing-invalid-code-integrity-messages
