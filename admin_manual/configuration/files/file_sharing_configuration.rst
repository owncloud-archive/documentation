============
File Sharing
============

The sharing policy is configured on the Admin page in the *"Sharing"* section.

.. figure:: images/sharing-files-settings.png
   :alt: ownCloud Sharing settings

From this section, ownCloud users can:

- Share files with their ownCloud groups and other users on the same ownCloud server
- Share files with ownCloud users on :doc:`other ownCloud servers <federated_cloud_sharing_configuration>`
- Create public shares for people who are not ownCloud users.

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

.. note:: ownCloud Enterprise includes a Share Link Password Policy app; see :ref:`the Password Policy documentation <password_policy_label>`.

Settings Explained
------------------

Allow apps to use the Share API
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to enable users to share files.
If this is not checked, no users can create file shares.

Allow users to share via link
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to enable creating public shares for people who are not ownCloud users via hyperlink.

Enforce password protection
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to force users to set a password on all public share links.
This does not apply to local user and group shares.

Allow public uploads
~~~~~~~~~~~~~~~~~~~~

Check this option to allow anyone to upload files to public shares.

Allow users to send mail notification for shared files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to enable sending notifications from ownCloud.
When clicked, the administrator can choose the language for public mail notifications for shared files.

.. figure:: images/sharing/choose-public-mail-notification-language.png
   :alt: Choose the language for public mail notifications for shared files in ownCloud.

What this means is that email notifications will be sent in the language of the user that shared an item.
By default the language is the share owner’s language.
However, it can be changed to any of the currently available languages.
It is also possible to change this setting on the command-line by using :ref:`the occ config:app:set command <apps_commands_label>`, as in this example:

::

    sudo -u www-data php occ config:app:set core shareapi_public_notification_lang --value '<language code>'

.. note:: In the above example "<language code>" is `an ISO 3166-1 alpha-2 two-letter country code`_, such as *ru*, *gb*, *us*, and *au*.

.. note:: To use this functionality, your ownCloud server must be configured to send mail.

Allow users to share file via social media
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to enable displaying of a set of links that allow for quickly sharing files and share links via *Twitter*, *Facebook*, *Google+*, *Diaspora*, and email.

.. figure:: images/sharing-files-via-social-media.png
   :alt: ownCloud social media sharing links

Set default expiration date
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to set a default expiration date on public shares.

Allow resharing
~~~~~~~~~~~~~~~

Check this option to enable users to re-share files shared with them.

Restrict users to only share with users in their groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to confine sharing within group memberships.

.. note::
   This setting does not apply to the Federated Cloud sharing feature.
   If :doc:`Federated Cloud Sharing <federated_cloud_sharing_configuration>`
   is enabled, users can still share items with any users on any instances
   (including the one they are on) via a remote share.

Allow users to send mail notification for shared files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to enable users to send an email notification to every ownCloud user that the file is shared with.

Exclude groups from sharing
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to prevent members of specific groups from creating any file shares in those groups.
When you check this, you'll get a dropdown list of all your groups to choose from.
Members of excluded groups can still receive shares, but not create any.

Allow username autocompletion in share dialog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to enable auto-completion of ownCloud usernames.

Restrict enumeration to group members
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check this option to restrict auto-completion of ownCloud usernames to only those users who are members of the same group(s) that the user is in.

.. note:: ownCloud does not preserve the mtime (modification time) of
   directories, though it does update the mtimes on files. See
   `Wrong folder date when syncing
   <https://github.com/owncloud/core/issues/7009>`_ for discussion of this.

Blacklist Groups From Receiving Shares
--------------------------------------

Sometimes it's necessary or desirable to block groups from receiving shares.
For example, if a group has a significant number of users (> 5,000) or if it's a system group, then it can be advisable to block it from receiving shares.
In these cases, ownCloud administrators can blacklist one or more groups, so that they do not receive shares.

To blacklist one or more groups, via the Web UI, under "**Admin -> Settings -> Sharing**", add one or more groups to the "*Files Sharing*" list.
As you type the group’s name, if it exists, it will appear in the drop down list, where you can select it.

.. figure:: ./images/sharing/blacklisting-groups.png

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

(See :doc:`../../configuration/server/occ_command` for a complete ``occ`` reference.)

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

Create Shares Programmatically
------------------------------

If you need to create new shares using command-line scripts, there are two available option.

- `occ files_external:create`_
- `occ files_external:import`_

occ files_external:create
~~~~~~~~~~~~~~~~~~~~~~~~~

This command provides for the creation of both personal (for a specific user) and general shares.
The command’s configuration options can be provided either as individual arguments or collectively, as a JSON object.
For more information about the command, refer to the :ref:`the occ documentation <files_external_create_label>`.

Personal Share
^^^^^^^^^^^^^^

::

   sudo -u www-data php occ files_external:create /my_share_name windows_network_drive \
        password::logincredentials \
        --config={host=127.0.0.1, share='home', root='$user', domain='owncloud.local'} \
        --user someuser
::

    sudo -u www-data php occ files_external:create /my_share_name windows_network_drive \
        password::logincredentials \
        --config host=127.0.0.1 \
        --config share='home' \
        --config root='$user' \
        --config domain='somedomain.local' \
        --user someuser

General Share
^^^^^^^^^^^^^

::

    sudo -u www-data php occ files_external:create /my_share_name windows_network_drive \
        password::logincredentials \
        --config={host=127.0.0.1, share='home', root='$user', domain='owncloud.local'}

::

    sudo -u www-data php occ files_external:create /my_share_name windows_network_drive \
        password::logincredentials \
        --config host=127.0.0.1 \
        --config share='home' \
        --config root='$user' \
        --config domain='somedomain.local'

occ files_external:import
~~~~~~~~~~~~~~~~~~~~~~~~~

You can create general and personal shares passing the configuration details via JSON files, using the ``occ files_external:import`` command.

**General Share**

::

    sudo -u www-data php occ files_external:import /import.json

**Personal Share**

::

    sudo -u www-data php occ files_external:import /import.json --user someuser

In the two examples above, here is a sample JSON file, showing all of the available configuration options that the command supports.

.. code-block:: json

    {
        "mount_point": "\/my_share_name",
        "storage": "OCA\\windows_network_drive\\lib\\WND",
        "authentication_type": "password::logincredentials",
        "configuration": {
            "host": "127.0.0.1",
            "share": "home",
            "root": "$user",
            "domain": "owncloud.local"
        },
        "options": {
            "enable_sharing": false
        },
        "applicable_users": [],
        "applicable_groups": []
    }

.. Links

.. _an ISO 3166-1 alpha-2 two-letter country code: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
