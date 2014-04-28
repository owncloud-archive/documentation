Mail Parameters
===============

These parameters are related to ownCloud’s ability to send emails for lost passwords or file shares.

+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Parameter**           | **Format**                         | **Description**                                                                                                                |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail Domain**         | "mail_domain" => "example.com",    | The domain to use when ownCloud sends emails.                                                                                  |
|                         |                                    | Emails can be sent in such instances as to share a public link, share notification or lost password.                           |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP Debug**     | "mail_smtpdebug" => false,         |                                                                                                                                |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP Mode**      | "mail_smtpmode" => "sendmail",     | The method used to send mail.                                                                                                  |
|                         |                                    | Valid values are smtp, php, sendmail and qmail.                                                                                |
|                         |                                    |                                                                                                                                |
|                         |                                    | If using local or remote SMTP, set to smtp.                                                                                    |
|                         |                                    |                                                                                                                                |
|                         |                                    | If using PHP mail it is necessary to have an installed and working email system on the server.                                 |
|                         |                                    | The program used to send email is defined in the PHP.ini file.                                                                 |
|                         |                                    |                                                                                                                                |
|                         |                                    | If using sendmail, it is necessary to have an installed and working email system on the server.                                |
|                         |                                    | The sendmail binary is /usr/sbin/sendmail and should be installed on your Unix system.                                         |
|                         |                                    |                                                                                                                                |
|                         |                                    | If using qmail to send email, the binary is /var/qmail/bin/sendmail and should be installed in your Unix system.               |
|                         |                                    |                                                                                                                                |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP Host**      | "mail_smtphost" => "127.0.0.1",    | Mail server host.                                                                                                              |
|                         |                                    | May contain multiple hosts separated by a semi colon.                                                                          |
|                         |                                    | Also possible is to set the port used a particular host by following the host with a colon then the port number.               |
|                         |                                    |                                                                                                                                |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP Port**      | "mail_smtpport" => 25,             | Port used to communicate with the mail server.                                                                                 |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP TIMEOUT**   | "mail_smtptimeout" => 10,          | In the event that a malware or SPAM scanner is running on the SMTP server, it could be necessary to increase the SMTP timeout. |
|                         |                                    | That can be done using this parameter.                                                                                         |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP **          | "mail_smtpsecure" => "",           | Default value is no security.                                                                                                  |
| **Secure**              |                                    | May be ssl or tls depending                                                                                                    |
|                         |                                    | on the required level of security.                                                                                             |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **MAIL SMPT AUTH**      | "mail_smtpauth" => false,          | Determine if the mail server requires authentication.                                                                          |
|                         |                                    | Default is false.                                                                                                              |
|                         |                                    | If true, the following parameters should be configured as well.                                                                |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP Auth Type** | "mail_smtpauthtype" => "LOGIN",    | If SMTP authentication is required, choose the authentication type as login (default) or plain.                                |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP Name**      | "mail_smtpname" => "username",     | The username to use when authentication is enabled.                                                                            |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
| **Mail SMTP Password**  | "mail_smtppassword" => "password", | The password to use when authentication is enabled.                                                                            |
|                         |                                    |                                                                                                                                |
+-------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+

