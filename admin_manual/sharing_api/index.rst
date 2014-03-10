===========
Sharing API
===========

.. toctree::
    :maxdepth: 2
    :hidden:

    get_all_shares
    get_shares_from_a_specific_file_or_folder
    get_information_about_a_known_share
    create_a_new_share
    delete_share

Introduction
============

This document will describe how to use the ownCloud Sharing API.
The sharing API allows for the creation of new shares, obtaining a list of shares, and deleting shares.
In addition, information such a lists of files shared to users can be obtained.

In order to utilize this API, all user ID’s involved in the share, as well as full path names of files is required to be known.

Two methods will be shown:
Firefox Plugin “Poster” and Curl via the command line.

The base URL for all calls to the share API is:
owncloud_base_url>/ocs/v1.php/apps/files_sharing/api/v1/shares

Permissions
-----------

The following table describes the Permissions of a share.
The Permissions are contained in the XML code output of the command.

+--------+------------------------------------------+
| Value  | Permissions                              |
|        |                                          |
+--------+------------------------------------------+
| **1**  | Read only – Default for “public” shares  |
|        |                                          |
+--------+------------------------------------------+
| **2**  | Update                                   |
|        |                                          |
+--------+------------------------------------------+
| **4**  | Create                                   |
|        |                                          |
+--------+------------------------------------------+
| **8**  | Delete                                   |
|        |                                          |
+--------+------------------------------------------+
| **16** | Re-share                                 |
|        |                                          |
+--------+------------------------------------------+
| **31** | All above – Default for “private” shares |
|        |                                          |
+--------+------------------------------------------+


To obtain combinations, add the desired values together.
For instance, for “Re-Share”, “delete”, “read”, “update”, add 16+8+2+1 = 27.

