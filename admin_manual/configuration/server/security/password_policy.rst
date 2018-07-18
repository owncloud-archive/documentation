===============
Password Policy
===============

.. _password_policy_label:

.. figure:: ../../../images/configuration/server/security/password-policy-app.png
   :alt: The Password Policy application

.. caution:: The Security and Password Policy apps are mutually exclusive.

From the 2.0.0 release of `the Password Policy app`_, all ownCloud users (both enterprise and community) have the option of installing and enabling the application.
The Password Policy application enables administrators to define password requirements for user passwords and public links.

+------------------------------------------------------------------------------------+----------------+-----------------------+
| Setting                                                                            | User Passwords | Public Link Passwords |
+====================================================================================+================+=======================+
| Specify a valid password requirements.                                             | Yes            | Yes                   |
+------------------------------------------------------------------------------------+----------------+-----------------------+
| Specify a password expiration period.                                              | Yes            | Yes                   |
+------------------------------------------------------------------------------------+----------------+-----------------------+
| Specify expiration dates for public link shares.                                   | No             | Yes                   |
+------------------------------------------------------------------------------------+----------------+-----------------------+
| Forced password change on first login.                                             | Yes            | No                    |
+------------------------------------------------------------------------------------+----------------+-----------------------+
| Disallowing passwords that match a configurable number of previous passwords       | Yes            | Yes                   |
| (defaults to the previous 3).                                                      |                |                       |
+------------------------------------------------------------------------------------+----------------+-----------------------+
| Users can be notified a configurable number of days before their password expires. | Yes            | No                    |
+------------------------------------------------------------------------------------+----------------+-----------------------+
| Users will be notified when their password has expired.                            | Yes            | No                    |
+------------------------------------------------------------------------------------+----------------+-----------------------+

.. note::
   Active user sessions will **not** end when passwords expire.
   However, a password change will be forced when the user session expires (e.g., on logout).
   Token access for app or client authentication is not affected.

.. note::
   Installing and enabling the application also extends the occ command to support :ref:`the user\:expire-password command <user-expire-password_label>`.

The Security App
~~~~~~~~~~~~~~~~

.. caution:: The Security and Password Policy apps are mutually exclusive.

Users can, *alternatively*, use `the Security app`_.
It supports configuring a basic password policy, which includes:

#. Setting a password length
#. Whether to enforce at least one upper and lower case character, a numerical character, and a special character.

.. figure:: ../../../images/configuration/server/security/security-app-password-policy.png

.. tip::
   In the next release, the Security app's feature-set will be reduced to provide only brute-force protection capabilities and be renamed "*Brute-Force Protection*".

.. Links

.. _the Password Policy app: https://marketplace.owncloud.com/apps/password_policy
.. _the Security app: https://marketplace.owncloud.com/apps/security
