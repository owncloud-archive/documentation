====================================
Upgrade PHP on RedHat 7 and Centos 7
====================================

You should, almost, always upgrade to the latest version of PHP, if and where possible. 
And if you're on a version of PHP older than 5.6 you need to upgrade.
This guide steps you through upgrading your installation of PHP to version 5.6 or 7.0 if you're on RedHat or Centos 7.

- :ref:`upgrade_to_version_56_label`
- :ref:`upgrade_to_version_7_label`

.. _upgrade_to_version_56_label:

Upgrade PHP to version 5.6
--------------------------

.. note::
   You should really be upgrading to PHP 7, as version 5.6 is `no longer actively supported`_, and security support ends on 31 Dec, 2018. 

You will first need to subscribe to the Red Hat Software Collections channel repository to be able to download and install the PHP 5.6 package in RHEL 7.
To do that, run the following command:

.. code-block:: console
   
   subscription-manager repos --enable rhel-server-rhscl-7-rpms

.. note:: 
   To know more about registering and subscribing a system to the Red Hat Customer Portal using the Red Hat Subscription-Manager, please refer to `the official documentation`_. 

When that's completed, then proceed by installing PHP 5.6, along with `the other required PHP packages`.

.. code-block:: console

   yum install rh-php56 rh-php56-php rh-php56-php-gd rh-php56-php-mbstring rh-php56-php-mysqlnd rh-php56-php-intl rh-php56-php-ldap

Once they're all installed, you next need to enable PHP 5.6 system-wide.
To do this, run the following command:

.. code-block:: console

   cp /opt/rh/rh-php56/enable /etc/profile.d/rh-php56.sh source /opt/rh/rh-php56/enable

With PHP 5.6 enabled system-wide, you next need to disable the loading the previous version of PHP 5.4. 
For this example, we'll assume that you're upgrading from PHP 5.4.
Here, you disable it from loading by renaming it's Apache configuration files.

.. code-block:: console

   mv /etc/httpd/conf.d/php.conf /etc/httpd/conf.d/php54.off
   mv /etc/httpd/conf.modules.d/10-php.conf /etc/httpd/conf.modules.d/10-php54.off

.. note::
   You could also delete the files if you prefer.

Next, you need to enable loading of the PHP 5.6 Apache shared-object file.
This you do by copying the shared object along with its two Apache configuration
files, as in the command below.

.. code-block:: console

   cp /opt/rh/httpd24/root/etc/httpd/conf.d/rh-php56-php.conf /etc/httpd/conf.d/
   cp /opt/rh/httpd24/root/etc/httpd/conf.modules.d/10-rh-php56-php.conf /etc/httpd/conf.modules.d/
   cp /opt/rh/httpd24/root/etc/httpd/modules/librh-php56-php5.so /etc/httpd/modules/

With all that done, you lastly need to restart Apache.

.. code-block:: console

   service httpd restart

.. _upgrade_to_version_7_label:

Upgrade PHP to version 7.0
--------------------------

As with :ref:`upgrading to PHP 5.6 <upgrade_to_version_56_label>`, to upgrade to PHP 7 you will first need to subscribe to the Red Hat Software Collections channel repository to download and install the PHP 7 package in RHEL 7 (if you've not done this already).
This uses the same command as you will find there. 

.. note:: This section assumes that you're upgrading from PHP 5.6.

Then, proceed by installing the required PHP 7 modules. 
You can use the command below to save you time.

.. code-block:: console

   yum install rh-php70 rh-php70-php rh-php70-php-gd rh-php70-php-mbstring rh-php70-php-mysqlnd rh-php70-php-intl rh-php70-php-ldap

Next, you need to enable PHP 7 and disable PHP 5.6 system-wide.
To enable PHP 7 system-wide, run the following command:

.. code-block:: console

   cp /opt/rh/rh-php70/enable /etc/profile.d/rh-php70.sh source /opt/rh/rh-php70/enable

Then, you need to disable loading of the PHP 5.6 Apache modules.
You can do this either by changing their names, as in the example below, or deleting the files.

.. code-block:: console

   mv /etc/httpd/conf.d/php.conf /etc/httpd/conf.d/php56.off
   mv /etc/httpd/conf.modules.d/10-php.conf /etc/httpd/conf.modules.d/10-php56.off

With that done, you next need to copy the PHP 7 Apache modules into place; that being the two Apache configuration files and the shared object file.

.. code-block:: console

   cp /opt/rh/httpd24/root/etc/httpd/conf.d/rh-php70-php.conf /etc/httpd/conf.d/
   cp /opt/rh/httpd24/root/etc/httpd/conf.modules.d/15-rh-php70-php.conf /etc/httpd/conf.modules.d/
   cp /opt/rh/httpd24/root/etc/httpd/modules/librh-php70-php7.so /etc/httpd/modules/

Finally, you need to restart Apache to make the changes permanent, as in the command below.

.. code-block:: console

   service httpd restart

.. Links
   
.. _no longer actively supported: https://secure.php.net/supported-versions.php
.. _from Oracle: http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
.. _the official documentation: https://access.redhat.com/solutions/253273
.. _the other required PHP packages: https://doc.owncloud.org/server/latest/admin_manual/installation/source_installation.html#prerequisites-label
.. _the Redis client extension: https://github.com/phpredis/phpredis/
.. _the APCu extension: https://secure.php.net/manual/en/book.apcu.php
.. _the Memcached extension: https://secure.php.net/manual/en/book.memcached.php
