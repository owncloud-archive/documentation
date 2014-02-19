Session Info
============

The following parameters are related to sessions within ownCloud.

+------------------------------+--------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| **Parameter**                | **Format**                                       | **Description**                                                                                                                                    |
|                              |                                                  |                                                                                                                                                    |
+------------------------------+--------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| **Remember Cookie Lifetime** | "remember_login_cookie_lifetime" => 60*60*24*15, | ownCloud provides the user the option of remembering their login credentials (this option appears as the “remember” checkbox on the login screen). |
|                              |                                                  | This parameter allows the admin to configure the length of time which ownCloud will remember that user.                                            |
|                              |                                                  | Default is 15 days.                                                                                                                                |
|                              |                                                  | The configuration is in seconds.                                                                                                                   |
|                              |                                                  |                                                                                                                                                    |
|                              |                                                  |                                                                                                                                                    |
+------------------------------+--------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| **Session Lifetime**         | "session_lifetime" => 60 * 60 * 24,              | ownCloud will automatically logout a user after a period of inactivity.                                                                            |
|                              |                                                  | The default is 1 day.                                                                                                                              |
|                              |                                                  | This parameter can be used to modify that time.                                                                                                    |
|                              |                                                  | Configuration is in seconds.                                                                                                                       |
|                              |                                                  |                                                                                                                                                    |
|                              |                                                  |                                                                                                                                                    |
+------------------------------+--------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------+

