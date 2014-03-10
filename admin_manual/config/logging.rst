Logging
=======

This section describes parameters associated with ownCloud’s logging abilities.

+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Parameter**        | **Format**                                           | **Description**                                                                                                                            |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log Type**         | "log_type" => "owncloud",                            | By default the ownCloud logs are sent to the owncloud.log file within the default data directory.                                          |
|                      |                                                      | If syslogging is desired, set this parameter to syslog.                                                                                    |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log File**         | "logfile" => "",                                     | The log file, by default, is owncloud.log and stored in the default data directory.                                                        |
|                      |                                                      | Use this parameter to change the name to something other than owncloud.log.                                                                |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log Level**        | "loglevel" => "",                                    | ownCloud has several levels of logging.                                                                                                    |
|                      |                                                      | This may be set on the Admin page of the webUI or directly in the configuration file using this parameter.                                 |
|                      |                                                      | Valid values are: 0=Debug, 1=Info, 2=Warning, 3=Error.                                                                                     |
|                      |                                                      | The default value is Warning                                                                                                               |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log Date Format**  | 'logdateformat' => 'F d, Y H:i:s',                   | ownCloud allows the admin to specify the format of the time and date within the log file.                                                  |
|                      |                                                      | Valid values may be found at the following website:                                                                                        |
|                      |                                                      | `http://www.php.net/manual/en/function.date.php <http://www.php.net/manual/en/function.date.php>`_                                         |
|                      |                                                      | .                                                                                                                                          |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log Time Zone**    | 'logtimezone' => 'Europe/Berlin',                    | By default, the time zone displayed in the ownCloud logs is UTC.                                                                           |
|                      |                                                      | To change the displayed time zone to the local time zone, use this parameter.                                                              |
|                      |                                                      | For a list of valid values, see the following website:                                                                                     |
|                      |                                                      | `http://php.net/manual/en/timezones.php <http://php.net/manual/en/timezones.php>`_                                                         |
|                      |                                                      | .                                                                                                                                          |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log Query**        | "log_query" => false,                                | When set to “true”, all SQL queries performed by ownCloud will be written to the log file.                                                 |
|                      |                                                      | Default is false.                                                                                                                          |
|                      |                                                      | It is not recommended to run with this enabled as it will fill up the log file.                                                            |
|                      |                                                      | Use only for debugging purposes.                                                                                                           |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log Auth Fail IP** | "log_authfailip" => false,                           | When set to true, the IP addresses of failed login attempts will be logged.                                                                |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| **Log Rotate Size**  | 'log_rotate_size' => false, // 104857600, // 100 MiB | Since ownCloud log files can get large in size, this parameter may be used to rotate to a new log file once it reaches the specified size. |
|                      |                                                      | This should be configured in bytes.                                                                                                        |
|                      |                                                      | Default is false, or 0, which will not rotate the file.                                                                                    |
|                      |                                                      |                                                                                                                                            |
+----------------------+------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+


