======
Backup
======

If you remove the ownCloud app or update it - a backup is created automatically.

The backup remains on the host system and can be restored.

It is stored in :: 

  /var/lib/univention-appcenter/backups/ 

The file name is ::

  appcenter-backup-owncloud:date

In it, you find your data and conf folders. 

Your database backup is in ::

  /var/lib/univention-appcenter/backups/data/backups
