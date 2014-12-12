=================
LDAP User Cleanup
=================

LDAP User Cleanup is a new feature in the `LDAP user and group backend`` 
application (see :doc:`user_auth_ldap`). LDAP User Cleanup is a background 
process that automatically searches the ownCloud LDAP mappings table, and verifies if the 
users are still available on your LDAP server. Any users that are not available are marked 
as ``deleted``. These users are not deleted from your mapping table until you manually run the
command to delete them.

There are two prequisites for LDAP User Cleanup to operate:

1. Set ``ldapUserCleanupInterval`` in ``config.php`` to your desired check interval in 
minutes. The default is 51 minutes.

2. All configured LDAP connections are enabled and operating correctly. As some users can 
exist on multiple LDAP servers, this helps prevent data loss.

You have two commands to use:

1. ``occ ldap:showRemnants`` displays a table with all users that have been marked as 
deleted, and their LDAP data.

2. ``occ user:delete`` deletes the specified user.

The ``occ`` command is in your ownCloud directory, for example ``/var/www/owncloud/occ``. 
This example shows what the table of deleted users looks like, and it assumes you have changed 
to the directory that ``occ`` is in::

 ./occ ldap:showRemnants
 
+---------------+----------------+-------------+----------------------------------------+
| ownCloud name | Display Name   | LDAP UID    | LDAP DN                                |
+---------------+----------------+-------------+----------------------------------------+
| zombie12839   | May, Arlene    | zombie12839 | uid=zombie12839,ou=zombies,dc=owncloud |
| zombie972     | Kennedy, Alice | zombie972   | uid=zombie972,ou=zombies,dc=owncloud   |
+---------------+----------------+-------------+----------------------------------------+

Then you can run ``./occ user:deleted zombie972`` to delete user zombie972. 

Using the occ Command
=====================

``occ``, the ownCloud console command, can be run in various ways. You need root permissions to run ``occ``. If it is marked as 
executable, then both of these examples work. The first one is run inside the ``owncloud`` directory, and the second one uses the 
full filepath::
 
 ./occ
 /var/www/owncloud/occ
 
You may also run it this way if the ``occ`` file is not executable::

 php occ 

Running it with no options displays a help screen. 



********Questions from carla:*****************

Is there a batch removal option, like remove all users marked as deleted?
Does this remove users only from the mapping table?
What fields can you use for deletion-- owncloud name? display name? ldap uid?

 




