Sharing
=======

Shared files or directories are counted against the owner’s quota and not the “shared-to” user’s quota.

Shared Files
------------

When user A shares a file with user B, the size of the file will be counted against user A’s quota.
This is the case even if the file is modified by user B or if user B increases the file size.

Shared Directories
------------------

When user A shares a directory with User B, all files uploaded to that directory by user B will count against user A’s quota.
Likewise, files within that directory which are modified by user B will count against user A’s quota.

Resharing
---------

If user A shares a file with user B who then reshares a file to user C, the space occupied by that file is counted against user A’s quota.

Public sharing with upload permission
-------------------------------------

If user A publicly shares a directory via a link and enables “public upload” permission, files uploaded to that directory from the outside are counted against user A’s quota.
