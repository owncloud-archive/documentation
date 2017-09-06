============
File Sharing
============

From version 8.2, ownCloud users can share files with their ownCloud groups and
other users on the same ownCloud server, with ownCloud users on :doc:`other
ownCloud servers <federated_cloud_sharing_configuration>`, and create public
shares for people who are not ownCloud users. 
You have control of a number of user permissions on file shares:

* Allow users to share files
* Allow users to create public shares
* Require a password on public shares
* Allow public uploads to public shares
* Require an expiration date on public share links
* Allow resharing
* Restrict sharing to group members only
* Allow email notifications of new public shares
* Exclude groups from creating shares

.. note:: ownCloud Enterprise includes a Share Link Password Policy app; see 
   :ref:`password_policy_label`.

Configure your sharing policy on your Admin page in the Sharing section.

.. figure:: images/sharing-files-settings.png
   :alt: ownCloud Sharing settings

* Check ``Allow apps to use the Share API`` to enable users to share files. If 
  this is not checked, no users can create file shares.
* Check ``Allow users to share via link`` to enable creating public shares for  
  people who are not ownCloud users via hyperlink.
* Check ``Enforce password protection`` to force users to set a password on all 
  public share links. This does not apply to local user and group shares.
* Check ``Allow public uploads`` to allow anyone to upload files to 
  public shares.
* Check ``Allow users to send mail notification for shared files`` to enable 
  sending notifications from ownCloud. (Your ownCloud server must be configured 
  to send mail)
* Check ``Allow users to share file via social media`` to enable displaying of a set of links that allow for quickly sharing files and share links via *Twitter*, *Facebook*, *Google+*, *Disaspora*, and email.

  .. figure:: images/sharing-files-via-social-media.png
     :alt: ownCloud social media sharing links

* Check ``Set default expiration date`` to set a default expiration date on 
  public shares.
* Check ``Allow resharing`` to enable users to re-share files shared with them.
* Check ``Restrict users to only share with users in their groups`` to confine 
  sharing within group memberships.

    .. note:: This setting does not apply to the Federated Cloud sharing 
       feature. If :doc:`Federated Cloud Sharing 
       <federated_cloud_sharing_configuration>` is
       enabled, users can still share items with any users on any instances
       (including the one they are on) via a remote share.

* Check ``Allow users to send mail notification for shared files`` enables 
  users to send an email notification to every ownCloud user that the file is 
  shared with.
* Check ``Exclude groups from sharing`` to prevent members of specific groups 
  from creating any file shares in those groups. When you check this, you'll 
  get a dropdown list of all your groups to choose from. Members of excluded 
  groups can still receive shares, but not create any
* Check ``Allow username autocompletion in share dialog`` to enable 
  auto-completion of ownCloud usernames.
* Check ``Restrict enumeration to group members`` to restrict auto-completion of ownCloud usernames to only those users who are members of the same group(s) that the user is in.

.. note:: ownCloud does not preserve the mtime (modification time) of 
   directories, though it does update the mtimes on files. See  
   `Wrong folder date when syncing 
   <https://github.com/owncloud/core/issues/7009>`_ for discussion of this.

.. _transfer_userfiles_label:   

Transferring Files to Another User
----------------------------------

You may transfer files from one user to another with ``occ``. 
The command transfers either all or a limited set of files from one user to another. 
It also transfers the shares and metadata info associated with those files (*shares*, *tags*, and *comments*, etc). 
This is useful when you have to transfer a user's files to another user before you delete them. 

.. important:: 
   Trashbin contents are not transferred.

Here is an example of how to transfer all files from one user to another.

::

 occ files:transfer-ownership <source-user> <destination-user>

Here is an example of how to transfer *a limited group* a single folder from one user to another.
In it, ``folder/to/move``, and any file and folder inside it will be moved to ``<destination-user>``. 

::

  sudo -u www-data php occ files:transfer-ownership --path="folder/to/move" <source-user> <destination-user>

When using this command keep two things in mind: 

1. The directory provided to the ``--path`` switch **must** exist inside ``data/<source-user>/files``.
2. The directory (and its contents) won’t be moved as is between the users. It’ll be moved inside the destination user’s ``files`` directory, and placed in a directory which follows the format: ``transferred from <source-user> on <timestamp>``. Using the example above, it will be stored under: ``data/<destination-user>/files/transferred from <source-user> on 20170426_124510/``
 
(See :doc:`../../configuration/server/occ_command` for a complete ``occ`` 
reference.) 
   
Creating Persistent File Shares
-------------------------------

When a user is deleted, their files are also deleted. As you can imagine, this 
is a problem if they created file shares that need to be preserved, because 
these disappear as well. In ownCloud files are tied to their owners, so 
whatever happens to the file owner also happens to the files.

One solution is to create persistent shares for your users. You can retain 
ownership of them, or you could create a special user for the purpose of 
establishing permanent file shares. Simply create a shared folder in the usual 
way, and share it with the users or groups who need to use it. Set the 
appropriate permissions on it, and then no matter which users come and go, the 
file shares will remain. Because all files added to the share, or edited in it, 
automatically become owned by the owner of the share regardless of who adds or 
edits them.   
