Introduction
============

The ownCloud server stores deleted files in a temporary area in the event that the file was inadvertently deleted and/or needs to be restored.

Expiry of deleted files
-----------------------

There are two instances in which ownCloud will automatically permanently remove a deleted file.

Disk Utilization
~~~~~~~~~~~~~~~~

To prevent a user from running out of disk space, the ownCloud deleted files app will not utilize more than 50% of the currently available free space for deleted files.
If the deleted files exceed this limit, ownCloud deletes the oldest files until it gets below this limit.

Age
~~~

By default, deleted files remain in the trash bin for 30 days.
This can be configured using the trashbin_retention_obligation parameter

in the config.php
file.
Files older than the configured value (or default 30 days) will be permanently deleted.
ownCloud checks the age of the files each time a new file is moved to the deleted files bin.
