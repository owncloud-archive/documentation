============
Tuning Redis
============

Here is a brief guide for tuning Redis to improve the performance of your ownCloud installation, when working with large instances.

TCP-Backlog
-----------

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
----------------------------

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
-----------------------

If you are having issues with Redis latency, please refer to `the official Redis guide`_ on how to handle them.

.. Links
   
.. _Transparent Huge Pages: https://www.kernel.org/doc/Documentation/vm/transhuge.txt 
.. _the official Redis guide: https://redis.io/topics/latency


