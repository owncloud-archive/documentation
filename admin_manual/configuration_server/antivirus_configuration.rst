=====================
Virus Scanner Support
=====================

Overview
--------

`ClamAV`_ is the only _officially_ supported virus scanner available for use
with ownCloud. However, other anti-virus software can be used, so long as they: 

- Can receive data streams via pipe on the command-line and return an exit code
- Return a parsable result, on stdout

How ClamAV Works With ownCloud
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before you go about installing and configuring it, here is a bit of background
which may be handy to know. ownCloud integrates with anti-virus tools by
connecting to them via:

- A URL and port
- A socket
- Streaming the data from the command-line via a pipe with a configured executable

Files are checked when they are either uploaded or updated, whether that's when
they're edited or saved, but *not* when they are downloaded. 

The ownCloud Antivirus extension sends files as streams to a ClamAV
service (which can be on the same ownCloud server or on another server within
the same network) which in turn scans them and returns a scan result. 

ownCloud evaluates either the exit code returned from ClamAV or parses the
stdout response to retrieve the result of the scan. Based on ownCloud's
evaluation of the response, an appropriate response is then taken, such as
recording a log message, or deleting the file. 

.. important:: File Cache

ownCloud doesn't support a file cache of previously scanned files.

Configuring the ClamAV Antivirus Scanner
----------------------------------------

You can configure your ownCloud server to automatically run a virus scan on
newly-uploaded files using the `Antivirus App for Files`_. The Antivirus App for
Files integrates the open source anti-virus engine `ClamAV`_  with ownCloud.

ClamAV detects all forms of malware including Trojan horses, viruses, and worms.
What's more, it operates on all the key operating systems, including Windows,
Linux, and Mac files, and can scan compressed files, executables, image
files, Flash, PDF, as well as many others.

`ClamAV's Freshclam daemon` automatically updates its malware signature database
at scheduled intervals. ClamAV runs on Linux and any Unix-type operating system,
and Microsoft Windows. You must first install ClamAV, and then install and
configure the Antivirus App for Files on ownCloud.

.. important:: Operating System Note

ownCloud has only been tested with ownCloud on Linux, so these instructions
are for Linux systems.

Installing ClamAV
-----------------

As always, the various Linux distributions manage installing and configuring
ClamAV in different ways.

Debian, Ubuntu, Linux Mint
^^^^^^^^^^^^^^^^^^^^^^^^^^

On Debian and Ubuntu systems, and their many variants, install ClamAV with these
commands::

    apt-get install clamav clamav-daemon

The installer automatically creates default configuration files and launches the
``clamd`` and ``freshclam`` daemons. You don't have to do anything more, though
it's a good idea to review the ClamAV documentation and your settings in
``/etc/clamav/``. Enable verbose logging in both ``clamd.conf`` and
``freshclam.conf`` until you get any kinks worked out.

Red Hat 7, CentOS 7
^^^^^^^^^^^^^^^^^^^

On Red Hat 7 and related systems, you must install the Extra Packages for
Enterprise Linux (EPEL) repository, and then install ClamAV::

   yum install epel-release
   yum install clamav clamav-scanner clamav-scanner-systemd clamav-server
   clamav-server-systemd clamav-update

This installs two configuration files: ``/etc/freshclam.conf`` and
``/etc/clamd.d/scan.conf``. You must edit both of these before you can run
ClamAV. Both files are well-commented, and ``man clamd.conf`` and ``man
freshclam.conf`` explain all the options.  Refer to ``/etc/passwd`` and
``/etc/group`` when you need to verify the ClamAV user and group.

First, edit ``/etc/freshclam.conf`` and configure your options.
``freshclam`` updates your malware database, so you want it to run frequently to
get updated malware signatures. Run it manually post-installation to download
your first set of malware signatures::

  freshclam

The EPEL packages do not include an init file for ``freshclam``, so the quick
and easy way to set it up for regular checks is with a cron job. This example
runs it every hour at 47 minutes past the hour::

  # m   h  dom mon dow  command
    47  *  *   *    *  /usr/bin/freshclam --quiet

Please avoid any multiples of 10, because those are when the ClamAV servers are
hit the hardest for updates.

Next, edit ``/etc/clamd.d/scan.conf``. When you're finished you must enable
the ``clamd`` service file and start ``clamd``::

  systemctl enable clamav-daemon.service
  systemctl start clamav-daemon.service

That should take care of everything. Enable verbose logging in ``scan.conf``
and ``freshclam.conf`` until it is running the way you want.

Enabling the Antivirus App for Files
------------------------------------

To enable the Antivirus App for Files, go to your ownCloud Apps page to enable
it.

.. figure:: ../images/antivirus-app.png

Configuring ClamAV on ownCloud
------------------------------

Next, go to your ownCloud Admin page and set your ownCloud logging level to
Everything.

.. figure:: ../images/antivirus-logging.png

Now, find your *Antivirus Configuration* panel on your Admin page.

.. figure:: ../images/antivirus-config.png

ClamAV runs in one of three modes:

**Daemon (Socket)** 

In this mode, ClamAV runs in the background on the same server as the ownCloud
installation. When there is no activity ``clamd`` places a minimal load on your
system. However, if your users upload large volumes of files, you will see high
CPU usage. So, please keep this in mind.

**Daemon Via Host:Port**

In this mode, ClamAV runs on a different server. This is a good option for
ownCloud servers with high volumes of file uploads.

**Executable** 

In this mode, ClamAV runs on the same server as the ownCloud installation, and
the ``clamscan`` command only runs when a file is uploaded. ``clamscan`` is slow
and not always reliable for on-demand usage; it is better to use one of the
daemon modes.

Daemon (Socket)
^^^^^^^^^^^^^^^

ownCloud should detect your ``clamd`` socket and fill in the ``Socket``
field. This is the ``LocalSocket`` option in ``clamd.conf``. You can
run ``netstat`` to verify::

   netstat -a|grep clam
   unix 2 [ ACC ] STREAM LISTENING 15857 /var/run/clamav/clamd.ctl

  .. figure:: ../images/antivirus-daemon-socket.png

The ``Stream Length`` value sets the number of bytes read in one pass.
10485760 bytes, or ten megabytes, is the default. This value should be 
no larger than the PHP ``memory_limit`` settings, or physical memory if 
``memory_limit`` is set to -1 (no limit).

``Action for infected files found while scanning`` gives you the choice of
logging any alerts without deleting the files, or immediately deleting
infected files.

Daemon
^^^^^^

For the Daemon option, you need the hostname or IP address of the remote
server running ClamAV and the server's port number.

  .. figure:: ../images/antivirus-daemon-socket.png

Executable
^^^^^^^^^^

The Executable option requires the path to ``clamscan``, which is the
interactive ClamAV scanning command. ownCloud should find it automatically.

  .. figure:: ../images/antivirus-executable.png

When you are satisfied with how ClamAV is operating, you might want to go
back and change all of your logging to less verbose levels.

Rule Configuration
^^^^^^^^^^^^^^^^^^

ownCloud provides the ability to customize how ownCloud reacts to the
response provided by an anti-virus scan. To do so, under ``Admin -> Antivirus
Configuration -> Advanced``, which you can see in the screenshot below, you can
view and change the existing rules. You can also add new ones. 

  .. figure:: images/anti-virus-configuration-rules.png

Rules can match on either an exit status (e.g., 0, 1, or 40) or
a pattern in the string returned from ClamAV (e.g., ``/.*: (.*) FOUND$/``). 

.. _update-an-existing-rule:

Update An Existing Rule
~~~~~~~~~~~~~~~~~~~~~~~~~

To match on an exit status, change the "**Match by**" dropdown list to
"**Scanner exit status**" and in the "**Scanner exit status or signature to
search**" field, add the status code to match on. 

To match on the scanner's output, change the "**Match by**" dropdown list to
"**Scanner output**" and in the "**Scanner exit status or signature to
search**" field, add the regular expression to match against the scanner's
output. 

Then, while not mandatory, add a description of what the status or scan output
means. After that, set what ownCloud should do when the exit status or regular
expression you set matches the value returned by ClamAV. To do so change the
value of the dropdown in the "**Mark as**" column. 

The dropdown supports the following three options:

========= ==========================================
Option    Description
========= ==========================================
Clean     The file is clean, and contains no viruses
Infected  The file contains a virus
Unchecked No action should be taken
========= ==========================================

With all these changes made, click the check mark on the left-hand side of the
"**Match by**" column, to confirm the change to the rule. 

Add A New Rule
~~~~~~~~~~~~~~

To add a new rule, click the button marked "Add a rule" at the bottom left of
the rules table. Then follow the process outlined in :ref:`Update An Existing
Rule <update-an-existing-rule>`. 

Delete An Existing Rule
~~~~~~~~~~~~~~~~~~~~~~~

To delete an existing rule, click the rubbish bin icon on the far right-hand
side of the rule that you want to delete.

.. Page Links

.. _Antivirus App for Files: https://github.com/owncloud/files_antivirus 
.. _ClamAV: http://www.clamav.net/index.html
.. _ClamAV's Freshclam daemon: https://linux.die.net/man/1/freshclam
