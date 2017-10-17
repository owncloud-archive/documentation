======================
ownCloud Server Tuning
======================

Using Cron to Perform Background Jobs
-------------------------------------

See :doc:`background_jobs_configuration` for a description and the 
benefits.

Enable JavaScript and CSS Asset Management
------------------------------------------

See :doc:`js_css_asset_management_configuration` for a description and the 
benefits.

.. _caching:

Enable Memory Caching
---------------------

Caching improves performance by storing data, code, and other objects in memory. 
Memory cache configuration for ownCloud is no longer automatically available from ownCloud 8.1 but must be installed and configured separately. 
ownCloud supports `Redis`_, `APCu`_, and `Memcached`_ as memory caching backends.
See :doc:`caching_configuration`, for further details.

Use Redis-based Transactional File Locking
------------------------------------------

File locking is enabled by default, using the database locking backend. 
However, this places a significant load on your database.
See the section :doc:`../../configuration/files/files_locking_transactional` for how to configure ownCloud to use Redis-based Transactional File Locking.

Redis Tuning
------------

Redis tuning improves both file locking (if used) and memory caching (when using Redis).
Here is a brief guide for tuning Redis to improve the performance of your ownCloud installation, when working with sizeable instances.

TCP-Backlog
~~~~~~~~~~~

If you raised the TCP-backlog setting, the following warning appears in the Redis logs:

.. code-block:: console

 WARNING: The TCP backlog setting of 20480 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of..

If so, please consider that newer versions of Redis have their own TCP-backlog value set to ``511``, and that you have to increase if you have many connections.
In high requests-per-second environments, you need a significant backlog to avoid slow clients connection issues. 

.. note:: 
   The Linux kernel will silently truncate the TCP-backlog setting to the value of ``/proc/sys/net/core/somaxconn``. 
   So make sure to raise both the value of ``somaxconn`` and ``tcp_max_syn_backlog``, to get the desired effect.

To fix this warning, set the value of ``net.core.somaxconn`` to ``65535`` in ``/etc/rc.local``, so that it persists upon reboot, by running the following command.

.. code-block:: console

 sudo echo sysctl -w net.core.somaxconn=65535 >> /etc/rc.local

After the next reboot, 65535 connections will be allowed, instead of the default value.

Transparent Huge Pages (THP)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are experiencing latency problems with Redis, the following warning may appear in your Redis logs:

.. code-block:: console

 WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This creates both latency and memory usage issues with Redis.

If so, unfortunately, when a Linux kernel has `Transparent Huge Pages`_ enabled, Redis incurs a significant latency penalty after the fork call is used, to persist information to disk. 
Transparent Huge Pages are the cause of the following issue:

#. A fork call is made, resulting in two processes with shared huge pages being created.
#. In a busy instance, a few event loops cause commands to target a few thousand pages, causing the copy-on-write of almost the entire process memory.
#. Big latency and memory usage result.

As a result, make sure to disable Transparent Huge Pages using the following command:

.. code-block:: console 
   
 echo never > /sys/kernel/mm/transparent_hugepage/enabled

Redis Latency Problems 
~~~~~~~~~~~~~~~~~~~~~~

If you are having issues with Redis latency, please refer to `the official Redis guide`_ on how to handle them.

Database Tuning
---------------

Using MariaDB/MySQL Instead of SQLite
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MySQL or MariaDB are preferred because of the `performance limitations of 
SQLite with highly concurrent applications 
<http://www.sqlite.org/whentouse.html>`_, like ownCloud.

See the section :doc:`../../configuration/database/linux_database_configuration` for how to
configure ownCloud for MySQL or MariaDB. If your installation is already running on
SQLite then it is possible to convert to MySQL or MariaDB using the steps provided
in :doc:`../../configuration/database/db_conversion`.

Tune MariaDB/MySQL
~~~~~~~~~~~~~~~~~~~~

A comprehensive guide to tuning MySQL and MariaDB is outside the scope of the ownCloud documentation.
However, here are three links that can help you find further information:

- `MySQLTuner <https://github.com/major/MySQLTuner-perl/>`_.
- `Percona Tools for MySQL <https://tools.percona.com/wizard>`_
- `Optimizing and Tuning MariaDB <https://mariadb.com/kb/en/optimization-and-tuning/>`_.

Tune PostgreSQL
~~~~~~~~~~~~~~~

A comprehensive guide to tuning PostgreSQL is outside the scope of the ownCloud documentation. 
However, here are three links that can help you find further information:

- `Five Steps to PostgreSQL Performance <http://de.slideshare.net/PGExperts/five-steps-perform2013>`_
- `Tuning the autovacuum proceff for tables with huge update workloads (oc_filecache) <http://grokbase.com/t/postgresql/pgsql-admin/103qcpdrpf/tuning-auto-vacuum-for-highly-active-tables#20100323hfs3jtjuaywwufukoqtexkpjti>`_

SSL / Encryption App
--------------------

SSL (HTTPS) and file encryption/decryption can be offloaded to a processor's 
AES-NI extension. This can both speed up these operations while lowering 
processing overhead. This requires a processor with the `AES-NI instruction set 
<http://wikipedia.org/wiki/AES_instruction_set>`_.

Here are some examples how to check if your CPU / environment supports the 
AES-NI extension:

* For each CPU core present: ``grep flags /proc/cpuinfo`` or as a summary for 
  all cores: ``grep -m 1 ^flags /proc/cpuinfo`` If the result contains any 
  ``aes``, the extension is present.   

* Search eg. on the Intel web if the processor used supports the extension 
  `Intel Processor Feature Filter 
  <http://ark.intel.com/MySearch.aspx?AESTech=true>`_ You may set a filter by 
  ``"AES New Instructions"`` to get a reduced result set.
   
* For versions of openssl >= 1.0.1, AES-NI does not work via an engine and 
  will not show up in the ``openssl engine`` command. It is active by default 
  on the supported hardware. You can check the openssl version via ``openssl 
  version -a``
    
* If your processor supports AES-NI but it does not show up eg via grep or 
  coreinfo, it is maybe disabled in the BIOS.
  
* If your environment runs virtualized, check the virtualization vendor for 
  support.

Webserver Tuning
----------------

Tune Apache 
~~~~~~~~~~~

Enable HTTP/2 Support
^^^^^^^^^^^^^^^^^^^^^

If you want to improve the speed of an ownCloud installation, while at the same time increasing its security, you can `enable HTTP/2 support for Apache`_.
Please be aware that `most browsers require HTTP/2 to be used with SSL enabled <https://caniuse.com/#feat=http2>`_. 

Apache Processes
^^^^^^^^^^^^^^^^

An Apache process uses around 12MB of RAM. 
Apache should be configured so that the maximum number of HTTPD processes times 12MB is lower than the amount of RAM. 
Otherwise the system begins to swap and the performance goes down. 

Use KeepAlive
^^^^^^^^^^^^^

The `KeepAlive`_ directive enables persistent HTTP connections, allowing multiple requests to be sent over the same TCP connection. 
Enabling it reduces latency by as much as 50%. 
In combination with the periodic checks of the sync client the following settings are recommended:

::

	KeepAlive On
	KeepAliveTimeout 100
	MaxKeepAliveRequests 200

Hostname Lookups
^^^^^^^^^^^^^^^^

::

	# cat /etc/httpd/conf/httpd.conf
        ...
	HostnameLookups off

Log files
^^^^^^^^^

Log files should be switched off for maximum performance.
To do that, comment out the `CustomLog`_ directive. 
However, keep `ErrorLog`_ set, so errors can be tracked down.

.. Links
   
.. _Transparent Huge Pages: https://www.kernel.org/doc/Documentation/vm/transhuge.txt 
.. _the official Redis guide: https://redis.io/topics/latency
.. _CustomLog: https://httpd.apache.org/docs/current/mod/mod_log_config.html#customlog
.. _ErrorLog: https://httpd.apache.org/docs/2.4/logs.html#errorlog
.. _KeepAlive: https://en.wikipedia.org/wiki/HTTP_persistent_connection
.. _enable HTTP/2 support for Apache: https://httpd.apache.org/docs/2.4/howto/http2.html
.. _Redis: https://redis.io 
.. _APCu: http://php.net/manual/en/intro.apcu.php
.. _Memcached: https://memcached.org
