==========================
Configuration Notes & Tips
==========================

.. _selinux_tips_label:

SELinux
^^^^^^^

See :doc:`selinux_configuration` for a suggested configuration for 
SELinux-enabled distributions such as Fedora and CentOS.

.. _php_ini_tips_label:

php.ini
^^^^^^^

Several core PHP settings have to be configured correctly, otherwise ownCloud may
not work properly. Known settings causing issues are listed here. Please note that
there might be other settings causing unwanted behaviours. In general it is recommended
to keep the ``php.ini`` at their defaults.

session.auto_start && enable_post_data_reading
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure that `session.auto_start`_ is set to ``0`` or ``Off`` and `enable_post_data_reading`_
to ``1`` or ``On`` in your configuration. If not, you may have issues logging in
to ownCloud via the WebUI, where you see the error: "*Access denied. CSRF check
failed*".

session.save_path
~~~~~~~~~~~~~~~~~

In addition to setting ``session.auto_start`` and ``enable_post_data_reading`` correctly, ensure that, if ``session.save_handler`` is set to ``files``, that ``session.save_path`` is set to a path on the filesystem which **only** the web server process (or process which PHP is running as) can read from and write to.
   
This is especially important if your ownCloud installation is using a shared-hosting arrangement.
In these situations, `session poisoning`_ can occur if all of the session files are stored in the same location. 
Session poisoning is where one web application can manipulate data in the ``$_SESSION`` superglobal array of another. 

When this happens, the original application has no way of knowing that this corruption has occurred and may not treat the data with any sense of suspicion. 
You can `read through a thorough discussion of local session poisoning`_ if you'd like to know more.

suhosin.session.cryptkey
~~~~~~~~~~~~~~~~~~~~~~~~

When `suhosin.session.cryptkey`_ is enabled, session data will be transparently encrypted. 
If enabled, there is less of a concern in storing application session files in the same location, as discussed in session.save_path. 
Ideally, however, session files for each application should always be stored in a location specific to that application, and never stored collectively with any other.

.. note::
   This is only relevant if you’re using PHP 5.x.

post_max_size  
~~~~~~~~~~~~~

Please ensure that you have ``post_max_size`` configured with *at least* the minimum 
amount of memory for use with ownCloud, which is 512 MB. 

.. IMPORTANT::
   Please be careful when you set this value if you use the byte value shortcut as it is very specific.  
   Use `K` for kilobyte, `M` for megabyte and `G` for gigabyte. `KB`, `MB`, and `GB` **do not work!**

.. NOTE::
   Keep in mind that changes to ``php.ini`` may have to be configured in more
   than one ini file. This can be the case, for example, for the
   ``date.timezone`` setting.

php.ini - Used by the Web server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   /etc/php5/apache2/php.ini
 or
   /etc/php5/fpm/php.ini
 or ...

php.ini - used by the php-cli and so by ownCloud CRON jobs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  /etc/php5/cli/php.ini


.. _php_fpm_tips_label:

PHP-FPM
^^^^^^^

System Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you are using ``php-fpm``, system environment variables like 
``PATH``, ``TMP`` or others are not automatically populated in the same way as 
when using ``php-cli``. A PHP call like ``getenv('PATH');`` can therefore 
return an empty result. So you may need to manually configure environment 
variables in the appropriate ``php-fpm`` ini/config file. 

Here are some example root paths for these ini/config files:

+--------------------+-----------------------+
| Ubuntu/Mint        | CentOS/Red Hat/Fedora |
+--------------------+-----------------------+ 
| ``/etc/php5/fpm/`` | ``/etc/php-fpm.d/``   |
+--------------------+-----------------------+ 

In both examples, the ``ini/config`` file is called ``www.conf``, and depending
on the distribution or customizations which you have made, it may be in
a sub-directory.

Usually, you will find some or all of the environment variables 
already in the file, but commented out like this::

	;env[HOSTNAME] = $HOSTNAME
	;env[PATH] = /usr/local/bin:/usr/bin:/bin
	;env[TMP] = /tmp
	;env[TMPDIR] = /tmp
	;env[TEMP] = /tmp

Uncomment the appropriate existing entries. Then run ``printenv PATH`` to 
confirm your paths, for example::

        $ printenv PATH
        /home/user/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:
        /sbin:/bin:/

If any of your system environment variables are not present in the file then 
you must add them.

When you are using shared hosting or a control panel to manage your ownCloud
virtual machine or server, the configuration files are almost certain to be
located somewhere else, for security and flexibility reasons, so check your
documentation for the correct locations.

Please keep in mind that it is possible to create different settings for 
``php-cli`` and ``php-fpm``, and for different domains and Web sites. 
The best way to check your settings is with :ref:`label-phpinfo`.

Maximum Upload Size
~~~~~~~~~~~~~~~~~~~

If you want to increase the maximum upload size, you will also have to modify 
your ``php-fpm`` configuration and increase the ``upload_max_filesize`` and 
``post_max_size`` values. You will need to restart ``php5-fpm`` and your HTTP 
server in order for these changes to be applied.

.htaccess Notes for Apache
~~~~~~~~~~~~~~~~~~~~~~~~~~

ownCloud comes with its own ``owncloud/.htaccess`` file. Because ``php-fpm`` can't 
read PHP settings in ``.htaccess`` these settings and permissions must be set
in the ``owncloud/.user.ini`` file.

No basic authentication headers were found
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This error is shown in your ``data/owncloud.log`` file. 
Some Apache modules like ``mod_fastcgi``, ``mod_fcgid`` or ``mod_proxy_fcgi`` are not passing the needed authentication headers to PHP and so the login to ownCloud via WebDAV, CalDAV and CardDAV clients is failing. 
Information on how to correctly configure your environment can be found `in the forums`_ but we generally recommend against the use of these modules and recommend mod_php instead.

.. _other_http_servers_label:

Other Web Servers
^^^^^^^^^^^^^^^^^

- `Other HTTP servers <https://github.com/owncloud/documentation/wiki/Alternate-Web-server-notes>`_
- `Univention Corporate Server installation <https://github.com/owncloud/documentation/wiki/UCS-Installation>`_

.. Links
 
.. _in the forums: https://central.owncloud.org/t/no-basic-authentication-headers-were-found-message/819
.. _session.auto_start: https://secure.php.net/manual/en/session.configuration.php#ini.session.auto-start
.. _enable_post_data_reading: https://secure.php.net/manual/en/ini.core.php#ini.enable-post-data-reading
.. _session.save_handler: http://php.net/manual/en/session.configuration.php#ini.session.save-handler
.. _session poisoning: https://en.wikipedia.org/wiki/Session_poisoning
.. _read through a thorough discussion of local session poisoning: http://ha.xxor.se/2011/09/local-session-poisoning-in-php-part-1.html
.. _suhosin.session.cryptkey: https://suhosin.org/stories/configuration.html#suhosin-session-cryptkey
