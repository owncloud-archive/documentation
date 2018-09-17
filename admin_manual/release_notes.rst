=============
Release Notes
=============

* :ref:`10.0.10_release_notes_label`
* :ref:`10.0.9_release_notes_label`
* :ref:`10.0.8_release_notes_label`
* :ref:`10.0.7_release_notes_label`
* :ref:`10.0.6_release_notes_label`
* :ref:`10.0.5_release_notes_label`
* :ref:`10.0.4_release_notes_label`
* :ref:`10.0.3_release_notes_label`
* :ref:`10.0.1_release_notes_label`
* :ref:`10.0.0_release_notes_label`
* :ref:`9.1_release_notes_label`
* :ref:`9.0_release_notes_label`
* :ref:`8.2_release_notes_label`
* :ref:`8.1_release_notes_label`
* :ref:`8.0_release_notes_label`
* :ref:`7.0_release_notes_label`

.. _10.0.10_release_notes_label:

Changes in 10.0.10
--------------------------

Dear ownCloud administrator, please find below the changes and known issues in ownCloud Server 10.0.10 that need your attention. You can also read `the full ownCloud Server changelog`_ for further details on what has changed.

Official PHP 7.2 Support
~~~~~~~~~~~~~~~~~~~~~~~~

After announcing the future deprecation of PHP 5.6 and 7.0 with the `10.0.8 release <https://doc.owncloud.com/server/10.0/admin_manual/release_notes.html#php-5-6-deprecation>`_, ownCloud Server now follows up by officially adding PHP 7.2 support. The Server Core and all apps maintained by ownCloud have received a full QA cycle and are proven to work reliably with PHP 7.2.

ownCloud Server is also being prepared for PHP 7.3, which is `scheduled to become available by the end of 2018 <https://wiki.php.net/todo/php73>`_. If you are still using versions 5.6 or 7.0, please plan an upgrade to 7.2 soon. See the `system requirements in the ownCloud Documentation <https://doc.owncloud.com/server/latest/admin_manual/installation/system_requirements.html#officially-recommended-supported-options>`_.

.. note:: With PHP 7.2 some extensions have changed. If you have not yet upgraded, you need to install ``php-openssl``. See `#30337 <https://github.com/owncloud/core/issues/30337>`_ for more information.

New Local User Creation Flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In previous versions, administrators created local users by entering a username and a password. In many cases this is undesirable, as administrators set the password for new users and need to provide it via a second communication channel. For this reason the local user creation flow has been changed to expect a username and an email address, which will be used to send an activation link to new users.

This way user creation is easier and more secure as new users are informed automatically and can choose a password in self-service. For cases where administrators want to set the initial password, it's possible to deviate from the default by setting the option "*Set a password for new users*" on the bottom left settings cog. The former option "*Send email to new users*" has been removed, as this change made it obsolete.

HTTP API for Search
~~~~~~~~~~~~~~~~~~~

ownCloud Server 10.0.10 introduces an HTTP API for search functionality. It enables the use of search terms to query the server and the delivery of search results via HTTP (WebDAV). In upcoming releases, ownCloud clients will make use of it to search content on the server, without the need to have them available locally.

In combination with the Full-Text Search integration, which is soon to be released as an ownCloud Server extension (Community Edition), HTTP API for Search will boost usability and productivity for users. For example, they will be able to search through all the content which they store in their account and quickly find files on their smartphones.

Native Brute-Force Protection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Together with the new server version, another security-enhancing extension is available, `Brute Force Protection <https://marketplace.owncloud.com/apps/brute_force_protection>`_. This extension is tasked with preventing attackers from guessing user passwords (brute-force attack) by delaying subsequent failed login attempts for a user account from the same IP address.

While in the past similar functionality was only achievable via third party applications, such as *Fail2Ban*, this extension provides the functionality natively, configurable by ownCloud administrators on the Security settings section.

The new extension supersedes the former `Security <https://marketplace.owncloud.com/apps/security>`_ extension together with the new `Password Policy <https://marketplace.owncloud.com/apps/password_policy>`_ extension, which `has been released with ownCloud Server 10.0.9 <https://doc.owncloud.com/server/latest/admin_manual/release_notes.html#password-history-and-expiration>`_. This community-contributed extension is well-tested, but out of ownCloud's general support scope. However, individual support can be obtained on request.

Improved Reliability for Uploads Via Web Interface on Unreliable Connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The reliability of the file upload feature in the ownCloud web interface has been improved. When uploading larger amounts of data on unreliable connections (e.g., on the train or with mobile data) you have to deal with interruptions and timeouts, which in the past required users to restart stalled uploads from the beginning in the worst case.

On top of ownCloud's chunking mechanism, which splits large files into pieces and uploads them separately, there's new logic that takes care of retrying stalled chunks. With this, uploads can now continue from the point they froze when a connection becomes available again.

New Option to Prevent Sharing With Specific System Groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

System groups in ownCloud can have many purposes. They can be used for sharing with many users at once, for feature and access restrictions, or for storage mounts to specific users - just to name a few. In some cases, especially in larger deployments, it's undesirable that groups which are used for other purposes are also available for sharing. To prevent users from sharing with such groups, administrators can now blacklist the respective system groups using the option "*Exclude groups from receiving shares*" in the administration settings "*Sharing*" section.

New Options for the occ Command to Reset User Passwords
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The occ command ``user:resetpassword`` allows system administrators to reset or change user passwords. It has been extended to provide the additional options ``--send-email`` and ``--output-link``, which can be used to send a password reset link to the user via mail and output the password reset link to the command line, respectively. This change is in line with the new local user creation flow, which is explained above, and can also be used for further processing with scripts. See the ownCloud Documentation and the ``--help`` option for more information.

New Default Minimum Supported Desktop Client Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To ensure clean and reliable operation of the ownCloud platform it is important to stay up-to-date with the latest releases for the server as well as the clients. To take care of compatibility between the server and desktop clients, the minimum version the server will accept connections from has been raised to version ``2.3.3``. While it's recommended to keep up with later versions, this is the new default value. It can be changed by altering the config.php parameter ``'minimum.supported.desktop.version' => '2.3.3',`` if absolutely necessary.

New Option to Configure the Language of Mail Notifications for Public Links
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Usually ownCloud renders mail notifications in the language of the recipients, when they are known. For the `recently improved feature <https://doc.owncloud.com/server/10.0/admin_manual/release_notes.html#personal-note-for-public-link-mail-notification>`_ to send public links with a personal note directly from the user interface, the recipients' language can't be determined automatically, it just knows the recipients' mail addresses.

ownCloud therefore uses the language of the user who sent the notification, which can have the drawback that recipients can't understand them. This is still the default behavior but administrators can now change it via a dropdown menu "*Language used for public mail notifications for shared files*" in the settings "*Sharing*" section.

Theming Changes
~~~~~~~~~~~~~~~

Mail templates for share notifications do not strip line breaks from the personal note anymore. This affects the HTML (``core/templates/mail.php``) and plain text (``core/templates/altmail.php``) mail templates. The default templates shipped with ownCloud Server 10.0.10 have been modified to accommodate these changes. If your custom theme overrides these templates, you have to follow up with the changes:

- Replace the following line of the HTML template
``p($l->t("Personal note from the sender: %s.", [$_['personal_note']]));``

with

``print_unescaped($l->t("Personal note from the sender: <br> %s.", $_['personal_note']));``.

- Replace the following line of the plain text template

``print_unescaped($l->t("Personal note from the sender: %s.", [$_['personal_note']]));``

with

``print_unescaped($l->t("Personal note from the sender: \n %s.", $_['personal_note']));``.

Other Notable Changes
~~~~~~~~~~~~~~~~~~~~~

- Allow automated SSL certificate verifications for CAs other than Let's Encrypt. See `#31858 <https://github.com/owncloud/core/issues/31858>`_ for further details.
-  "/" and "%" are now valid characters in group names. See `#31109 <https://github.com/owncloud/core/issues/31109>`_ for further details.
- New audit events for login action with token or Apache. See `_#31985 <https://github.com/owncloud/core/issues/31985>`_ for further details.
- Log entries for exceeding user quota: Loglevel changed to "debug" (Insufficient storage exception is now logged with "debug" log level).
- The app for embedding external sites to the app launcher ("*external*") now supports icons that originate from theme apps.
- The occ command to deactivate storage encryption (``occ encryption:decrypt-all``) has received stability improvements and can now read the required recovery key from an environment variable which is very helpful for a scripted per-user decryption process.

Solved Known Issues
~~~~~~~~~~~~~~~~~~~

ownCloud Server 10.0.10 takes care of `10.0.9 known issues <https://doc.owncloud.com/server/latest/admin_manual/release_notes.html#id10>`_ and provides remedies for several others:

- The Password Policy extension now works with two- or multi-factor authentication extensions. See `#32058 <https://github.com/owncloud/core/issues/32058>`_ for further details.
- The ``Versions`` feature now works also when the ``Comments`` app is disabled. See `#32208 <https://github.com/owncloud/core/issues/32208>`_ for further details.
- E-mail addresses with subdomains with hyphens are now also accepted for public link emails. See `#32281 <https://github.com/owncloud/core/issues/32281>`_ for further details.
- Allow null in "Origin" header for third party clients that send it with WebDAV. See `#32189 <https://github.com/owncloud/core/issues/32189>`_ for further details.
- Properly log failed message when token based authentication is enforced (fail2ban). See `#31948 <https://github.com/owncloud/core/issues/31948>`_ for further details.
- Deleting a user now also properly deletes their external storages and storage assignations. See `#32069 <https://github.com/owncloud/core/issues/32069>`_ for further details.
- Lockout issues with wrong passwords for Windows Network Drives are mitigated: Fixed mount config in frontend to only load once to avoid side effects. See `#32095 <https://github.com/owncloud/core/issues/32095>`_ for further details.
- Fixed update issue related to oc_jobs when automatically enabling market app to assist for update in OC 10. See `#32573 <https://github.com/owncloud/core/pull/32573>`_ for further details.
- Fixed missing migrations in files_sharing app and add indices to improve performance. See `#32562 <https://github.com/owncloud/core/issues/32562>`_ for further details.
- Fixed issue with spam filters when sending public link emails. See `#32542 <https://github.com/owncloud/core/issues/32542>`_ for further details.

Known Issues
~~~~~~~~~~~~

Currently there are no known issues with ownCloud Server 10.0.10.
This section will be updated in the case that issues become known.

For Developers
~~~~~~~~~~~~~~

- Search API for files using WebDAV REPORT and an underlying search provider. See `#31946 <https://github.com/owncloud/core/issues/31946>`_ and `#32328 <https://github.com/owncloud/core/issues/32328>`_ for further details.
- Add information whether user can share to capabilities API. See `#31824 <https://github.com/owncloud/core/issues/31824>`_ for further details.
- Hook ``loadAdditionalScripts`` now also available for public link page. See `#31944 <https://github.com/owncloud/core/issues/31944>`_ for further details.
- Added URL parameter to files app which opens a specific sidebar tab. See `#32202 <https://github.com/owncloud/core/issues/32202>`_ for further details.
- Allow slashes in generated resource routes in app framework. See `#31939 <https://github.com/owncloud/core/issues/31939>`_ for further details.
- The app for embedding external sites to the app launcher ("*external*") has been moved to a `separate repository <https://github.com/owncloud/external>`_. It is still bundled with ownCloud Server releases and can be used normally.

.. _10.0.9_release_notes_label:

Changes in 10.0.9
-----------------

Dear ownCloud administrator, please find below the changes and known issues in ownCloud Server 10.0.9 that need your attention. You can also read `the full ownCloud Server changelog`_ for further details on what has changed.

New Features
~~~~~~~~~~~~

Pending Shares
^^^^^^^^^^^^^^

ownCloud Server 10.0.9 introduces new features to close usability gaps and to give users more control over incoming shares. Previously, shared contents would appear, unannounced, in the receiving user's file hierarchy, and clients would start synchronizing.

Incoming shares can now have a pending state, offering the ability to accept or decline (as known from federated sharing). We anticipate that this will provide a better user experience.

In addition, the `recently introduced notifications framework <https://doc.owncloud.com/server/latest/admin_manual/release_notes.html#new-mail-notifications-feature>`_ is being used to inform users via mail.

The bell icon in the web interface and the ownCloud Desktop Client can additionally be used to take action. To switch to the new behavior administrators need to disable the configuration option "Automatically accept new incoming local user shares" in the *Sharing* settings section. By default the option will be enabled to preserve the known behavior.

.. NOTE::

  Mail notifications do not, currently, support asynchronous batch processing. For this reason, ownCloud will send notification emails directly when initiating shares between users. Due to this limitation, sharing with large groups (> 50 users) can take some time and might cause load peaks. When operating installations with large groups, it is, therefore, not yet recommended to enable the feature.

Overview of pending & rejected shares
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In addition to the "*Pending Shares*" feature, ownCloud Server now provides the means to view "*accepted*", "*pending*" and *"rejected*" incoming shares. Leveraging the "*Shared with you*" filter in the left sidebar of the files view users can now list all incoming shares, their respective states and have the ability to switch between the states easily.

This improvement not only empowers users to accept rejected shares subsequently but also to restore shares that have been unshared before without requiring the owner to share it again.

Password history and expiration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To prepare ownCloud Server for new capabilities in the authentication process, we have introduced an authentication middleware, and a new major version of the `Password Policy <https://marketplace.owncloud.com/apps/password_policy>`_ extension is now available.

The Authentication Middleware
`````````````````````````````

It:

1. Offers a defined way of inserting mandatory functionality between user authentication and user account access. For example, forcing users to accept legal agreements.
2. Affords the ability to interact with the user during the login process, such as retrieving user details like their email address.

.. note::
   The authentication middleware is *currently* focused on offering new features for the Password Policy extension.

The Password Policy Extension
`````````````````````````````

`The Password Policy Extension <https://marketplace.owncloud.com/apps/password_policy>`_ has got a new major release and has been relicensed (OCL => GPLv2) to be available for community and standard subscription users as well. It now supports password expiration and history policies for user accounts.

.. note::
   These features don't apply to users imported from LDAP or other backends but only for local users created by administrators or the `Guests <https://marketplace.owncloud.com/apps/guests>`_ extension.

Imposing password expiration and history policies enhances security for a number of reasons.
For example, by forcing users to choose a new password, they can be prevented from using one or more of their previous passwords.
In doing this, it encourages them to not use a previous password, which may be known to attackers.

Two further examples are manually expiring passwords and configuring the number of days that have to pass since the last change before the password expires.
These help ensure that users change their passwords on a semi-regular basis, making them harder to crack.

However, we encourage administrators to always consider the implication of their password policies, so that they strike an appropriate balance between security and usability.
For example, a high frequency of password changes, for instance, might increase security but could also decrease user satisfaction.

To help ensure a good user experience it is possible to configure:

- Email notifications.
- Internal notifications (they appear on the web interface and clients).
- The password history count.
- The days before reminder notification are sent.

Users will always be informed when passwords have expired.

.. note::
   Although the above two password practices `are discouraged by NIST
   <https://pages.nist.gov/800-63-3/sp800-63b.html>`_, ownCloud is now fully
   compliant with common password guidelines in enterprise scenarios.

.. note::
   When users employ tokens for client authentication, which can be configured
   on the user settings page ("App passwords"), those are not affected from
   password policies.

.. note::
   When imposing password expiration policies on an existing installation it is
   necessary to take some further actions. Please consult `the ownCloud documentation`_ for guidance.

Technology preview for new S3 Objectstore implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ownCloud Server 10.0.9 comes with the prerequisites to be ready for the new S3 Objectstore implementation "*files_primary_s3*", which will massively improve performance, reliability and protocol-related capabilities. The new extension is available as a technology preview via `the ownCloud Marketplace`_ and will supersede the current `Objectstore`_ extension.

It has received extensive testing and is in very good shape. However, there is no out-of-the-box migration from the current *Objectstore* to *files_primary_s3* as this will require individual guidance.

Due to changes to the Versioning API, `the ownCloud Ransomware Protection`_ is not yet compatible with *files_primary_s3*. For now the _Objectstore_ extension will continue to work as usual. Once the new implementation leaves the technology preview state and migrations have been taken care of, the current implementation will be deprecated.

SWIFT Objectstore deprecation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As the markets are moving in the direction of `the S3 protocol`_ to communicate with object storages, ownCloud will follow this path with a clear focus. To do this, it will be a necessity to deprecate object storage via `the OpenStack SWIFT protocol`_.

The extension will still be available as part of ownCloud Server, but it will neither be maintained nor developed any further by ownCloud, and support will be discontinued. Please make sure to move to the S3 protocol to use object storage as primary storage with future ownCloud Server versions.

New options to display Imprint and Privacy Policy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To enable GDPR and legal compliance in various jurisdictions for ownCloud providers, it is now possible to specify links to Imprint and Privacy Policy:

- In the "*General*" Administration settings  section
- Via the following OCC commands:

  - ``php occ config:app:set core legal.imprint_url <link>``
  - ``php occ config:app:set core legal.privacy_policy_url <link>``

These links can be displayed on all pages of the ownCloud web interface and in the footer of mail notifications. When using one of the default themes provided by ownCloud, as well as the default mail templates, configured links will be automatically included.

For customized themes or mail templates, actions are required to include the links.
These are:

#. Add the following at the end of each HTML template to add the footer:

``<?php print_unescaped($this->inc('html.mail.footer', ['app' => 'core'])); ?>``

#. Add the following at the end of each plain text template to add the footer:

``<?php print_unescaped($this->inc('plain.mail.footer', ['app' => 'core'])); ?>``

#. In a custom theme, change ``getShortFooter`` and ``getLongFooter`` in ``defaults.php`` `without links <https://github.com/owncloud/theme-example/blob/master/defaults.php#L124>`_  to `include the links <https://github.com/owncloud/core/blob/master/lib/private/legacy/defaults.php#L256>`_

Changed behavior of "Exclude groups from sharing" option
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The option "*Exclude groups from sharing*", in the administration settings "*Sharing*" section, enables administrators to exclude groups of users from the ability to initiate file shares. In previous versions this restriction only applied to users who were members of exactly these groups (membership of one or more non-excluded groups bypassed the restriction).

This behavior has been changed to be both more restrictive and to better cover the expectations of administrators. With ownCloud Server 10.0.9, it will apply to all users who are members of at least one of the excluded groups.

Changes to the sharing autocomplete mechanism
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In ownCloud Server 10.0.8, the value for :ref:`minimum characters to trigger the sharing autocomplete mechanism <min-chars-for-sharing-autocomplete-label>` has been made configurable and set to `4` by default. As this security-enhancing change came at the expense of usability, and might only be required in special scenarios, the default value has been reverted to `2`.

For increased security requirements, the ``config.php`` option ``'user.search_min_length' => 2`` can be adjusted. To further improve usability, a hint has been added to inform users about the required character count, to get suggestions.

Improvements for *occ user:list*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To improve the usability of the ``occ user:list`` command, the output has been made configurable by using the ``-a`` option, for including certain attributes. This change has mainly been introduced to facilitate automation tasks. Check the ``--help`` option for more information.

Additional events for audit logging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

New events are available for audit logging, among others. These include:

- Changes in user specific settings
- Sending public links via mail; and
- Accepting and rejecting shares

When logs are forwarded to external analyzers, like Splunk, administrators can check to add the new events. The latest version of the Auditing extension (``admin_audit``) is required.

Theming improvements and changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- HTML templates for ``lost password`` mails have been added. This is important in case a custom theme is used and it needs manual adjustments.

- The mail notifications framework, :ref:`introduced with ownCloud Server 10.0.8 <new-mail-notifications-feature-label>`, has been extended to provide a basic framework and notification structure, which can be used by ownCloud features and third party extensions. To support this, mail template wording and structure have been updated. Please review the templates in ``apps/notifications/templates/mail/`` to align them with your needs.

- Mail templates can now include a footer for HTML (``core/templates/html.mail.footer.php``) and plain text mails (``core/templates/plain.mail.footer.php``). The default templates shipped with ownCloud Server 10.0.9 contain the respective references. For customized mail templates, it is necessary to manually add the references. To do so:

  - Add the following at the end of each HTML template: ::

      <?php print_unescaped($this->inc('html.mail.footer', ['app' => 'core'])); ?>

  - Add the following at the end of each plain text template: ::

      <?php print_unescaped($this->inc('plain.mail.footer', ['app' => 'core'])); ?>

- The ownCloud example theme (``theme-example``), which can be used as a solid base to create custom themes, is no longer bundled with ownCloud Server. It now lives in it's own `repository on GitHub`_.

Solved known issues
~~~~~~~~~~~~~~~~~~~

ownCloud Server 10.0.9 takes care of `10.0.8 known issues <https://doc.owncloud.com/server/latest/admin_manual/release_notes.html#id1>`_, and provides remedy for several others:

- Issues with multiple theme apps and the Mail Template Editor `#31478 <https://github.com/owncloud/core/issues/31478>`_
- OCC command to transfer data between users (``occ transfer:ownership``) works as expected again. Previously, public link shares were not transferred. See `#31176 <https://github.com/owncloud/core/issues/31176>`_ for further details.
- OCC commands to encrypt (``occ encryption:encrypt-all``) and decrypt (``occ encryption:decrypt-all``) user data work correctly again. Previously, shares might have been lost during the encryption process. See `#31600 <https://github.com/owncloud/core/issues/31600>`_ and `#31590 <https://github.com/owncloud/core/issues/31590>`_ for further details.

- Files larger than 10 MB can now properly be uploaded by guest users. See `#31596 <https://github.com/owncloud/core/issues/31596>`_ for further details.
- Issues with public link dialog when collaborative tags app is disabled has been resolved. See `#31581 <https://github.com/owncloud/core/issues/31581>`_ for further details.
- Enabling/disabling of users by group administrators in the web UI works again. See `#31489 <https://github.com/owncloud/core/issues/31489>`_ for further details.
- Issues with file upload using Microsoft EDGE are now circumvented (hard memory limit of 5 GB causing uploads to fail randomly as garbage collection for file chunks did not work properly). See `#31884 <https://github.com/owncloud/core/pull/31825>`_ for further details.

Known issues
~~~~~~~~~~~~

The new Password Policy feature `"Password Expiration"`_:

- Does not work together with Multi-Factor Authentication (e.g. ``twofactor_totp``, ``twofactor_privacyidea``). Please do not deploy expiration policies yet when Two- or Multi-Factor Authentication extensions are in place. This issue will be solved with the next ownCloud Server release. See `#32059`_ for more information.
- The new Password Policy feature `"Password Expiration"`_ includes an *occ* command to manually force password expiration. Please run it directly after imposing expiration policies on an instance with existing users. Currently the command will only work when the policy *X days until user password expires* has been enabled. This might be confusing and will be solved with the next release of the extension. See `#66`_ for more information.

For developers
~~~~~~~~~~~~~~

- The symfony event for logging has been extended to include the original exception when applicable: `#31623 <https://github.com/owncloud/core/issues/31623>`_
- Added Symfony event for whenever user settings are changed `#31266 <https://github.com/owncloud/core/issues/31266>`_
- Added Symfony event for whenever a public link share is sent by email `#31632 <https://github.com/owncloud/core/issues/31632>`_
- Added Symfony event for whenever local shares are accepted or rejected `#31702 <https://github.com/owncloud/core/issues/31702>`_
- Added public Webdav API for versions using a new "meta" DAV endpoint `#31729 <https://github.com/owncloud/core/pull/29207>`_ `#29637 <https://github.com/owncloud/core/pull/29637>`_
- Added support for retrieving file previews using Webdav endpoint `#29319 <https://github.com/owncloud/core/pull/29319>`_ `#30192 <https://github.com/owncloud/core/pull/30192>`_

.. _10.0.8_release_notes_label:

Changes in 10.0.8
-----------------

Dear ownCloud administrator, please find below the changes and known issues in ownCloud Server 10.0.8 that need your attention. You can also read `the full ownCloud Server changelog`_ for further details on what has changed.

PHP 5.6 deprecation
~~~~~~~~~~~~~~~~~~~
PHP 5.6/7.0 active support has ended on January 19th 2017 / December 3rd 2017 and security support `will be dropped by the end of 2018 <https://secure.php.net/supported-versions.php>`_. Many libraries used by ownCloud (including the QA-Suite *PHPUnit*) will therefore not be maintained actively anymore which forces ownCloud to drop support in one of the next minor server versions as well. Please make sure to upgrade to PHP 7.1 as soon as possible. See the `system requirements in the ownCloud documentation <https://doc.owncloud.com/server/latest/admin_manual/installation/system_requirements.html#officially-recommended-supported-options>`_.

Personal note for public link mail notification
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
One of the usability enhancements of ownCloud Server 10.0.8 is the possibility for users to add a personal note when sending public links via mail. When using customized mail templates it is necessary to either adapt the shipped original template to the customizations or to add the `code block <https://github.com/owncloud/core/blob/stable10/core/templates/mail.php#L21-L25>`_ for the personal note to customized templates in order to display the personal note in the mail notifications.

.. _new-mail-notifications-feature-label:

New mail notifications feature
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ownCloud Server 10.0.8 introduces a new extensible notification framework. Apart from technical changes under the hood the Notifications app can now also send mails for all notifications that previously were only displayed within the web interfaces (notification bell) or on the Desktop client (notifications API) like incoming federated share or Custom Group notifications, for example. In the *"General"* settings section users can configure whether they want to receive mails for all notifications, only for those that require an action or decide not to get notifications via mail (by default users will only receive notifications when an action is required).

LDAP-related improvements
~~~~~~~~~~~~~~~~~~~~~~~~~
- When disabling or deleting user accounts in LDAP, the administrator can choose to either *delete* or *disable* respective accounts in ownCloud when executing ``occ user:sync`` (``-m, --missing-account-action=MISSING-ACCOUNT-ACTION``). User accounts that are disabled in ownCloud can now be re-enabled automatically when running ``occ user:sync`` if they are enabled in LDAP. When this behavior is desired administrators just need to add the ``-r, --re-enable`` option to their cron jobs or when manually executing ``occ user:sync``.
- Furthermore it is now possible to execute ``occ user:sync`` only for *single* (``-u, --uid=UID``) or *seen* (``-s, --seenOnly``) users (users that are present in the database and have logged in at least once). These new options provide more granularity for administrators in terms of managing ``occ user:sync`` performance. 
- Another notable change in behavior of ``occ user:sync`` is that administrators now have to explicitly specify the option ``-c, --showCount`` to display the number of users to be synchronized.

New events for audit logging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
New events have been added to be used for audit logging, among others. These include *configuration changes* by administrators and users, *file comments* (*add/edit/delete*) and *updating existing public links*. When logs are forwarded to external analyzers like Splunk, administrators can check to add the new events. The latest version of the Auditing extension (*admin_audit*) is required.

New command to verify and repair file checksums
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
With ownCloud 10 file integrity checking by computing and matching checksums has been introduced to ensure that transferred files arrive at their target in the exact state as their origin. In some rare cases wrong checksums can be written to the database leading to synchronization issues with e.g. the Desktop Client. To mitigate such situations a new command ``occ files:checksums:verify`` has been introduced. The command recalculates checksums either for all files of a user or for files within a specified path, and compares them with the values in the database. Naturally the command also offers an option to repair incorrect checksum values (``-r, --repair``). Please check the available options by executing ``occ files:checksums:verify --help``. Note: Executing this command might take some time depending on the file count.

.. _min-chars-for-sharing-autocomplete-label:

New config setting to specify minimum characters for sharing autocomplete
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For security reasons the default value for minimum characters to trigger the sharing autocomplete mechanism has been set to "4" (previously it was set to "2"). This is to prevent people from easily downloading lots of email addresses or user names by requesting their first letters through the API. As it is a trade-off between security and usability for some scenarios this high security level might not be desirable. Therefore the value now is configurable via the *config.php* option ``'user.search_min_length' => 4,``. Please check which value fits your needs best.

New option to granularly configure public link password enforcement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
With ownCloud 10 the *"File Drop"* feature has been merged with public link permissions. This kind of public link does not give recipients access to any content, but it gives them the possibility to "drop files". As a result, it might not always be desirable to enforce password protection for such shares. Given that, passwords for public links can now be enforced based on permissions (*read-only, read & write, upload only/File Drop*). Please check the administration settings *"Sharing"* section and configure as desired.

New option to exclude apps from integrity check
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
By verifying signature files the *integrity check* ensures that the code running in an ownCloud instance has not been altered by third parties. Naturally this check can only be successful for code that has been obtained from official ownCloud sources. When providing custom apps (like theme apps) that do not have a signature, the integrity check will fail and notify the administrator. These apps can now be excluded from the *integrity check* by using the *config.php* option ``'integrity.ignore.missing.app.signature' => ['app_id1', 'app_id2', 'app_id3'],``. See *config.sample.php* for more information.

New occ command to modify user details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
It is now possible to modify user details like display names or mail addresses via the command ``occ user:modify``. Please append ``--help`` for more information.

occ files:scan can now be executed for groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Apart from using the ``occ files:scan`` command for *single users* and *whole instances* it can now be executed for *groups* using ``-g, --groups=GROUPS``. Please append ``--help`` for more information.

New configurable default format for syslog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
When using syslog as the log type (``'log_type' => 'syslog',`` in *config.php*) the default format has been changed to include *request IDs* for easier debugging. Additionally the log format has been made configurable using ``'log.syslog.format'`` in *config.php*. If you require a certain log format, please check the new format and *config.sample.php* on how to change it.

New config option to enable fallback to HTTP for federated shares
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For security reasons federated sharing (sharing between different ownCloud instances) strictly requires HTTPS (SSL/TLS). When this behavior is undesired the insecure fallback to HTTP needs to be enabled explicitly by setting ``'sharing.federation.allowHttpFallback' => false,`` to ``true`` in *config.php*.

Migration related to auth_tokens (app passwords)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Upgrading to 10.0.8 includes migrations related to *auth_tokens* (*app passwords*). When users have created *app passwords* as separate passwords for their clients the upgrade duration will increase depending on user count. Please consider this when planning the upgrade.

Changed behavior of e-mail autocomplete for public link share dialog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
When the *"Sharing"* settings option ``Allow users to send mail notifications for shared files`` for public links is enabled, users can send public links via mail from within the web interface. The behavior of the autocomplete when entering mail addresses in the public link share dialog has been changed. Previously the autocomplete queried for local users, users from federated address books and contacts from CardDAV/Contacts App. As public links are not intended for sharing between ownCloud users (local/federated), those have been removed. Contacts synchronized via CardDAV or created in the Contacts app will still appear as suggestions.

Notifications sent by *occ* can now include links
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The command ``occ notifications:generate`` can be used to send notifications to individual users or groups. With 10.0.8 it is also capable of including links to such notifications using the ``-l, --link=LINK`` option. Please append ``--help`` for more information. There is also `Announcementcenter <https://marketplace.owncloud.com/apps/announcementcenter>`_ to conduct such tasks from the web interface but it is currently limited to send notifications to all users. For now administrators can use the *occ* command if more granularity is required.

Global option for CORS domains
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For security reasons ownCloud has a *Same-Origin-Policy* that prevents requests to ownCloud resources from other domains than the domain the backend server is hosted on. If ownCloud resources should be accessible from other domains, e.g. for a separate web frontend operated on a different domain, administrators can now globally specify policy exceptions via *CORS (Cross-Origin Resource Sharing)* using ``'cors.allowed-domains'`` in *config.php*. Please check *config.sample.php* for more information.

Mail Template Editor is now unbundled
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The Mail Template Editor has been unbundled from the default apps and is not shipped with the Server anymore. When upgrading ownCloud will try to automatically `install the latest version from the ownCloud Marketplace <https://marketplace.owncloud.com/apps/templateeditor>`_ in case the app was installed before. If this is not possible (e.g. no internet connection or clustered setup) you will either need to disable the app (``occ app:disable templateeditor``) or `download and install it manually <https://doc.owncloud.com/server/latest/admin_manual/installation/apps_management_installation.html?highlight=install%20apps#manually-installing-apps>`_.
Solved known issues
~~~~~~~~~~~~~~~~~~~
- Bogus "Login failed" log entries have been removed (see `10.0.7 known issues <https://doc.owncloud.com/server/latest/admin_manual/release_notes.html#changes-in-10-0-7>`_)
- The *Provisioning API* can now properly set default or zero quota
- User quota settings can be queried through *Provisioning API*
- A regression preventing a user from setting their e-mail address in the settings page has been fixed
- File deletion as a guest user works correctly (trash bin permissions are checked correctly)

Known issues
~~~~~~~~~~~~

- Issues with multiple theme apps and Mail Template Editor
As of ownCloud Server 10.0.5 it is only possible to have one theme app enabled simultaneously. When a theme app is enabled and the administrator attempts to enable a second one this will result in an error. However, when also having the Mail Template Editor enabled in this scenario the administrators *"General"* settings section `will be displayed incorrectly <https://github.com/owncloud/core/issues/31134>`_. As a remedy administrators can either uninstall the second theme app or disable the Mail Template Editor app.

- ``occ transfer:ownership`` `does not transfer public link shares if they were created by the target user (reshare) <https://github.com/owncloud/core/issues/31150>`_.

For developers
~~~~~~~~~~~~~~
- The global JS variable "oc_current_user" was removed. Please use the public method "OC.getCurrentUser()" instead.
- Lots of new Symfony events have been added for various user actions, see changelog for details. Documentation ticket: <https://github.com/owncloud/documentation/issues/3738>`_
- When requesting a private link there is a new HTTP response header "Webdav-Location" that contains the Webdav path to the requested file while the "Location" still points at the frontend URL for viewing the file.

.. _10.0.7_release_notes_label:

Changes in 10.0.7
-----------------

ownCloud Server 10.0.7 is a hotfix follow-up release that takes care of an `issue regarding OAuth authentication <https://github.com/owncloud/core/issues/30157>`_.

Please consider the ownCloud Server 10.0.5 release notes.

Known issues
~~~~~~~~~~~~

- When using application passwords, `log entries related to "Login Failed" will appear <https://github.com/owncloud/core/issues/30157>`_ and can be ignored. For people using fail2ban or other account locking tools based on log parsing, please apply `this patch <https://github.com/owncloud/core/commit/50c78a4bf4c2ab4194f40111b8a34b7e9cc17a14.patch>`_ with :code:`patch -p1 < 50c78a4bf4c2ab4194f40111b8a34b7e9cc17a14.patch` (`original pull request here <https://github.com/owncloud/core/pull/30591>`_).

.. _10.0.6_release_notes_label:

Changes in 10.0.6
-----------------

ownCloud Server 10.0.6 is a hotfix follow-up release that takes care of an issue during the build process (https://github.com/owncloud/core/pull/30265). Please consider the ownCloud Server 10.0.5 release notes.

.. _10.0.5_release_notes_label:

Changes in 10.0.5
-----------------

Dear ownCloud administrator, please find below the changes and known issues in ownCloud Server 10.0.5 that need your attention. You can also read `the full ownCloud Server changelog`_ for further details on what has changed.

Technology preview for PHP 7.2 support
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ownCloud catches up with new web technologies. This has mainly been introduced for the open-source community to test and give feedback. PHP 7.2 is not yet supported nor recommended for production scenarios. ownCloud is going to fully support PHP 7.2 with the next major release.

php-intl now is a hard requirement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Please make sure to have the PHP extension installed before upgrading.

Changed: Only allow a single active theme app
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The theming behavior has been changed so that only a single theme can be active concurrently. This change ensures that themes can not interfere in any way (e.g., override default theming in an arbitrary order). Please make sure to have the desired theme enabled after upgrading.

Removed old Dropbox external storage backend (Dropbox API v1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Please switch to the new *External Storage: Dropbox* app (https://marketplace.owncloud.com/apps/files_external_dropbox) with Dropbox API v2 support to continue providing Dropbox external storages to your users.

Fixed: Only set CORS headers on WebDAV endpoint when Origin header is specified
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ownCloud Server 10.0.4 known issue is resolved.

Fixes and improvements for the Mail Template Editor
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- Known issues are resolved: Mail Template Editor works again, got support for app themes and additional templates were added for customization.
- Mail Template Editor is still bundled with ownCloud Server but will soon be released as a separate app to ownCloud Marketplace.
- Changelog: https://github.com/owncloud/templateeditor/blob/release/0.2.0/CHANGELOG.md

Known issues
~~~~~~~~~~~~

- When using application passwords, `log entries related to "Login Failed" will appear <https://github.com/owncloud/core/issues/30157>`_, please upgrade to 10.0.7 and check the fix mentionned in its release notes.

.. _10.0.4_release_notes_label:

Changes in 10.0.4
-----------------

Dear ownCloud administrator, please find below the changes and known issues in ownCloud Server 10.0.4 that need your attention. You can also read `the full ownCloud Server 10.0.4 changelog`_ for further details on what has changed.

More granular sharing restrictions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The "*Restrict users to only share with users in their groups*" option, in the Sharing settings, restricts users to only share with groups which they are a member of, while simultaneously prohibiting sharing with single users that do not belong to any of the users' groups.

To make this more granular, we split this option into two parts and added "*Restrict users to only share with groups they are member of*", which differentiates between users and groups. Doing so makes it possible to restrict users from sharing with all users of an installation, limiting them to only being able to share with groups which they are a member of, and vice versa.

Configurable solution for indistinguishable user display names
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ownCloud sharing dialog displays users according to their display name. As users can choose their display name in self-service (which can be disabled in `config.php`) and display names are not unique, it is possible that a user can't distinguish sharing results. To cover this case the displayed user identifiers are now configurable. In the Sharing settings administrators can now configure the display of either mail addresses or user ids.

Added "occ files:scan" repair mode to repair filecache inconsistencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We recommend to use this command when directed to do so in the upgrade process.
Please refer to `the occ command's files:scan --repair documentation`_ for more information.

Detailed mode for "occ security:routes"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Administrators can use the output of this command when using a network firewall, to check the appropriateness of configured rules or to get assistance when setting up.

Added mode of operations to differentiate between single-instance or clustered setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As ownCloud needs to behave differently when operating in a clustered setup versus a single instance setup, the new `config.php` option ``operation.mode`` has been added. 
It can take one of two values: ``single-instance`` and ``clustered-instance``. 
For example: ``'operation.mode' => 'clustered-instance',``.

Currently the Market App (ownCloud Marketplace integration) does not support clustered setups and can do harm when used for installing or updating apps. 
The new config setting prevents this and other actions that are undesired in cluster mode.

**When operating in a clustered setup, it is mandatory to set this option.**
Please check `the config_sample_php_parameters documentation`_ for more information.

Added occ dav:cleanup-chunks command to clean up expired uploads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When file uploads are interrupted for any reason, already uploaded file parts (chunks) remain in the underlying storage so that the file upload can resume in a future upload attempt.
However, resuming an upload is only possible until the partial upload is expired and deleted, respectively. 

To clean up chunks (expire and delete) originating from unfinished uploads, administrators can use this newly introduced command. 
The default expiry time is two days, but it can be specified as a parameter to the command.
**It is recommended to configure CRON to execute this background job regularly**. 

It is not included in the regular ownCloud background jobs so that the administrators have more flexibility in scheduling it. 
Please check `the background jobs configuration documentation`_ for more information.

Administrators can now exclude files from integrity check in config.php
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When administrators did intentional changes to the ownCloud code they now have the ability to exclude certain files from the integrity checker.
Please check "config.sample.php" for the usage of ``'integrity.excluded.files'``.

Modification time value of files is now 64 bits long
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When upgrading to 10.0.4 migrations may increase update duration dependent on number of files.

Updated minimum supported browser versions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Users with outdated browsers might get warnings.
See :ref:`the list of supported browser versions <supported-browsers-label>`.

Known issues
~~~~~~~~~~~~

- When using application passwords, `log entries related to "Login Failed" will appear <https://github.com/owncloud/core/issues/30157>`_, please upgrade to 10.0.7 and check the fix mentioned in its release notes.

10.0.3 resolved known issues
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- `SFTP external storages with key pair mode work again <https://github.com/owncloud/core/issues/29156>`_
- `Added support for MariaDB 10.2.7+ <https://github.com/owncloud/core/issues/29240>`_
- `Encryption panel in admin settings fixed to properly detect current mode after upgrade to ownCloud 10 <https://github.com/owncloud/core/issues/29049>`_
- `Removed double quotes from boolean values in status.php output <https://github.com/owncloud/core/pull/29261>`_

Known issues
~~~~~~~~~~~~

- Impersonate app 0.1.1 does not work with ownCloud Server 10.0.4. Please update to `Impersonate 0.1.2 <https://marketplace.owncloud.com/apps/impersonate>`_ to be able to use the feature with ownCloud 10.0.4.
- `Mounting ownCloud storage via davfs does not work <https://github.com/owncloud/core/issues/29793>`_

.. _10.0.3_release_notes_label:

Changes in 10.0.3
-----------------

Dear ownCloud administrator, please find below the changes and known issues of ownCloud Server 10.0.3 that need your attention:

**The full ownCloud Server 10.0.3 changelog can be found here: https://github.com/owncloud/core/blob/stable10/CHANGELOG.md**

* It is now possible to directly upgrade from 8.2.11 to 10.0.3 in a single upgrade process.
* Added occ command to list routes which can help administrators setting up network firewall rules.
* 'occ upgrade' is now verbose by default. Administrators may need to adjust scripts for automated setup/upgrade procedures that rely on 'occ upgrade' outputs.

* Reenabled medial search by default
    * Enables partial search in sharing dialog autocompletion (e.g. a user wants to share with the user "Peter": Entering "pe" will find the user, entering "ter" will only find the user if the option is enabled)
    * New default is set to enabled as there is no performance impact anymore due to the introduction of the user account table in ownCloud Server 10.0.1.
    * Please check the setting. You need to disable it explicitly if the functionality is undesired.

* All database columns that use the fileid have been changed to bigint (64-bits). For large instances it is therefore highly recommended to upgrade in order to avoid reaching limits.

* Upgrade and Market app information
    * Removed "appstoreenabled" setting from config.php. If you want to disable the app store / Marketplace integration, please disable the Market app.
    * Added setting 'upgrade.automatic-app-update' to config.php to disable automatic app updates with 'occ upgrade' when Market app is enabled
    * On upgrade from OC < 10 the Market app won't be enabled if "appstoreenabled"  was false in config.php.

* Clustering: Better support of read only config file and apps folder
* Default minimum desktop client version in config.php is now 2.2.4.

**Known issues**

* Added quotes in boolean result values of yourdomain/status.php output
* Setting up SFTP external storages with keypairs does not work. https://github.com/owncloud/core/issues/28669
* If you have storage encryption enabled, the web UI for encryption will ask again what mode you want to operate with even if you already had a mode selected before. The administrator must select the mode they had selected before. https://github.com/owncloud/core/issues/28985
* Uploading a folder in Chrome in a way that would overwrite an existing folder can randomly fail (race conditions). https://github.com/owncloud/core/issues/28844
* Federated shares can not be accepted in WebUI for SAML/Shibboleth users
* For **MariaDB users**: Currently, Doctrine has no support for the breaking changes introduced in MariaDB 10.2.7, and above. If you are on MariaDB 10.2.7 or above, and have encountered the message "1067 Invalid default value for 'lastmodified'", `please apply this patch`_ to Doctrine. We expect this bug to be fixed in ownCloud 10.0.4. For more information on the bug, `check out the related issue`_.
* When updating from ownCloud < 9.0 the CLI output may hang for some time (potentially up to 20 minutes for big instances) whilst sharing is updated. This can happen in a variety of places during the upgrade and is to be expected. Please be patient as the update is performed and the output will continue as normal.

.. _10.0.1_release_notes_label:

Changes in 10.0.1
-----------------

Hello ownCloud administrator, please read carefully to be prepared for updates and operations of your ownCloud setup.

* **A new update path:** ownCloud 10.0.1 contains migration logic to allow upgrading directly from 9.0 to 10.0.1.
* **Marketplace:** Please create an account for `the new marketplace`_. 
  Access to optional ownCloud extensions and enterprise apps will be provided by the marketplace from now on.
  Currently some apps are still shipped with the tarballs / packages and will be moved to the marketplace in the near future.
* **Apps:** *LDAP*, *gallery*, *activity*, *PDF viewer*, and *text editor* were moved to the marketplace.
* **Updates with marketplace:** During the upgrade, enabled apps are also updated by fetching new versions directly from the marketplace. If during an update, sources for some apps are missing, and the ownCloud instance has no access to the marketplace, the administrator needs to disable these apps or manually download and provide the apps before updating.
* **App updates:** Third party apps are not disabled anymore when upgrading.
* **Upgrade migration test:** The upgrade migration test has been removed; see :ref:`migration_test_label`. (Option ``--skip-migration-tests`` removed from update command).

.. note::
   The template editor app is not included in the 10.0.1 release due to technical reasons, but will be distributed via the marketplace. However, you can still :ref:`edit template files manually <using_email_templates_label>`. 

Settings
~~~~~~~~

* **Settings design:** Admin, personal pages, and app management are now merged together into a single "Settings" entry.
* **Disable users:** The ability to disable users in the user management panel has been added.
* **Password Policy:** Rules now apply not only to link passwords but also to user passwords.

Infrastructure
~~~~~~~~~~~~~~

* **Client:** You need to update to `the latest desktop client version`_.
* **Cron jobs:** The user account table has been reworked. As a result the Cron job for `syncing user backends`_, e.g., LDAP, needs to be configured.
* **Logfiles:** App logs, e.g., auditing and owncloud.log, can now be split, see: https://doc.owncloud.org/server/latest/admin_manual/configuration/server/config_sample_php_parameters.html#logging.

Known Issues
~~~~~~~~~~~~

Converting the Database Type doesn't work
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Converting a Database from e.g. ``SQLite`` to ``MySQL`` or ``PostgreSQL`` with the ``occ db:convert-type`` currently doesn't work. See https://github.com/owncloud/core/issues/27075 for more info.

Installing the LDAP user backend will trigger the installation twice 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This causes an SQL error such as the following:

.. code-block:: console

   sudo -u www-data ./occ market:install user_ldap

   user_ldap: Installing new app ...
   user_ldap: An exception occurred while executing 'CREATE TABLE `ldap_user_mapping` (`ldap_dn` VARCHAR(255) DEFAULT '' NOT NULL, `owncloud_name` VARCHAR(255) DEFAULT '' NOT NULL, `directory_uuid` VARCHAR(255) DEFAULT '' NOT NULL, UNIQUE INDEX ldap_dn_users (`ldap_dn`), PRIMARY KEY(`owncloud_name`)) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin ENGINE = InnoDB ROW_FORMAT = compressed':

   SQLSTATE[42S01]: Base table or view already exists: 1050 Table 'ldap_user_mapping' already exists


This can be safely ignored. 
And the app can be used after enabling it. 
Please be aware that when upgrading an existing ownCloud installation that already has ``user_ldap`` this error will not occur.
It was fixed by https://github.com/owncloud/core/pull/27982.
However, this could happen for other apps as well that use ``database.xml``.
If it does please use the same workaround.

SAML authentication only works for users synced with ``occ user:sync``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We will re-enable SSO for LDAP users with an update of the app in the market after completing internal testing.

The web UI prevents uninstalling apps marked as shipped, e.g., ``user_ldap``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To uninstall, disable the app with occ and rm the app directory.

Moving files around in external storages outside of ownCloud will invalidate the metadata
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All shares, comments, and tags on the moved files will be lost.

Existing LDAP users only show up in the user management page and the share dialog after being synced
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The account table introduced in ownCloud 10.0.0 significantly reduces LDAP communication overhead. 
Password checks are yet to be accounted for. 
LDAP user metadata in the account table will be updated when users log in or when the administrator runs ``occ user:sync "OCA\User_LDAP\User_Proxy"``.
We recommend :ref:`setting up a nightly Cron job <cron_job_label>` to keep metadata of users not actively logging in up to date.

Error pages will not use the configured theme but will instead fall back to the community default
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _10.0.0_release_notes_label:

Changes in 10.0.0
-----------------

* PHP 7.1 support added (supported PHP versions are 5.6 and 7.0+)
* The upgrade migration test has been removed; see :ref:`migration_test_label`. (Option ``"--skip-migration-tests"`` removed from update command)
* Requires to use the latest desktop client version 2.3
* Third party apps are not disabled anymore when upgrading
* User account table has been reworked. CRON job for syncing with e.g. LDAP needs to be configured (see https://doc.owncloud.com/server/latest/admin_manual/configuration/server/occ_command.html#syncing-user-accounts)
* LDAP app is not released with ownCloud 10.0.0 and will be released on the marketplace after some more QA
* files_drop app is not shipped anymore as it's integrated with core now. Since migrations are not possible you will have to reconfigure your drop folders (in the 'Public Link' section of the sharing dialog of the respective folders).
* SAML/Shibboleth with device-specific app passwords: No migration possible; Users need to regenerate device-specific app passwords in the WebUI and enter those in their clients.
* For security reasons status.php can now be configured in config.php to not return server version information anymore ('version.hide'; default ‘false’). As clients still depend on version information this is not yet recommended. The default will change to 'true' with 10.0.2 once clients are ready.
* Order of owncloud.log entries changed a bit, please review any application (e.g. fail2ban rules) relying on this file
* External storages
    * FTP external storage moved to a separate app (https://marketplace.owncloud.com/apps/files_external_ftp)
    * "Local" storage type can now be disabled by sysadmin in config.php (to prevent users mounting the local file system)

Full changelog: https://github.com/owncloud/core/wiki/ownCloud-10.0-Features

.. _9.1_release_notes_label:

Changes in 9.1
--------------

**General**

* Background jobs (cron) can now run in parallel
* Update notifications in client via API - You can now be notified in your desktop client
  about available updates for core and apps. The notifications are made available via the
  notifications API.
* Multi-bucket support for primary objectstore integration
* Support for Internet Explorer below version 11 was dropped
* Symlinks pointing outside of the data directory are disallowed. Please use the :doc:`configuration/files/external_storage_configuration_gui`
  with the :doc:`configuration/files/external_storage/local` storage backend instead.
* Removed ``dav:migrate-calendars`` and ``dav:migrate-addressbooks`` commands for ``occ``.
  Users planning to upgrade from ownCloud 9.0 or below to ownCloud 9.1 needs to make sure that their
  calendars and address books are correctly migrated **before** continuing to upgrade to 9.1.

**Authentication**

* Pluggable authentication: plugin system that supports different authentication schemes
* Token-based authentication
* Ability to invalidate sessions
* List connected browsers/devices in the personal settings page. Allows the user to disconnect browsers/devices.
* Device-specific passwords/tokens, can be generated in the personal page and revoked
* Disable users and automatically revoke their sessions
* Detect disabled LDAP users or password changes and revoke their sessions
* Log in with email address
* Configuration option to enforce token-based login outside the web UI
* Two Factor authentication plug-in system
* OCC command added to (temporarily) disable/enable two-factor authentication for single users

.. note:: The current desktop and mobile client versions do not support two-factor yet, this
   will be added later. It is already possible to generate a device specific password and
   enter that in the current client versions.

**Files app**

* Ability to toggle displaying hidden files
* Remember sort order
* Permalinks for internal shares
* Visual cue when dragging in files app
* Autoscroll file list when dragging files
* Upload progress estimate

**Federated sharing**

* Ability to create federated shares with CRUDS permissions
* Resharing a federated share does not create a chain of shares any more but connects the
  share owner's server to the reshare recipient

**External storage**

* UTF-8 NFD encoding compatibility support for NFD file names stored directly on external
  storages (new mount option in external storage admin page)
* Direct links to the configuration pages for setting up a GDrive or Dropbox application for use with ownCloud
* Some performance and memory usage improvements for GDrive, stream download and chunk upload
* Performance and memory usage improvements for Dropbox with stream download
* GDrive library update provides exponential backoff which will reduce rate limit errors

**Shibboleth**

* The WebDAV endpoint was changed from ``/remote.php/webdav`` to ``/remote.php/dav``. You need to check your Apache configuration if you have exceptions or rules for WebDAV configured.

**Minor additions**

* Support for print style sheets
* Command line based update will now be suggested if the instance is bigger to avoid potential timeouts
* Web updater will be disabled if LDAP or shibboleth are installed
* DB/application update process now shows better progress information
* Added ``occ files:scan --unscanned`` to only scan folders that haven't yet been explored on external storages
* Chunk cache TTL can now be configured
* Added warning for wrongly configured database transactions, helps prevent "database is locked" issues
* Use a capped memory cache to reduce memory usage especially in background jobs and the file scanner
* Allow login by email
* Respect CLASS property in calendar events
* Allow addressbook export using VCFExportPlugin
* Birthdays are also generated based on shared addressbooks

**For developers**

* New DAV endpoint with a new chunking protocol aiming to solve many issues like timeouts (not used by clients yet)
* New webdav property for share permissions
* Background repair steps can be specified info.xml
* Background jobs (cron) can now be declared in info.xml
* Apps can now define repair steps to run at install/uninstall time
* Export contact images via Sabre DAV plugin
* Sabre DAV's browser plugin is available in debug mode to allow easier development around webdav

**Technical debt**

* PSR-4 autoloading forced for ``OC\`` and ``OCP\``, optional for ``OCA\`` docs at https://doc.owncloud.org/server/latest/developer_manual/app/classloader.html
* More cleanup of the sharing code (ongoing)

.. _9.0_release_notes_label:

Changes in 9.0
--------------

9.0 requires .ico files for favicons. This will change in 9.1, which will use .svg files. See `Changing favicon <https://doc.owncloud.org/server/latest/developer_manual/core/theming.html#changing-favicon>`_ in the Developer Manual.

Home folder rule is enforced in the user_ldap application in new ownCloud installations; see
:doc:`configuration/user/user_auth_ldap`. This affects ownCloud 8.0.10, 8.1.5 and 8.2.0 and up.

The Calendar and Contacts apps have been rewritten and the CalDAV and CardDAV backends of these
apps were merged into ownCloud core. During the upgrade existing Calendars and Addressbooks
are automatically migrated (except when using the ``IMAP user backend``). As a fallback
for failed upgrades, when using the ``IMAP user backend`` or as an option to test a migration
``dav:migrate-calendars`` and/or ``dav:migrate-addressbooks`` scripts are available
(**only in ownCloud 9.0**) via the ``occ`` command. See :doc:`configuration/server/occ_command`.

.. warning:: After upgrading to ownCloud 9.0 and **before** continuing to upgrade to 9.1 make sure
   that all of your and your users Calendars and Addressbooks are migrated correctly. Especially
   when using the ``IMAP user backend`` (other user backends might be also affected) you need to
   manually run the mentioned ``occ`` migration commands described above.

Updates on systems with large datasets will take longer, due to the addition of checksums to the
ownCloud database. See `<https://github.com/owncloud/core/issues/22747>`_.

Linux packages are available from our `official download repository <https://download.owncloud.org/download/repositories/stable/owncloud/>`_ .
New in 9.0: split packages. ``owncloud`` installs ownCloud plus dependencies, including Apache
and PHP. ``owncloud-files`` installs only ownCloud. This is useful for custom LAMP stacks, and
allows you to install your own LAMP apps and versions without packaging conflicts with ownCloud.
See :doc:`installation/linux_installation`.

New option for the ownCloud admin to enable or disable sharing on individual external mountpoints
(see :ref:`external_storage_mount_options_label`). Sharing on such mountpoints is disabled by default.

Enterprise 9.0
~~~~~~~~~~~~~~

owncloud-enterprise packages are no longer available for CentOS 6, RHEL6, 
Debian 7, or any version of Fedora. A new package, owncloud-enterprise-files, is available for all supported platforms, including the above. This new package comes without dependencies, and is installable on a larger number of platforms. System administrators must install their own LAMP stacks and databases. See https://owncloud.org/blog/time-to-upgrade-to-owncloud-9-0/

.. _8.2_release_notes_label:

Changes in 8.2
--------------

New location for Linux package repositories; ownCloud admins must manually 
change to the new repos. See :doc:`maintenance/upgrade`

PHP 5.6.11+ breaks the LDAP wizard with a 'Could not connect to LDAP' error. See https://github.com/owncloud/core/issues/20020. 

``filesystem_check_changes`` in ``config.php`` is set to 0 by default. This 
prevents unnecessary update checks and improves performance. If you are using 
external storage mounts such as NFS on a remote storage server, set this to 1 
so that ownCloud will detect remote file changes.

XSendFile support has been removed, so there is no longer support for `serving 
static files
<https://doc.owncloud.org/server/latest/admin_manual/configuration/files/
serving_static_files_configuration.html>`_ from your ownCloud server.

LDAP issue: 8.2 uses the ``memberof`` attribute by default. If this is not 
activated on your LDAP server your user groups will not be detected, and you 
will see this message in your ownCloud log: ``Error PHP Array to string 
conversion at /var/www/html/owncloud/lib/private/template/functions.php#36``. 
Fix this by disabling the ``memberof`` attribute on your ownCloud server with 
the ``occ`` command, like this example on Ubuntu Linux::

 sudo -u www-data php occ ldap:set-config "s01" useMemberOfToDetectMembership 0

 
Run ``sudo -u www-data php occ ldap:show-config`` to find the correct ``sNN`` 
value; if there is not one then use empty quotes, ``""``. (See 
:doc:`configuration/server/occ_command`.)

Users of the Linux Package need to update their repository setup as described
in this `blogpost <https://owncloud.org/blog/upgrading-to-owncloud-server-8-2/>`_.

.. _8.1_release_notes_label:

Changes in 8.1
--------------

Use APCu only if available in version 4.0.6 and higher. If you install an older version,
you will see a ``APCu below version 4.0.6 is installed, for stability and performance
reasons we recommend to update to a newer APCu version`` warning on your ownCloud admin page.

SMB external storage now based on ``php5-libsmbclient``, which must be downloaded 
from the ownCloud software repositories (`installation instructions 
<https://software.opensuse.org/download.html?project=isv%3AownCloud%3Acommunity% 
3A8.1&package=php5-libsmbclient>`_).

  
"Download from link" feature has been removed.

The ``.htaccess`` and ``index.html`` files in the ``data/`` directory are now 
updated after every update. If you make any modifications to these files they 
will be lost after updates.

The SabreDAV browser at ``/remote.php/webdav`` has been removed.

Using ownCloud without a ``trusted_domain`` configuration will not work anymore.

The logging format for failed logins has changed and considers now the proxy 
configuration in ``config.php``.

A default set of security and privacy HTTP headers have been added to the 
ownCloud ``.htaccess`` file, and ownCloud administrators may now customize which 
headers are sent.

More strict SSL certificate checking improves security but can result in
"cURL error 60: SSL certificate problem: unable to get local issuer certificate"
errors with certain broken PHP versions. Please verify your SSL setup, update your
PHP or contact your vendor if you receive these errors.

The persistent file-based cache (e.g. used by LDAP integration) has been dropped and 
replaced with a memory-only cache, which must be explicitly configured. See 
:doc:`configuration/user/user_auth_ldap`. Memory cache configuration for the 
ownCloud server is no longer automatic, requiring installation of 
your desired cache backend and configuration in 
``config.php`` (see :doc:`configuration/server/caching_configuration`.) 

The ``OC_User_HTTP`` backend has been removed. Administrators are encouraged to use 
the ``user_webdavauth`` application instead.

ownCloud ships now with its own root certificate bundle derived from Mozilla's 
root certificates file. The system root certificate bundle will not be used 
anymore for most requests.

  
When you upgrade from ownCloud 8.0, with encryption enabled, to 8.1, you must 
enable the new encryption backend and migrate your encryption keys. See 
:ref:`occ_encryption_label`.

Encryption can no longer be disabled in ownCloud 8.1. It is planned to re-add
this feature to the command line client for a future release.

It is not recommended to upgrade encryption-enabled systems from ownCloud Server 8.0
to version 8.1.0 as there is a chance the migration will break. We recommend 
migrating to the first bugfix release, ownCloud Server 8.1.1.

Due to various technical issues, by default desktop sync clients older than 
1.7 are not allowed to connect and sync with the ownCloud server. This is 
configurable via the ``minimum.supported.desktop.version`` switch in 
``config.php``.

Previews are now generated at a maximum size of 2048 x 2048 pixels. This is configurable
via the ``preview_max_x`` and ``preview_max_y`` switches in ``config.php``.

The ownCloud 8 server is not supported on any version of Windows.

The 8.1.0 release has a minor bug which makes application updates fail at first try. Reload the
apps page and try again, and the update will succeed.

The ``forcessl`` option within the ``config.php`` and the ``Enforce SSL`` option 
within the Admin-Backend was removed. This now needs to be configured like 
described in :ref:`use_https_label`.

WebDAV file locking was removed in ownCloud 8.1 which causes Finder on Mac OS X to mount WebDAV read-only.

Enterprise 8.1 
~~~~~~~~~~~~~~

The SharePoint Drive application does not verify the SSL certificate of the SharePoint 
server or the ownCloud server, as it is expected that both devices are in the 
same trusted environment.

.. _8.0_release_notes_label:

Changes in 8.0
--------------

Manual LDAP Port Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you are configuring the LDAP user and group backend application, ownCloud 
may not auto-detect the LDAP server's port number, so you will need to enter it 
manually.

.. https://github.com/owncloud/core/pull/16748

No Preview Icon on Text Files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There is no preview icon displayed for text files when the file contains fewer than six characters.

.. https://github.com/owncloud/core/issues/16556#event-316503097

Remote Federated Cloud Share Cannot be Reshared With Local Users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you mount a Federated Cloud share from a remote ownCloud server, you cannot re-share it with
your local ownCloud users. (See :doc:`configuration/files/federated_cloud_sharing_configuration` 
to learn more about federated cloud sharing)

Manually Migrate Encryption Keys after Upgrade
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are using the Encryption application and upgrading from older versions of 
ownCloud to ownCloud 8.0, you must manually migrate your encryption keys.
See :ref:`occ_encryption_label`.

Windows Server Not Supported
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Windows Server is not supported in ownCloud 8.

PHP 5.3 Support Dropped
~~~~~~~~~~~~~~~~~~~~~~~

PHP 5.3 is not supported in ownCloud 8, and PHP 5.4 or better is required.

Disable Apache Multiviews
~~~~~~~~~~~~~~~~~~~~~~~~~

If Multiviews are enabled in your Apache configuration, this may cause problems 
with content negotiation, so disable Multiviews by removing it from your Apache 
configuration. Look for lines like this:: 

 <Directory /var/www/owncloud>
 Options Indexes FollowSymLinks Multiviews

 
Delete ``Multiviews`` and restart Apache.

.. https://github.com/owncloud/core/issues/9039

ownCloud Does Not Follow Symlinks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ownCloud's file scanner does not follow symlinks, which could lead to 
infinite loops. To avoid this do not use soft or hard links in your ownCloud 
data directory.

.. https://github.com/owncloud/core/issues/8976

No Commas in Group Names
~~~~~~~~~~~~~~~~~~~~~~~~

Creating an ownCloud group with a comma in the group name causes ownCloud to 
treat the group as two groups.

.. https://github.com/owncloud/core/issues/10983

Hebrew File Names Too Large on Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On Windows servers Hebrew file names grow to five times their original size 
after being translated to Unicode.

.. https://github.com/owncloud/core/issues/8938

Google Drive Large Files Fail with 500 Error
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Google Drive tries to download the entire file into memory, then write it to a 
temp file, and then stream it to the client, so very large file downloads from 
Google Drive may fail with a 500 internal server error.

.. https://github.com/owncloud/core/issues/8810

Encrypting Large Numbers of Files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you activate the Encryption application on a running server that has large numbers 
of files, it is possible that you will experience timeouts. It is best to 
activate encryption at installation, before accumulating large numbers of files 
on your ownCloud server.

.. https://github.com/owncloud/core/issues/10657


Enterprise 8.0
~~~~~~~~~~~~~~

Sharepoint Drive SSL Not Verified
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The SharePoint Drive application does not verify the SSL certificate of the SharePoint 
server or the ownCloud server, as it is expected that both devices are in the 
same trusted environment.

No Federated Cloud Sharing with Shibboleth
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Federated Cloud Sharing (formerly Server-to-Server file sharing)does not work 
with Shibboleth .

.. https://github.com/owncloud/user_shibboleth/issues/28

Direct Uploads to SWIFT do not Appear in ownCloud
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When files are uploaded directly to a SWIFT share mounted as external storage 
in ownCloud, the files do not appear in ownCloud. However, files uploaded to 
the SWIFT mount through ownCloud are listed correctly in both locations.

.. https://github.com/owncloud/core/issues/8633

SWIFT Objectstore Incompatible with Encryption App
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The current SWIFT implementation is incompatible with any application that uses direct 
file I/O and circumvents the ownCloud virtual filesystem. Using the Encryption 
application on a SWIFT object store incurs twice as many HTTP requests and increases 
latency significantly.

.. https://github.com/owncloud/core/issues/10900

application Store is Back
^^^^^^^^^^^^^^^^^^^^^^^^^

The ownCloud application Store has been re-enabled in ownCloud 8. Note that third-party apps 
are not supported.

.. _7.0_release_notes_label:

Changes in 7.0
--------------

Manual LDAP Port Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you are configuring the LDAP user and group backend application, ownCloud 
may not auto-detect the LDAP server's port number, so you will need to enter it 
manually.

.. https://github.com/owncloud/core/pull/16748

LDAP Search Performance Improved
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Prior to 7.0.4, LDAP searches were substring-based and would match search 
attributes if the substring occurred anywhere in the attribute value. Rather, 
searches are performed on beginning attributes. With 7.0.4, searches will match 
at the beginning of the attribute value only. This provides better performance 
and a better user experience.

Substring searches can still be performed by prepending the search term with 
"*".For example, a search for ``te`` will find Terri, but not Nate::

 
 occ ldap:search "te"

If you want to broaden the search to include 
Nate, then search for ``*te``::

 occ ldap:search "*te"

Refine searches by adjusting the ``User Search Attributes`` field of the 
Advanced tab in your LDAP configuration on the Admin page. For example, if your 
search attributes are ``givenName`` and ``sn`` you can find users by first name 
+ last name very quickly. For example, you'll find Terri Hanson by searching for 
``te ha``. Trailing whitespaces are ignored.

.. https://github.com/owncloud/core/issues/12647

Protecting ownCloud on IIS from Data Loss
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Under certain circumstances, running your ownCloud server on IIS could be at 
risk of data loss. To prevent this, follow these steps.

* In your ownCloud server configuration file, ``owncloud\config\config.php``, set 
  ``config_is_read_only`` to true.
* Set the ``config.php`` file to read-only.
* When you make server updates ``config.php`` must be made writeable. When your 
  updates are completed re-set it to read-only.

Antivirus Application Modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Antivirus application offers three modes for running the ClamAV anti-virus scanner: 
as a daemon on the ownCloud server, a daemon on a remote server, or an 
executable mode that calls ``clamscan`` on the local server. We recommend using 
one of the daemon modes, as they are the most reliable.

"Enable Only for Specific Groups" Fails
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some ownCloud applications have the option to be enabled only for certain 
groups. However, when you select specific groups they do not get access to the 
app.

Changes to File Previews
~~~~~~~~~~~~~~~~~~~~~~~~

For security and performance reasons, file previews are available only for 
image files, covers of MP3 files, and text files, and have been disabled for 
all other filetypes. Files without previews are represented by generic icons 
according to their file types. 

4GB Limit on SFTP Transfers
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Because of limitations in ``phpseclib``, you cannot upload files larger than 
4GB over SFTP.

"Not Enough Space Available" on File Upload
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Setting user quotas to ``unlimited`` on an ownCloud installation that has 
unreliable free disk space reporting-- for example, on a shared hosting 
provider-- may cause file uploads to fail with a "Not Enough Space Available" 
error. A workaround is to set file quotas for all users instead of 
``unlimited``.

No More Expiration Date On Local Shares
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In older versions of ownCloud, you could set an expiration date on both local 
and public shares. Now you can set an expiration date only on public shares, 
and local shares do not expire when public shares expire.

Zero Quota Not Read-Only
~~~~~~~~~~~~~~~~~~~~~~~~

Setting a user's storage quota should be the equivalent of read-only, however, 
users can still create empty files.

Enterprise 7.0
~~~~~~~~~~~~~~

No Federated Cloud Sharing with Shibboleth
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Federated Cloud Sharing (formerly Server-to-Server file sharing) does not work 
with Shibboleth .

Windows Network Drive
^^^^^^^^^^^^^^^^^^^^^
Windows Network Drive runs only on Linux servers because it requires the Samba 
client, which is included in all Linux distributions. 

``php5-libsmbclient`` is also required, and there may be issues with older 
versions of ``libsmbclient``; see Using External Storage > Installing and 
Configuring the Windows Network Drive application in the Enterprise Admin manual for 
more information. 

By default CentOS has activated SELinux, and the ``httpd`` process can not make 
outgoing network connections. This will cause problems with curl, LDAP and samba 
libraries. Again, see Using External Storage > Installing and Configuring the 
Windows Network Drive application in the Enterprise Admin manual for instructions.

Sharepoint Drive SSL
^^^^^^^^^^^^^^^^^^^^

The SharePoint Drive application does not verify the SSL certificate of the SharePoint 
server or the ownCloud server, as it is expected that both devices are in the 
same trusted environment.

Shibboleth and WebDAV Incompatible
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Shibboleth and standard WebDAV are incompatible, and cannot be used together in 
ownCloud. If Shibboleth is enabled, the ownCloud client uses an extended WebDAV 
protocol

No SQLite
^^^^^^^^^

SQLite is no longer an installation option for ownCloud Enterprise Edition, as 
it not suitable for multiple-user installations or managing large numbers of 
files.

No Application Store
^^^^^^^^^^^^^^^^^^^^

The application Store is disabled for the Enterprise Edition.

LDAP Home Connector Linux Only
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The LDAP Home Connector application requires Linux (with MySQL, MariaDB, 
or PostgreSQL) to operate correctly.

.. Links

   
.. _the latest desktop client version: https://doc.owncloud.com/desktop/latest/
.. _syncing user backends: configuration/server/occ_command.html#syncing-user-accounts
.. _the new marketplace: https://marketplace.owncloud.com
.. _Open Build Service: https://download.owncloud.org/download/repositories/10.0/owncloud/
.. _please apply this patch: https://gist.github.com/VicDeo/bb0689104baeb5ad2371d3fdb1a013ac/raw/04bb98e08719a04322ea883bcce7c3e778e3afe1/DoctrineMariaDB102.patch
.. _check out the related issue: https://github.com/owncloud/core/issues/28695
.. _the full ownCloud Server 10.0.4 changelog: https://github.com/owncloud/core/blob/stable10/CHANGELOG.md
.. _the full ownCloud Server changelog: https://owncloud.org/changelog/server/
.. _the occ command's files:scan --repair documentation: https://doc.owncloud.com/server/latest/admin_manual/configuration/server/occ_command.html?highlight=occ#the-repair-option
.. _the config_sample_php_parameters documentation: https://doc.owncloud.com/server/latest/admin_manual/configuration/server/config_sample_php_parameters.html#mode-of-operation
.. _the background jobs configuration documentation: https://doc.owncloud.com/server/latest/admin_manual/configuration/server/background_jobs_configuration.html#cleanupchunks
.. _Objectstore: https://marketplace.owncloud.com/apps/objectstore
.. _the OpenStack SWIFT protocol: https://www.openstack.org/swift
.. _the S3 protocol: https://www.amazon.com/documentation/s3
.. _repository on GitHub: https://github.com/owncloud/theme-example
.. _the ownCloud Ransomware Protection: https://marketplace.owncloud.com/apps/ransomware_protection
.. _the ownCloud Marketplace: https://marketplace.owncloud.com
.. _the ownCloud documentation: https://doc.owncloud.com/server/latest/admin_manual/configuration/server/security/password_policy.html
.. _"Password Expiration": https://doc.owncloud.com/server/latest/admin_manual/release_notes.html#the-password-policy-extension
.. _#32059: https://github.com/owncloud/core/issues/32059
.. _#66: https://github.com/owncloud/password_policy/issues/66
