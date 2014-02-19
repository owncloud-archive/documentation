Excluded from quota
===================

The following sections describe information which is not counted in a user’s quota.

Metadata and cache
------------------

Application metadata and cached information are excluded from total used space.
Examples of such data are thumbnails (icon previews, pictures app), temporary files, and encryption keys.

Deleted Files
-------------

Files which have been moved to the trash bin do not count against a user’s quota.
Deleted items are permanently deleted, oldest to newest, should the user run out of space to make room for new files.

For example, if the user has a 10GB quota, and has used 4GB of space and 5GB in the trash bin, the user will still have 6GB available space.
If, however, the user uploads 6GB, ownCloud will permanently delete files from the trash bin in order to make room for the new files.

Version Control
---------------

Older versions do not count against the user’s quota.
The versions app will delete old versions, oldest to newest, should the user run out of space to make room for new files.

For example, if the user has a 10GB quota, and has used 4GB and 5GB is used on older versions, the user will still have 6GB available space.
If, however, the user uploads 6GB, ownCloud will discard older versions to make room for the new files.

Encryption
----------

Encrypted files are slightly larger than their unencrypted equivalents.
The unencrypted file size is used to determine the quota.

External Storage
----------------

External storage, mounted by either a user or the admin, is not taken into consideration when calculating the user’s storage.

