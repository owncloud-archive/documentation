===================================
Moving Your ownCloud Data Directory
===================================

There are several reasons to move your ownCloud data directory on an existing 
installation: to move it outside of your Web root for better security, 
re-configuring your storage, restoring from backups...whatever the reason, it is 
a simple operation requiring just a few steps.

First, always have :doc:`current backups <../maintenance/backup>`.

Next, put your ownCloud server into maintenance mode. This is disruptive and 
will lock out your users, so you might warn them, and select a quiet time. 
This example is for Ubuntu Linux::

 $ sudo -u www-data php occ maintenance:mode --on
 
You must run ``occ`` as your HTTP user.

* The HTTP user and group in Debian/Ubuntu is www-data.
* The HTTP user and group in Fedora/CentOS is apache.
* The HTTP user and group in Arch Linux is http.
* The HTTP user in openSUSE is wwwrun, and the HTTP group is www.

Then copy your data directory to its new location, which in this example is 
``/var/storage``::

 $ sudo cp -r /var/www/owncloud/data /var/storage
 
Configure your new location in your ``config.php``, using the 
``datadirectory`` parameter::
 
 'datadirectory' => '/var/storage/data'
 
Run ``occ maintenance:repair`` to update the filepaths in your database::

 $ sudo -u www-data php occ maintenance:repair
 
Log in and make sure all your files are there, and your users' files. When 
everything looks correct, you can delete your old data directory. Remember to 
adjust your backups to the new location.  