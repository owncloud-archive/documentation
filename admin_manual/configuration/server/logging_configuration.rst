=====================
Logging Configuration
=====================

Use your ownCloud log to review system status, or to help debug problems. You may adjust logging levels, and choose between using the ownCloud log or your syslog.

Parameters
----------

Logging levels range from **DEBUG**, which logs all activity, to **FATAL**, which logs only fatal errors.

* **0**: DEBUG: Debug, informational, warning, and error messages, and fatal issues.
* **1**: INFO:  Informational, warning, and error messages, and fatal issues.
* **2**: WARN:  Warning, and error messages, and fatal issues.
* **3**: ERROR: Error messages and fatal issues.
* **4**: FATAL: Fatal issues only.

By default the log level is set to **2** (WARN). Use **DEBUG** when you have a problem to diagnose, and then reset your log level to a less-verbose level, as **DEBUG** outputs a lot of information, and can affect your server performance.

Logging level parameters are set in the :file:`config/config.php` file, or on the Admin page of your ownCloud Web GUI.

ownCloud
~~~~~~~~

All log information will be written to a separate log file which can be
viewed using the log viewer on your Admin page. By default, a log
file named **owncloud.log** will be created in the directory which has
been configured by the **datadirectory** parameter in :file:`config/config.php`.

The desired date format can optionally be defined using the **logdateformat** parameter in :file:`config/config.php`.
By default the `PHP date function`_ parameter "*c*" is used, and therefore the
date/time is written in the format "*2013-01-10T15:20:25+02:00*". By using the
date format in the example below, the date/time format will be written in the format
"*January 10, 2013 15:20:25*".

::

    "log_type" => "owncloud",
    "logfile" => "owncloud.log",
    "loglevel" => "3",
    "logdateformat" => "F d, Y H:i:s",

syslog
~~~~~~

All log information will be sent to your default syslog daemon.

::

    "log_type" => "syslog",
    "logfile" => "",
    "loglevel" => "3",

The syslog format can be changed to remove or add information.
In addition to the ``%replacements%`` below ``%level%`` can be used, but it is used
as a dedicated parameter to the syslog logging facility anyway.

::

    'log.syslog.format' => '[%reqId%][%remoteAddr%][%user%][%app%][%method%][%url%] %message%',

       For the old syslog message format use:
     
    'log.syslog.format' => '{%app%} %message%', 


Conditional Logging Level Increase
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure the logging level to automatically increase to ``debug`` when the first condition inside a condition block is met.
All conditions are optional !

 - ``shared_secret``: A unique token. If a http(s) request parameter named ``log_secret`` is added 
               to the request and set to this token, the condition is met.
 - ``users``:  If the current request is done by one of the specified users,
               this condition is met.
 - ``apps``:   If the log message is invoked by one of the specified apps,
               this condition is met.
 - ``logfile``: The log message invoked gets redirected to this logfile 
	   when a condition above is met.
	   
Notes regarding the logfile key:

1. If no logfile is defined, the standard logfile is used.
2. Not applicable when using syslog.


| The following example demonstrates how all three conditions can look like.
| The first one that matches triggers the condition block writing the log entry to the defined logfile.

::

 'log.conditions' => [
	[
		'shared_secret' => '57b58edb6637fe3059b3595cf9c41b9',
		'users' => ['user1', 'user2'],
		'apps' => ['gallery'],
		'logfile' => '/tmp/test2.log'
	]
 ],

Based on the conditional log settings above, following logs are written to the same logfile defined:

- Requests matching ``log_secret`` are debug logged.

::

  curl -X PROPFIND -u sample-user:password \
    https://your_domain/remote.php/webdav/?log_secret=57b58edb6637fe3059b3595cf9c41b9

- ``user1`` and ``user2`` gets debug logged.
- Access to app ``gallery`` gets debug logged.

.. _PHP date function: http://www.php.net/manual/en/function.date.php
