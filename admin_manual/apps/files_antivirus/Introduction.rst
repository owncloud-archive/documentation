Introduction
============

ownCloud integrates with ClamAV, an open source (GPL) antivirus engine, to provide an antivirus solution for files which are uploaded to the ownCloud server.
Via this method, ownCloud/ClamAV can detect Trojans, viruses, malware and other malicious threats.
Files are scanned for virus upon initial upload to the ownCloud server.

The ownCloud antivirus app is supported on ownCloud instances which are installed on a Linux operating system.

The antivirus app can run in one of three modes:

*   Executable – ClamAV is running on the same server as the ownCloud instance.
    For executable mode, the ClamAV process is started and stopped with each file upload.



*   Daemon – ClamAV is running on a different server from the ownCloud instance



*   Daemon (Socket) – ClamAV is running on the same server as the ownCloud instance. In this mode, the ClamAV process is running in the background at all times.
    It is a bit quicker for scanning than executable mode, but requires system administrator skills and root access.



In addition, there are two possible actions which may occur when an infected file is found:

*   Only Log – A log entry is created when an infected file is found.



*   Delete File – The infected file is deleted.


