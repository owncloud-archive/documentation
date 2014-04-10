Verification
============

This section describes different verification checks that ownCloud may perform.

+-----------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| **Parameter**               | **Format**                            | **Description**                                                                                                      |
|                             |                                       |                                                                                                                      |
+-----------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| **Update Checker**          | "updatechecker" => true,              | Provides information as to whether there is a new release of ownCloud available.                                     |
|                             |                                       | When enabled, default, a banner will appear on the admin’s web interface when a newer version of ownCloud exists.    |
|                             |                                       |                                                                                                                      |
|                             |                                       |                                                                                                                      |
+-----------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| **Has Internet Connection** | "has_internet_connection" => true,    | Alerts ownCloud if there is an internet connection (true – default).                                                 |
|                             |                                       | If set to false, ownCloud will not be able to look for updates, display the knowledgebase, or bring up the appstore. |
|                             |                                       |                                                                                                                      |
+-----------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| **Working WebDAV**          | "check_for_working_webdav" => true,   | Allows ownCloud to verify a working WebDAV connection.                                                               |
|                             |                                       | This is done by attempting to make a WebDAV request from PHP.                                                        |
|                             |                                       |                                                                                                                      |
+-----------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| **Working .htaccess**       | "check_for_working_htaccess" => true, | Verifies whether the .htaccess file may be modified by ownCloud.                                                     |
|                             |                                       | If set to false, this check will not be                                                                              |
|                             |                                       | performed.                                                                                                           |
|                             |                                       | If the file cannot be modified, items such as large file uploads cannot be performed.                                |
|                             |                                       | This check only affects Apache servers.                                                                              |
|                             |                                       |                                                                                                                      |
+-----------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------+

