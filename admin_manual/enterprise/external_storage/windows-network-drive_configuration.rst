========================================================
Installing and Configuring the Windows Network Drive App
========================================================

The Windows Network Drive app creates a control panel on your Admin page for
seamless mounting of SMB/CIFS file shares on ownCloud servers.

Any Windows file share, and Samba servers on Linux and other Unix-type
operating systems use the SMB/CIFS file-sharing protocol. The files and
directories on the SMB/CIFS server will be visible on your Files page just like
your other ownCloud files and folders. 

They are labeled with a little four-pane Windows-style icon, and the left pane
of your Files page includes a Windows Network Drive filter. Figure 1 shows
a new Windows Network Drive share marked with red warnings. 

These indicate that ownCloud cannot connect to the share because it requires
the user to login, it is not available, or there is an error in the
configuration. 

.. figure:: images/wnd-1.png
   :alt: Windows Network Drive share on your Files page.
   
   *Figure 1: Windows Network Drive share on your Files page.*

Files are synchronized bi-directionally, and you can create, upload, and delete
files and folders. ownCloud server admins can create Windows Network Drive
mounts, and optionally allow users to create their own personal Windows Network
Drive mounts. 

Depending on the authentication method, passwords for each mount are encrypted
and stored in the ownCloud database, using a long random secret key stored in
``config.php``, which allows ownCloud to access the shares when the users who
own the mounts are not logged in. Or, passwords are not stored and available
only for the current session, which adds security.

Installation
------------

Enable the Windows Network Drive app on your ownCloud Apps page. Then there are 
a few dependencies to install.

You must install ``php-smbclient`` version 0.8.0+. This should be included in
most Linux distributions. See `eduardok/libsmbclient-php
<https://github.com/eduardok/libsmbclient-php>`_ if your distribution does not
include it; this provides source archives and instructions how to install
binary packages.

You also need the Samba client installed on your Linux system. This is included
in all Linux distributions; on Debian, Ubuntu, and other Debian derivatives
this is ``smbclient``. On SUSE, Red Hat, CentOS, and other Red Hat derivatives
it is ``samba-client``. You also need ``which`` and ``stdbuf``, which should be
included in most Linux distributions.

Creating a New Share
--------------------

When you create a new WND share you need the login credentials for the share, 
the server address, the share name, and the folder you want to connect to. 

1. First enter the ownCloud mount point for your new WND share. This must not be 
   an existing folder.
2. Then select your authentication method; See :doc:`enterprise_only_auth` for 
   complete information on the five available authentication methods.
   
.. figure:: images/wnd-2.png
   :alt: WND mountpoint and auth.
   
   *Figure 2: WND mountpoint and authorization credentials.*
   
3. Enter the address of the server that contains the WND share.
4. The Windows share name.
5. The root folder of the share. This is the folder name, or the 
   ``$user`` variable for user's home directories. Note that the LDAP 
   ``Internal Username Attribute`` must be set to the ``samaccountname`` for 
   either the share or the root to work, and the user's home directory needs 
   to match the ``samaccountname``. (See 
   :doc:`../../configuration/user/user_auth_ldap`.)
6. Login credentials.
7. Select users or groups with access to the share. The default is all users.
8. Click the gear icon for additional mount options. Note that previews are
   enabled by default, while sharing is not (see figure 2). Sharing is not
   available for all authorization methods; see :doc:`enterprise_only_auth`.
   For large storages with many files you may want to disable previews, because
   this can significantly increase performance.

.. figure:: images/wnd-3.png
   :alt: WND server and credentials.

   *Figure 3: WND server, credentials, and additional mount options.*  

Your changes are saved automatically.

.. note:: When you create a new mountpoint using Login credentials you must log
   out of ownCloud, and then log back in so you can access the share. You only
   have to do this the first time.

Personal WND Mounts
-------------------

Users create their own personal WND mounts on their Personal pages. These are 
created the same way as Admin-created shares. Users have four options for 
login credentials: 

* Username and password
* Log-in credentials, save in session
* Log-in credentials, save in database
* Global credentials

libsmclient Issues
------------------

If your Linux distribution ships with ``libsmbclient 3.x``, which is included
in the Samba client, you may need to set up the HOME variable in Apache to
prevent a segmentation fault. If you have ``libsmbclient 4.1.6`` and higher it
doesn't seem to be an issue, so you won't have to change your HOME variable.

To set up the HOME variable on Ubuntu, modify the ``/etc/apache2/envvars`` 
file::

  unset HOME
  export HOME=/var/www

In Red Hat/CentOS, modify the ``/etc/sysconfig/httpd`` file and add the 
following line to set the HOME variable in Apache::

  export HOME=/usr/share/httpd
 
By default CentOS has activated SELinux, and the ``httpd`` process can not make
outgoing network connections. This will cause problems with the ``curl``,
``ldap`` and ``samba`` libraries. You'll need to get around this in order to
make this work. First check the status::

  getsebool -a | grep httpd
  httpd_can_network_connect --> off

Then enable support for network connections::

  setsebool -P httpd_can_network_connect 1

In openSUSE, modify the ``/usr/sbin/start_apache2`` file::
 
  export HOME=/var/lib/apache2

Restart Apache, open your ownCloud Admin page and start creating SMB/CIFS 
mounts.

==============================
Windows Network Drive Listener
==============================

The SMB protocol supports registering for notifications of file changes on
remote Windows SMB storage servers. Notifications are more efficient than
polling for changes, as polling requires scanning the whole SMB storage.
ownCloud supports SMB notifications with an ``occ`` command, ``occ
wnd:listen``.

.. Note:: The notifier only works with remote storage on Windows servers. It
   does not work reliably with Linux servers due to technical limitations.

Your ``smbclient`` versions needs to be 4.x, as older versions do not support
notifications.

The ownCloud server needs to know about changes to files on integrated storage
so that the changed files will be synced to the ownCloud server, and to desktop
sync clients. 

Files changed through the ownCloud Web interface or sync clients are
automatically updated in the ownCloud file cache, but this is not possible when
files are changed directly on remote SMB storage mounts. 

To create a new SMB notification, start a listener on your ownCloud server with
``occ wnd:listen``. The listener marks changed files, and a background job
updates the file metadata.

Windows network drive connections and setup of ``occ wnd:listen`` often does
not always work the first time. If you encounter issues using it, then try the
following troubleshooting steps:

1. Check the connection with smbclient_ on the command line of the ownCloud server
2. If you are connecting to `Distributed File Shares`_ (DFS), be aware that the
   shares are case-sensitive

Take the example of attempting to connect to the share named `MyData` using
``occ wnd:listen``. Running the following command would work::
  
   su www-data -s /bin/bash -c 'php /var/www/owncloud/occ wnd:listen dfsdata MyData svc_owncloud password'

However, running this command would not::
   
   su www-data -s /bin/bash -c 'php /var/www/owncloud/occ wnd:listen dfsdata mydata svc_owncloud password'

.. _setup_notifications_for_smb_share-label::

Setup Notifications for an SMB Share
------------------------------------

If you don't already have an SMB share, you must create one. Then start the
listener with this command, like this example for Ubuntu Linux::

    sudo -u www-data php occ wnd:listen <host> <share> <username> [password]
    
The ``host`` is your remote SMB server, which must be exactly the same as the
server name in your WND configuration on your ownCloud Admin page. ``share`` is
the share name, and ``username`` and ``password`` are the login credentials for
the share. By default there is no output. Enable verbosity to see the
notifications::
 
  $ sudo -u www-data php occ wnd:listen -v server share useraccount
  Please enter the password to access the share: 
  File removed : Capirotes/New Text Document.txt
  File modified : Capirotes
  File added : Capirotes/New Text Document.txt
  File modified : Capirotes
  File renamed : old name : Capirotes/New Text Document.txt
  File renamed : new name : Capirotes/New Document.txt
  
Enable increased verbosity to see debugging messages, including which storage
is updated and timing::
  
  $ sudo -u www-data php occ wnd:listen -vvv server share useraccount
  Please enter the password to access the share: 
  notification received in 1471450242
  File removed : Capirotes/New Document.txt
  found 1 related storages from mount id 1
  updated storage wnd::admin@server/share// from mount id 1 -> removed internal path : Capirotes/New Document.txt
  found 1 related storages from mount id 3
  updated storage wnd::administrador@server/share// from mount id 3 -> removed internal path : Capirotes/New Document.txt
  found 1 related storages from mount id 2

See :doc:`../../configuration/server/occ_command` for detailed help with ``occ``.

One Listener for Many Shares
----------------------------

As the ownCloud server admin you can setup an SMB share for all of your users
with a ``$user`` template variable in the root path. By using a ServiceUser you
can listen to the common share path. The ServiceUser is any user with access to
the share. You might create a special read-only user account to use in this
case.

Example:

Share ``/home`` contains folders for every user, e.g. ``/home/alice`` and
``/home/bob``. So the admin configures the Windows Network Drive external
storage with these values:

-  Folder name: home
-  Storage Type: Windows Network Drive
-  Authentication: Log-in credentials, save in database
-  Configuration
   ``host: "172.18.16.220", share: "home", remote subfolder: "$user", domain: ""``

Then starts the ``wnd:listen`` thread::

    sudo -u www-data occ wnd:listen 172.18.16.220 home ServiceUser Password

Changes made by Bob or Alice made directly on the storage are now detected by
the ownCloud server.

Running the WND Listener as a Service
-------------------------------------

There are several different approaches available to running the Windows Network Drive listener as a service.

As a Cron Job
~~~~~~~~~~~~~

Firstly, create a new script called ``wnd-listen.sh`` and add the code below to it, adjusting the path to your ownCloud installation so that it’s specific to your installation.

.. code-block:: bash

   #!/bin/bash 
   until php -f /var/www/owncloud/occ wnd:listen $@; do
      echo "occ wnd:listen crashed with exit code $?.  Respawning.." >&2
      sleep 1
   done

Then, make the script executable and ensure that it is owned by your HTTP user. 
To do that, run the following commands, changing ``<HTTP_USER>`` as required.

.. code-block:: console

   chmod +x wnd-listen.sh
   chown <HTTP_USER> wnd-listen.sh

With the script completed, test it in debug mode by running it with the command ``./wnd-listen.sh``.
The script will ask you for the password on every restart.
For testing production environments add the password as a parameter.

With the script tested, add a crontab entry to execute it on boot, e.g.:

.. code-block:: console

   @reboot www-data /usr/local/bin/wnd-listen.sh 10.0.0.100 Users sysOwnCloud password

Using Systemd
~~~~~~~~~~~~~

To setup a Windows Network Drive listener using Systemd, firstly :ref:`setup a listener for each of your shares <setup_notifications_for_smb_share-label>`.
In a high availability environment, however, setup only one listener per share; that way there is no redundancy for the listener(s). 

.. note:: 
   Your credentials will be in plain text — currently this is unavoidable.

Then, create a systemd script for your Linux distribution.
This process *should* work on any systemd distro, provided you change the paths/users accordingly.

After that, create a ``owncloud-listener.service`` file in ``/etc/systemd/system/`` using your favorite text editor.
Then, copy the contents below into the file.

.. code-block:: ini

   [Unit]
   Description=ownCloud WND Listener
   After=syslog.target network.target
   Requires=httpd.service
   [Service]
   User=apache
   Group=apache
   WorkingDirectory=/var/www/html/owncloud
   ExecStart=/usr/bin/php /var/www/html/owncloud/occ wnd:listen SERVER SHARE USER PASSWORD
   Type=simple
   StandardOutput=journal
   StandardError=journal
   SyslogIdentifier=%n
   KillMode=process
   RestartSec=1
   Restart=on-failure
   [Install]
   WantedBy=multi-user.target

With that done, make sure the file is owned by root and has the permissions ``644``. 
You can do that using the following command:

.. code-block:: console

   chown root /etc/systemd/system/owncloud-listener.service
   chmod 644 /etc/systemd/system/owncloud-listener.service

Now, you can control your new service like any other, such as using the following command:

.. code-block:: console

   systemctl start owncloud-listener
 
If you’re happy with it, you can configure the script to auto-start on boot, by using the following command.

.. code-block:: console

   systemctl enable owncloud-listener.service (or whatever you have named your file).

.. note:: 
   If you need multiple listeners, just change the name of the file and configure the ``ExecStart`` parameters accordingly.

.. note::
   This process is based on `a WND Listener Configuration on ownCloudCentral <https://central.owncloud.org/t/wnd-listener-configuration/3114>`_.

.. Links
   
.. _systemd: https://en.wikipedia.org/wiki/Systemd
.. _smbclient: https://www.samba.org/samba/docs/man/manpages-3/smbclient.1.html
.. _Distributed File Shares: https://en.wikipedia.org/wiki/Distributed_File_System_(Microsoft)
