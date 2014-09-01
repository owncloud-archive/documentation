User Management
===============

In ownCloud 7, the Users management page has been streamlined and improved. You 
can create new users, view all of your users in a single scrolling window, 
filter users by group, see what groups they belong to, edit their full names and 
passwords, see their data storage locations, view and set quotas, and, if you 
so desire, delete them with a single click.

.. figure:: ../images/users-config.png

User accounts have the following properties:

*Login Name (Username)*
  This is the unique ID of an ownCloud user, and it cannot be changed.

*Full Name*
  The user's display name that appears on file shares, the ownCloud Web 
  interface, and emails. Admins and users may change the Full Name anytime. If 
  the Full Name is not set it defaults to the login name.

*Password*
  The admin sets the new user's first password. Both the user and the admin can 
  change the user's password at anytime.

*Groups*
  You may create groups, and assign group memberships to users. By default new 
  users are not assigned to any groups.

*Group Admin*
  Group admins are granted administrative privileges on specific groups, and 
  can add and remove users from their groups.

*Quota*
  The maximum disk space assigned to each user. Any user that exceeds the quota 
  cannot upload or sync data. ownCloud 7 introduces a new feature, and that is 
  the option to not include external storage in user quotas.

Creating a New User
~~~~~~~~~~~~~

To create a user account:

* Enter the new user's **Login Name** and their initial **Password** 
* Optionally, assign **Groups** memberships
* Click the **Create** button

.. figure:: ../images/users-create.png

Login names may contain letters (a-z, A-Z), numbers (0-9), dashes (-), 
underscores (_), periods (.) and ampersands (@). After creating the user, you 
may fill in their **Full Name** if it is different than the login name, or 
leave it for the user to complete.

Remember to give your new users their logins and passwords.

Reset a User's Password
~~~~~~~~~~~~~~~~~~~~~~~

You cannot recover a user's password, but you can set a new one:

* Hover your cursor over the user's **Password** field
* Click on the **pencil icon** 
* Enter the user's new password in the password field, and remember to provide 
  the user with their password

Renaming a User
~~~~~~~~~~~~~

Each ownCloud user has two names: a unique **Login Name** used for 
authentication, and a **Full Name**, which is their display name. You can edit 
the display name of a user, but you cannot change the login name of any user.

To set or change a user's display name:

* Hover your cursor over the user's **Full Name** field
* Click on the **Pencil icon** 
* Enter the user's new display name


Granting Administrator Privileges to a User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ownCloud has two types of administrators: **Super Administrators** and **Group 
Administrators**. Group administrators have the rights to create, edit and 
delete users in their assigned groups. Group administrators cannot access 
system settings, or add or modify users in the groups that they are not **Group 
Administrators** for. Use the dropdown menus in the **Group Admin** column to 
assign group admin privileges.

.. figure:: ../images/users-groups.png

**Super Administrators** have full rights on your ownCloud server, and can 
access and modify all settings. To assign the **Super Administrators** role to 
a user, simply add them to the ``admin`` group.


Managing Groups
~~~~~~~~~~~~~~~~~

You can assign new users to groups when you create them, and create new groups 
when you create new users. You may also use the **Add Group** button at the top 
of the left pane to create new groups. Newly-created users will immediately 
have access to file shares that belong to their new groups.

Setting Storage Quotas
~~~~~~~~~~~~~~~~~~~~~~

Click the gear on the lower left pane to set a default storage quota. This is 
automatically applied to new users. You may assign a different quota to any user 
by selecting from the **Quota** dropdown anytime by selecting a value, or 
entering a custom value. When you create custom quotas, use the normal 
abbreviations for your storage values such as 500 MB, 5 GB, 5 TB, and so on.

You now have a configurable option in ``config.php`` that controls whether 
external storage is counted against user's quotas. The default is to not count 
external storage as part of user storage quotas. If you prefer to include it, 
then change the default ``false`` to ``true``.::

   'quota_include_external_storage' => false,

Deleting users
~~~~~~~~~~~

Deleting a user is easy: hover your cursor over their name on the **Users** 
page until a trashcan icon appears at the far right. Click the trashcan, and 
they're gone. You'll see an undo button at the top of the page, which 
remains until you refresh the page. When the undo button is gone you cannot 
recover the deleted user.

All of the files owned by the user are deleted as well, including all files 
they have shared. If you need to preserve the user's files and shares, you must 
first download them from your ownCloud Files page, which compresses them into a 
zip file, or use a sync client to copy them to your local computer.

