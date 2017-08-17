====================
Mimetypes Management
====================

Mimetype Aliases
----------------

ownCloud allows you to create aliases for mimetypes so that you can display custom icons for files. 
This is handy in a variety of situations, such as when you might want a nice audio icon for audio files, instead of the default file icon.

ownCloud's default list is defined in ``owncloud/resources/config/mimetypealiases.dist.json``.
Below you can see a snippet from the file, showing the mimetype on the left and the icon used on the right.

.. code-block:: json
   
   {
    "application/coreldraw": "image",
    "application/epub+zip": "text",
    "application/font-sfnt": "image",
    "application/font-woff": "image",
    "application/illustrator": "image",
    "application/javascript": "text/code",
   }

If you want to change or expand the icons used, create a copy of ``owncloud/config/mimetypealiases.json`` and either override the existing definitions or add custom aliases as required. 
Some common mimetypes that may be useful in creating aliases are:

.. note::
   Please refer to `the ownCloud theming documentation <https://doc.owncloud.com/server/latest/developer_manual/core/theming.html>`_ for where to put the new image files.

========================= =======================
Mimetype                  Description
========================= =======================
``image``                 Generic image
``image/vector``          Vector image
``audio``                 Generic audio file
``x-office/document``     Word processed document
``x-office/spreadsheet``  Spreadsheet
``x-office/presentation`` Presentation
``text``                  Generic text document
``text/code``             Source code
========================= =======================

Once you have made changes to your ``mimetypealiases.json``, use :doc:`the occ command <../../configuration/server/occ_command>` to propagate the changes throughout your ownCloud installation. 
Here is an example for Ubuntu Linux::

  $ sudo -u www-data php occ maintenance:mimetype:update-js

.. note::
   Make sure that you use the same syntax as in the default file.
   
.. danger::
   Do not modify the original file, as it will be replaced whenever ownCloud is updated. 

Mimetype Mapping
----------------

ownCloud allows administrators to map a file extension to a mimetype. 
For example, files ending in ``mp3`` map to ``audio/mpeg``. 
Which then, in turn, allows ownCloud to show the audio icon.

The default mimetype mapping is available in ``mimetypemapping.dist.json``, which returns a simple JSON array.
In the example below, you can see eight mimetypes mapped to file extensions.

.. code-block:: json
   
   {
	"3gp": ["video/3gpp"],
	"7z": ["application/x-7z-compressed"],
	"accdb": ["application/msaccess"],
	"ai": ["application/illustrator"],
	"apk": ["application/vnd.android.package-archive"],
	"arw": ["image/x-dcraw"],
	"avi": ["video/x-msvideo"],
	"bash": ["text/x-shellscript"],
   }

If you want to update or extend the existing mapping, create a copy of ``mimetypemapping.dist.json`` and name it ``mimetypemapping.json``.
This is require for two reasons:

1. It will take precedence over the default file.
2. Administrators **should not update the original file**, as it will get replaced on each ownCloud upgrade.

In this new file, make any changes required. 

.. note::
   Please refer to `the ownCloud theming documentation <https://doc.owncloud.com/server/latest/developer_manual/core/theming.html>`_ for where to put the new image files.

Icon retrieval
--------------

When an icon is retrieved for a mimetype, if the full mimetype cannot be found, the search will fallback to looking for the part before the slash. 
Given a file with the mimetype ``image/my-custom-image``, if no icon exists for the full mimetype, the icon for ``image`` will be used instead. 
This allows specialized mimetypes to fallback to generic icons when the relevant icons are unavailable.

