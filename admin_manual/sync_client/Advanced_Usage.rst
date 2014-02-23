Advanced Usage
==============

Options
-------

When invoking the client from the command line, the following options are supported.
The invocation must be done as the admin user on Windows.

*   -h, --help: opens a window showing all the below options.



*   --logwindow: open a window to show log output.



*   --logfile <filename>: write log output to file <filename>.



*   --logdir <name>: write each sync log output to a new file in directory <name>.



*   --logexpire <hours>: removes logs older than <hours> hours.
    To be used with –logdir



*   --logflush: flush the log file after every write.



*   --confdir <dirname>: Use the given configuration directory.



Config file
-----------

The ownCloud client reads a configuration file for certain parameters.

The locations of the config file is as follows:

*   Linux:
    $HOME/.local/share/data/ownCloud/owncloud.cfg



*   Windows:
    %LOCALAPPDATA%\owncloud\owncloud.cfg



*   MAC:
    $HOME/Library/Application Support/owncloud



The following parameters contained within the config file may be modified:

*   remotePollinterval (default 30000): Poll time for the remote repository in milliseconds



*   maxLogLines (default 20000): Maximum count of log lines shown in the long window.




Comparison and Conflicts
------------------------

In a sync run, the client must detect if one of the two repositories have updated files.
On the local repository, the client traverses the file tree and compares the modification time of each file with the value it was before.
The previous value is stored in the client’s database.
If it is not, it means the file was recently added to the local repository.
Note that on the local side, the modification time is a good attribute to detect changes because it does not depend on time shifts.

For the remote (i.e., ownCloud server) repository, the client compares the ETag of each file with its previous value.
Like the client, the previous value is obtained from a database query.
If the ETag is the same, the file has not changed.

In case a file has changed on both, the local and remote repositories, since the last sync run, it cannot be determined which version of the file should be used.
However, it is important not to lose any of the changes.

This is called a conflict case.
The client resolves it by creating a conflict file of the older of the two files and saves the newer one under the original file name.
Conflict files are always created on the client and
not the server.
The conflict file has the same name as the original file appended with the timestamp of the conflict detection.

Ignored Files
-------------

The ownCloud client will not sync the following files:

*   Files matching one of the patterns in the Ignored Files Editor.



*   Files containing special characters that do not work on certain file systems.



*   Files starting in the .csync_journal.db (reserved for journaling).



*   Files whose complete path is greater than 256 characters will cause an error and not sync.



