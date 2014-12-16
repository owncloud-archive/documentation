===============================
Resetting a Lost Admin Password
===============================

If you lose your ownCloud admin password, the easy way to reset it is to ask 
another admin on your ownCloud server to reset it for you, or to use the normal
email reset. If neither of these are an option, then follow this method.

Create a plain-text file containing these lines::

 <?php

 include_once './lib/base.php';

 \OC_User::setPassword('admin', 'RecoveredPassword');
 
This script works for all users. If your ownCloud username is not ``admin``, 
then change ``admin`` to your username.

Name the file something like ``reset.php``. Then upload this file to your 
ownCloud Web server directory (such as ``/var/www/owncloud/reset.php``), and 
access it via a Web browser (``http://mycloud.com/owncloud/reset.php``). 

This resets the password of the named account to ``RecoveredPassword``. 
Log in and change your password immediately, and then delete the file.

This is for ownCloud 6 only.
