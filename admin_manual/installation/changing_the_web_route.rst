======================
Changing the Web Route
======================

This admin manual assumes that the owncloud server shall be accessible under the web route
``/owncloud`` -- this is also where the Linux packages make the server appear. You can change this in your Web server configuration, for example from ``https://example.com/owncloud/`` to ``https://example.com/``.

Basic system administrator and Apache configuration knowledge is prerequisite.
Several configuration files need to be kept in sync when changing the Web route location.

On an Ubuntu-14.04 system the following files are typically involved:

- ``/etc/apache2/conf-enabled/owncloud.conf``
- ``/var/www/owncloud/config/config.php``
- ``/var/www/owncloud/.htaccess``

Example: Moving from /owncloud to /
-----------------------------------

    Edit the file /etc/apache2/conf-enabled/owncloud.conf to say::

      Alias / "/var/www/owncloud/"

    Edit /var/www/owncloud/config/config.php to say::

      'overwrite.cli.url' => 'http://localhost/',

    Edit the file /var/www/owncloud/.htaccess to say::

      ...
      #### DO NOT CHANGE ANYTHING ABOVE THIS LINE ####
      ...
      <IfModule mod_rewrite.c>
        RewriteBase /
      ...
    

    Optionally also set your document root, though this is generally not needed or recommended.
    Edit the file ``/etc/apache2/sites-enabled/000-default.conf to say``::

      DocumentRoot /var/www/owncloud

.. Note:: Since owncloud version 9.0.2 we support short URLs without ``index.php``. The rewrite mechanisms
  involved a RewriteBase rule in ``.htaccess`` which is auto-generated when
  owncloud is first started. Depending on the exact way owncloud was installed (upgrade or fresh,
  plain tar archive, or packages) you may or may not find a RewriteBase in your ``.htaccess`` files.
  If it is not yet there, make sure to double check once the ownCloud server is up and running.

