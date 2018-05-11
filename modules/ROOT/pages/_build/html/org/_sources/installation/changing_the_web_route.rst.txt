==========================
Changing Your ownCloud URL
==========================

This admin manual assumes that the ownCloud server is already accessible under the route ``/owncloud`` (which is the default, e.g. ``https://example.com/owncloud``). 
If you like, you can change this in your web server configuration, for example by changing it from ``https://example.com/owncloud/`` to ``https://example.com/``. 

To do so on Debian/Ubuntu Linux, you need to edit these files:

- ``/etc/apache2/sites-enabled/owncloud.conf``
- ``/var/www/owncloud/config/config.php``

Edit the ``Alias`` directive in ``/etc/apache2/sites-enabled/owncloud.conf`` to alias your ownCloud directory to the Web server root::
 
 Alias / "/var/www/owncloud/"

Edit the ``overwrite.cli.url`` parameter in ``/var/www/owncloud/config/config.php``::

 'overwrite.cli.url' => 'http://localhost/',
 
When the changes have been made and the file saved, restart Apache. 
Now you can access ownCloud from either ``https://example.com/`` or ``https://localhost/``. 

.. note::
   Note that you will not be able to run any other virtual hosts, as ownCloud is aliased to your web root.
   On CentOS/Fedora/Red Hat, edit ``/etc/httpd/conf.d/owncloud.conf`` and ``/var/www/html/owncloud/config/config.php``, then restart Apache.
