Uploading big files > 512MB (as set by default)
===============================================

The default maximum file size for uploads is 512MB. You can increase this 
limit up to what your filesystem and operating system allows. There are certain 
hard limits that cannot be exceeded:

* < 2GB on 32Bit OS-architecture
* < 2GB with Server Version 4.5 or older
* < 2GB with IE6 - IE8
* < 4GB with IE9 - IE10

64-bit filesystems have much higher limits; consult the documentation for your 
filesystem.

System Configuration
--------------------

* Make sure that the latest version of PHP (at least 5.4.9) is installed
* Disable user quotas, which makes them unlimited
* Your temp file or partition has to be big enough to hold multiple 
  parallel uploads from multiple users; e.g. if the max upload size is 10GB and 
  the average users uploading the same time is 100: temp space has to hold at 
  least 10x100 GB

Configuring Your Webserver
--------------------------

ownCloud comes with its own ``owncloud/.htaccess`` file. Set the following 
two parameters inside this ``.htaccess`` file::

 upload_max_filesize = 16G
 post_max_size = 16G

Adjust these values for your needs. If you see PHP timeouts in your logfiles, 
increase the timeout values, which are in seconds::

 php_value max_input_time 3600
 php_value max_execution_time 3600

Configuring PHP
---------------

If you don't want to use the ownCloud ``.htaccess`` file, you may 
configure PHP instead. Make sure to comment out any lines ``.htaccess`` 
pertaining to upload size, if you entered any.

To view your current PHP configuration and to see the location of your 
``php.ini`` file, create a plain text file named ``phpinfo.php`` with just this 
single line of code in it: ``<?php phpinfo(); ?>``. Place this file in your Web 
root, for example ``/var/www/html``, and open it in your Web browser, for 
example ``http://localhost/phpinfo.php``. This will display your complete 
current PHP configuration. Look for the **Loaded Configuration File** section 
to see which ``php.ini`` file your server is using. This is the one you want to 
edit.

If you are running ownCloud on a 32-bit system, any ``open_basedir`` directive 
in your ``php.ini`` file needs to be commented out

Set the following two parameters inside ``php.ini``, using your own desired 
file size values::

 upload_max_filesize = 16G
 post_max_size = 16G
 
Tell PHP which temp file you want it to use::
 
 upload_tmp_dir = /var/big_temp_file/

**Output Buffering** must be turned off in ``.htaccess`` or ``php.ini``, or PHP 
will return memory-related errors:

* ``output_buffering = 0``
