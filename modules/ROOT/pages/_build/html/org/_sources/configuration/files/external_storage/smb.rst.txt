========
SMB/CIFS
========

ownCloud can connect to Windows file servers or other SMB-compatible servers
with the SMB/CIFS backend.

.. note:: 
   ownCloud's SMB/CIFS backend requires either `the libsmbclient-php module`_ (version 0.8.0+) or `the smbclient command`_ (and its dependencies) to be installed on the ownCloud server. 
   We highly recommend libsmbclient-php, but it isn't required.
   If installed, however, smbclient won't be needed.
   Most Linux distributions provide libsmbclient-php and, typically, name it ``php-smbclient``. 

You also need the Samba client installed on your Linux system. This is included in 
all Linux distributions; on Debian, Ubuntu, and other Debian derivatives this 
is ``smbclient``. On SUSE, Red Hat, CentOS, and other Red Hat derivatives it is 
``samba-client``. You also need ``which`` and ``stdbuf``, which should be included in most Linux distributions.

You need the following information:

*    Folder name for your local mountpoint.
*    Host: The URL of the Samba server.
*    Username: The username or domain/username used to login to the Samba 
     server.
*    Password: the password to login to the Samba server.
*    Share: The share on the Samba server to mount.
*    Remote Subfolder: The remote subfolder inside the Samba share to mount 
     (optional, defaults to /). To assign the ownCloud logon username 
     automatically to the subfolder, use ``$user`` instead of a particular 
     subfolder name. 
*    And finally, the ownCloud users and groups who get access to the share.

Optionally, you can specify a ``Domain``. This is useful in 
cases where the
SMB server requires a domain and a username, and an advanced authentication
mechanism like session credentials is used so that the username cannot be
modified. This is concatenated with the username, so the backend gets
``domain\username``

.. figure:: images/smb.png
   :alt: Samba external storage configuration.
   :scale: 75%

See :doc:`../external_storage_configuration_gui` for additional mount 
options and information.

See :doc:`auth_mechanisms` for more information on authentication schemes.

.. Links
   
.. _the libsmbclient-php module: https://github.com/eduardok/libsmbclient-php
.. _the smbclient command: https://www.samba.org/samba/docs/man/manpages-3/smbclient.1.html
