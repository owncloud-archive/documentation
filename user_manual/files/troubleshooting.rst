===============
Troubleshooting
===============

Error Messages
~~~~~~~~~~~~~~

Listed here are the most common errors you may encounter while attempting to
upload files, along with what they mean, and possible workarounds.

Error while copying file to target location (copied bytes: xxx, expected filesize: yyy)
---------------------------------------------------------------------------------------

This error is most likely due to an issue with the target storage location.
During file uploads the file data is read from PHP input and copied into a part
file on the target storage. 
If the target storage is not local (eg: FTP) and that storage is slow, not
available, or broken it is likely that the operation will fail either at the
beginning, or in the middle of the copy. 
Other reasons for this message can be that, when writing to external storage,
the connection took too long to respond or the network connection was flaky.

Sharing sidebar does not show "Shared with you by ..." for remote shares 
-------------------------------------------------------------------------

In some scenarios, when users share folders and files with each other they cannot be scanned.
There are a variety of reasons why this happens, which can include firewalls and broken servers. 
In these situations, when the initial scan did not complete successfully, the mount point cannot appear in the ownCloud web UI. 
This is because ownCloud was not able to generate a matching file cache entry, nor retrieve any metadata about whether it's a folder or file (mime type), etc.
