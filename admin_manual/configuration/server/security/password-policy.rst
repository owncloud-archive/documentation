===============
Password Policy
===============

.. _password_policy_label:

Password Policy
---------------

.. figure:: ../../../images/configuration/server/security/password-policy-app.png
   :alt: The Password Policy application

From the 2.0.0 release of `the Password Policy app`_, all ownCloud users (both enterprise and community) have the option of installing and enabling the application.
The Password Policy application enables administrators to define password requirements, including:

- Specify a valid password requirements.
- Specify a password expiration period.
- Specify expiration dates for public link shares.
- Forced password change on first login.
- Disallowing passwords that match a configurable number of previous passwords (defaults to the previous 3).

.. figure:: ../../../configuration/files/images/sharing-files-2.png

The Security App
~~~~~~~~~~~~~~~~

In addition to the Password Policy app, users can also use `the Security app`_.
It supports configuring a basic password policy, which includes:

#. Setting a password length
#. Whether to enforce at least one upper and lower case character, a numerical character, and a special character.

.. figure:: ../../../images/configuration/server/security/security-app-password-policy.png

.. note::
   In the next release, the Security app's feature-set will be reduced to provide only brute-force protection capabilities and be renamed "*Brute-Force Protection*".

.. Links

.. _the Password Policy app: https://marketplace.owncloud.com/apps/password_policy
.. _the Security app: https://marketplace.owncloud.com/apps/security
