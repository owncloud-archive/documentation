Excluding Directories and Blacklisting Files
============================================

Definitions of terms
--------------------

* **Blacklisted** ... files that may harm the owncloud environment like a foreign ``.htaccess`` file
* **Excluded**    ... directories that are excluded from being further processed, like snapshot directories

Both types can be defined in the config.php file. For details please see examples in config.sample.php

Both types are when set - not scanned, not viewed, not synced, can not be created or renamed (or deleted) or accessed via direct path input from a file explorer. Even, when a filepath is entered manually via a file explorer and contains an excluded directory name, the path cannot be accessed. Excluded Directories and Blacklisted Files are skipped when residing on an external storage and moved to the trashbin.

Blacklisted Files
-----------------

By default, ownCloud blacklists the file ``.htaccess`` to secure the running instance which is important when using Apache as webserver. A foreign ``.htaccess`` file could overwrite rules defined by ownCloud. There is no special need to enter the file name ``.htaccess`` explicitly to the parameter ``blacklisted_files`` array in config.php. If necessary, you can add more blacklisted files there.

Excluded Directories
--------------------

Reason for excluding directories:

1. Enterprise Storage Systems are capable of snapshots. These snapshots are directories with a particular name and keep point in time views of the data. Usually, these snapshot directories are present in each directory and read only
2. There is no common naming for these directories and most likely will never be. NetApp uses ``.snapshot`` and ``~snapshot``, EMC eg ``.ckpt``, HDS eg ``.latest`` and ``~latest`` and so on
3. Viewing and scanning of these directories does not make any sense as these directories are used to ease backup and restore

Example:

If you have a snapshot capable storage system where snapshots are enabled and viewed to clients, each directory will contain a "special" visible directory named eg .snapshot. Under this directory, you will maybe find a list of snapshots taken and underneath the taken snapshot the complete set of files and directories which were present when the snapshot was created:

.. code-block:: bash

   /.snapshot
	/nightly.0
		/home
		/dat
		/pictures
		file_1
		file_2
	/nightly.1
		/home
		/dat
		/pictures
		file_1
		file_2
	/nightly.2
		/home
		/dat
		/pictures
		file_1
		file_2
	...
   /home
   /dat
   /pictures
   file_1
   file_2
   ...

If you have a filesystem mounted with 200,000 files and directories and 15 snapshots in rotation, you would now scan and process 200,000 elements plus 200,000 x 15 = 3,000,000 elements additionally. Those additional 3,000,000 elements would then also be available for viewing and synchronisation. This is usually a big and unnecessary overhead factor, most times confusing to clients and can be eliminated by using excluded directory names which prevent further processing.
