==========================
Changing Your ownCloud URL
==========================

This admin manual assumes that the ownCloud server is already accessible under the Web route
``/owncloud``, which is the default at installation, e.g. ``https://example.com/owncloud``. You can change this in your Web server configuration, for example from ``https://example.com/owncloud/`` to ``https://example.com/``. 

On Debian/Ubuntu Linux edit these files:

- ``/etc/apache2/sites-enabled/owncloud.conf``
- ``/var/www/owncloud/config/config.php``

Edit the ``Alias`` in ``/etc/apache2/sites-enabled/owncloud.conf`` to alias your ownCloud directory to the Web server root::
 
 Alias / "/var/www/owncloud/"

Edit the ``overwrite.cli.url`` parameter in ``/var/www/owncloud/config/config.php``::

 'overwrite.cli.url' => 'http://localhost/',
 
Restart Apache, and now you can access ownCloud from either ``https://example.com/`` or ``https://localhost/``. Note that you will not be able to run any other virtual hosts, as ownCloud is aliased to your Web root.

On CentOS/Fedora/Red Hat, edit ``/etc/httpd/conf.d/owncloud.conf`` and ``/var/www/html/owncloud/config/config.php``, then restart Apache.