Enable index.php-less URLs
==========================

Since ownCloud 9.0.3 you need to explicitly configure and enable index.php-less URLs
(e.g. https://example.com/apps/files/ instead of https://example.com/index.php/apps/files/).
The following documentation provides the needed steps to configure this for the ``Apache``
Web server.

Prerequisites
-------------

Before being able to use index.php-less URLs you need to enable the ``mod_rewrite`` and
``mod_env`` Apache modules. Furthermore a configured ``AllowOverride All`` directive
within the vhost of your Web server is needed. Please have a look at the ``Apache`` manual
for how to enable and configure these.

Furthermore these instructions are only working when using Apache together with the ``mod_php``
Apache module for PHP. Other modules like ``php-fpm`` or ``mod_fastcgi`` are unsupported.

Finally the user running your Web server (e.g. ``www-data``) needs to be able to write into the
``.htaccess`` file shipped within the ownCloud root directory (e.g. ``/var/www/owncloud/.htaccess``).
If you have applied :ref:`strong_perms_label` the user might be unable to write into this
file and the needed update will fail. You need to revert this strong permissions temporarily by
following the steps described in :ref:`set_updating_permissions_label`.

Configuration steps
-------------------

The first step is to configure the ``overwrite.cli.url`` and ``htaccess.RewriteBase``
config.php options (See :doc:`config_sample_php_parameters`). If you're accessing
your ownCloud instance via ``https://example.com/`` the following two options need
to be added / configured::

 'overwrite.cli.url' => 'https://example.com',
 'htaccess.RewriteBase' => '/',

If the instance is accessed via ``https://example.com/owncloud`` the following
configuration is needed::

 'overwrite.cli.url' => 'https://example.com/owncloud',
 'htaccess.RewriteBase' => '/owncloud',

As a second step ownCloud needs to enable index.php-less URLs. This is done:

* during the next update of your ownCloud instance
* by manually running the occ command ``occ maintenance:update:htaccess`` (See :doc:`occ_command`)

Afterwards your instance should have index.php-less URLs enabled.

Troubleshooting
---------------

If accessing your ownCloud installation fails after following these instructions and you see
messages like this in your ownCloud log::

 The requested uri(\\/login) cannot be processed by the script '\\/owncloud\\/index.php'

make sure that you have configured the two ``config.php`` options listed above correctly.
