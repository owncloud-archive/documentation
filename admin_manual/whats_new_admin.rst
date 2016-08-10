===========================================
What's New for Admins in ownCloud |version|
===========================================

See the `ownCloud 9.1 Features page 
<https://github.com/owncloud/core/wiki/ownCloud-9.1-Features>`_ on Github for a 
comprehensive list of new features and updates.

ownCloud has many improvements. Some of our new features are:

* Two Factor authentication plug-in system
* OCC command added to (temporarily) disable/enable two-factor authentication for single users

Note: the current desktop and mobile client versions do not support two-factor yet, this will be added later. It is already possible to generate a device specific password and enter that in the current client versions.

* New ``occ`` option, ``--unscanned``, to scan only previously unscanned 
  files (`<https://github.com/owncloud/core/pull/24702>`_)
* New ``occ`` command to disable/enable users
* New ``occ`` command to disable/enable two-factor auth for specific users
* New group tags for system file tags 
  (`<https://github.com/owncloud/enterprise/issues/1208>`_)
* Cleaner internal file URLs 
  (`<https://github.com/owncloud/core/issues/11732>`_)
* Google Drive/Dropbox configuration dropdown; easier configuration for shared 
  hosters (`<https://github.com/owncloud/core/pull/22214>`_)
  
Enterprise Only
---------------

* ownCloud 9.1 Enterprise can now handle notifications directly from Windows network drives as a technology preview, making complete file scans obsolete.
* The Workflow engine represents a powerful new feature for enterprise customers. Triggers can be placed on new or modified files, while scripts of any type can be run. This allows documents to be converted automatically into PDFs or sent to a specific recipient by e-mail. In conjunction with the retention app, the file firewall and integrated tagging, it also allows numerous workflows to be addressed for integration into business processes.
