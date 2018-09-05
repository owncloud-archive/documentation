==========================
Apps Config.php Parameters
==========================

This document describes parameters for apps maintained by ownCloud that are
not part of the core system.

.. important:: All keys are only valid if the corresponding app is installed and enabled.
   You must copy the keys needed to the active ``config.php`` file.
 
Multiple configuration files
----------------------------

ownCloud supports loading configuration parameters from multiple files.
You can add arbitrary files ending with `.config.php` in the `config/` directory.

Example:

You could place your email server configuration in ``email.config.php``. 

This allows you to easily create and manage custom configurations, or to divide a 
large complex configuration file into a set of smaller files. 

.. note:: These custom files are not overwritten by ownCloud, 
   and the values in these files take precedence over ``config.php``.

.. important:: ownCloud may write configurations into ``config.php``.
   These configurations may conflict with identical keys already set in additional config files.
   Be careful when using this capability!

.. The following section is auto-generated from 
.. https://github.com/owncloud/core/blob/master/config/config.sample.php
.. Do not edit the content of this file between _section_start and _sections_end
.. The content there will be loaded and replaced via script from the source file from the link above
.. Any configuration changes done in this file will be overwritten on the next update
.. You can of course change the common description above this text which will then be part of the next update

.. DEFAULT_SECTION_START


App: Activity
-------------

Possible values: ``activity_expire_days`` days


::

	'activity_expire_days' => 365,

Retention for activities of the activity app

.. DEFAULT_SECTION_END
.. Generated content above. Don't change this.


.. Generated content below. Don't change this.
.. ALL_OTHER_SECTIONS_START


App: LDAP
---------

Possible values: ``ldapIgnoreNamingRules`` 'doSet' or false

Possible values: ``user_ldap.enable_medial_search`` true or false


::

	'ldapIgnoreNamingRules' => false,
	'user_ldap.enable_medial_search' => false,



App: Market
-----------

Possible values: ``appstoreurl`` URL


::

	'appstoreurl' => 'https://marketplace.owncloud.com',

Configuring the download URL for apps

App: Firstrunwizard
-------------------

Possible values: ``customclient_desktop`` URL

Possible values: ``customclient_android`` URL

Possible values: ``customclient_ios`` URL


::

	'customclient_desktop' =>
		'https://owncloud.org/install/#install-clients',
	'customclient_android' =>
		'https://play.google.com/store/apps/details?id=com.owncloud.android',
	'customclient_ios' =>
		'https://itunes.apple.com/us/app/owncloud/id543672169?mt=8',

Configuring the download links for ownCloud clients,
as seen in the first-run wizard and on Personal pages

App: Richdocuments
------------------

Possible values: ``collabora_group`` string


::

	'collabora_group' => '',

Configuring the group name for users allowed to use collabora

.. ALL_OTHER_SECTIONS_END
.. Generated content above. Don't change this.

