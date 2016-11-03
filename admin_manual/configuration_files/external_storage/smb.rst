========
SMB/CIFS
========

ownCloud can connect to Windows file servers or other SMB-compatible servers
with the SMB/CIFS backend.

.. note:: The SMB/CIFS backend requires the PHP smbclient module to be installed on the ownCloud server. This should be included in any Linux distribution; on Debian, Ubuntu, CentOS, and Fedora it is ``php-smbclient``. See `eduardok/libsmbclient-php <https://github.com/eduardok/libsmbclient-php>`_ if your distribution does not include it; this provides source archives and instructions how to install binary packages.

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

.. note:: For improved reliability and performance, we recommended installing   
          ``libsmbclient-php``, a native PHP module for connecting to
          SMB servers. It is available as ``php5-libsmbclient`` in the ownCloud
          `OBS repositories <https://download.owncloud.org/download/repositories/
          stable/owncloud/>`_

.. figure:: images/smb.png
   :alt: Samba external storage configuration.
   :scale: 75%

See :doc:`../external_storage_configuration_gui` for additional mount 
options and information.

See :doc:`auth_mechanisms` for more information on authentication schemes.
