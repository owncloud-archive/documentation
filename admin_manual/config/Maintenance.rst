Maintenance
===========

This section discusses the different stages of maintenance.

+-----------------+-------------------------+---------------------------------------------------------------------------------------------------+
| **Parameter**   | **Format**              | **Description**                                                                                   |
|                 |                         |                                                                                                   |
+-----------------+-------------------------+---------------------------------------------------------------------------------------------------+
| **Single User** | 'singleuser' => false,  | When set to true, the ownCloud instance will be unavailable for all users not in the admin group. |
|                 |                         | This is useful when performing maintenance.                                                       |
|                 |                         |                                                                                                   |
+-----------------+-------------------------+---------------------------------------------------------------------------------------------------+
| **Maintenance** | "maintenance" => false, | Enable maintenance mode to disable ownCloud.                                                      |
|                 |                         | When performing upgrades, ownCloud automatically enters maintenance mode.                         |
|                 |                         | When enabled, users who are already logged-in are kicked out of ownCloud instantly.               |
|                 |                         |                                                                                                   |
+-----------------+-------------------------+---------------------------------------------------------------------------------------------------+

