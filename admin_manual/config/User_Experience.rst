User Experience
===============

The following parameters are those that influence the end user’s experience.

+----------------------+----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+
| **Parameter**        | **Format**                                   | **Description**                                                                                                            |
|                      |                                              |                                                                                                                            |
+----------------------+----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+
| **Default Language** | "default_language" => "en",                  | This is the default language for the ownCloud WebUI. When configured, the default language will be the same for all users. |
|                      |                                              | Users may then configure their own language preference in their Personal page.                                             |
|                      |                                              | When not configured, the default language is determined form the headers sent by the web browser.                          |
|                      |                                              | For instance, if the browser is in Spanish, ownCloud will be presented in Spanish                                          |
|                      |                                              |                                                                                                                            |
+----------------------+----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+
| **Default App**      | "defaultapp" => "files",                     | By default, when a user logs into ownCloud, they are brought to the files page.                                            |
|                      |                                              | If, for instance, the admin desires a different page to be loaded upon login, configure that app here.                     |
|                      |                                              | Valid values are app id’s (for example news, files, gallery).                                                              |
|                      |                                              |                                                                                                                            |
|                      |                                              |                                                                                                                            |
+----------------------+----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+
| **Knowledge Base **  | "knowledgebaseenabled" => true,              | When enabled, default, the help menu brings up the user documentation.                                                     |
| **Enabled**          |                                              |                                                                                                                            |
|                      |                                              |                                                                                                                            |
+----------------------+----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+
| **Enable Avatars**   | 'enable_avatars' => true,                    | Allows for the ability to use avatars.                                                                                     |
|                      |                                              |                                                                                                                            |
|                      |                                              |                                                                                                                            |
+----------------------+----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+
| **Display Name**     | 'allow_user_to_change_display_name' => true, | Users can modify their display name in the Personal page.                                                                  |
|                      |                                              | If this parameter is set to false, they may not change their display name.                                                 |
|                      |                                              |                                                                                                                            |
|                      |                                              |                                                                                                                            |
+----------------------+----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+

