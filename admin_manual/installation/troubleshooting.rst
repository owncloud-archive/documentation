===============
Troubleshooting
===============

Database Configuration Issues
-----------------------------

If your ownCloud installation fails and you see the following error in your ownCloud log please refer to :ref:`db-binlog-label` for how to resolve it.

::

 An unhandled exception has been thrown: exception ‘PDOException’ with message 
 'SQLSTATE[HY000]: General error: 1665 Cannot execute statement: impossible to 
 write to binary log since BINLOG_FORMAT = STATEMENT and at least one table 
 uses a storage engine limited to row-based logging. InnoDB is limited to 
 row-logging when transaction isolation level is READ COMMITTED or READ 
 UNCOMMITTED.'

