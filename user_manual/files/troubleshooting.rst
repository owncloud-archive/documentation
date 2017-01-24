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
