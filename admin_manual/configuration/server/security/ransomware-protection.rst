Mitigating Ransomware Risks in ownCloud
=======================================

Ransomware is `an ever-present threat`_, both for large enterprises as well as for individuals.
Once infected, a whole hard disk (or just parts of it) can become encrypted, leading to unrecoverable data loss.

Once this happens, attackers normally ask victims to pay a ransom, often via cryptocurrencies such as Bitcoin, in exchange for the decryption key required to decrypt their data.

While paying the ransom works in some cases, it is not recommended, as there is no guarantee that the attackers will supply the key after payment is made.
To help mitigate such threats and ensure ongoing access to user data, ownCloud provides the Ransomware Protection app.

.. important::
   It is essential to be aware that user data needs to be synchronized with you ownCloud Server using the ownCloud Desktop synchronization client. Data that is not synchronized and stored in ownCloud cannot be protected.

About Ransomware Protection
---------------------------

The app is tasked with *detecting*, *preventing*, and *reverting* anomalies.
Anomalies are file operations (including *create*, *update*, *delete*, and *move*) that are not intentionally conducted by the user.
It aims to do so in two ways: `prevention <ransomeware_prevention_label>`_, and `protection <ransomeware_protection_label>`_.

.. _ransomeware_prevention_label:

Prevention: Blocking Common Ransomware File Extensions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Like other forms of cyberattack, Ransomware has a range of diverse characteristics.
On the one hand it makes them hard to detect and on the other makes them even harder to prevent.
Recent ransomeware attacks either encrypt a user's files and add a certain file extension to them (e.g., ".crypt") or they replace the original files with an encrypted copy and a certain file extension.

The first line of defense against such threats is a blacklist that blocks uploading files with file extensions known to originate from ransomeware.
Ransomware Protection ships with `a static extension list`_ of around 1,500 file extensions.
As new extensions are regularly created this list needs maintenance.
Future releases of Ransomware Protection will include an updated list and the ability to update the list via syncing with `FSRM's API`_ by using :doc:`occ <../occ_command>`.

.. _ransomeware_protection_label:

Protection: Data Retention and Rollback
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While Ransomware Prevention mitigates risks of a range of ransomeware attacks, it is not a future-proof solution, because ransomeware is becoming ever-more sophisticated.
There are known attacks that change file extensions randomly or keep them unchanged which makes them harder to detect.

Ultimately there is a consensus that only one solution can provide future-proof protection from ransomeware attacks: retaining data and providing the means to roll back to a particular point in time.

ownCloud Ransomware Protection will, therefore, record all changes on an ownCloud Server and allow administrators to rollback user data to a particular point in time, making use of ownCloud’s integrated Versioning and Trash bin features.

Doing so allows all user data that is synchronized with the server to be rolled back to its state before the attack occurred.
A combination of Ransomware prevention and protection reduces risks to a minimum acceptable level.

Other Elements of Ransomware Protection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

==================== ============================================== ================================================
Name                 Command                                        Description
==================== ============================================== ================================================
Ransomguard Scanner  ``occ ransomguard:scan <timestamp> <user>``    A command to scan the ownCloud database for
                                                                    changes in order to discover anomalies in a 
                                                                    user's account and their origin. It enables an 
                                                                    administrator to determine the point in time
                                                                    where undesired actions happened as a
                                                                    prerequisite for restoration.
Ransomguard Restorer ``occ ransomguard:restore <timestamp> <user>`` A command for administrators to revert all
                                                                    operations in a user account that occurred after
                                                                    a certain point in time.
==================== ============================================== ================================================

.. note:: 
   ``<timestamp>`` must be in `the Linux timestamp format`.

Requirements
~~~~~~~~~~~~

#. **Ransomware Protection.** Ransomware protection needs to be in operation before an attack occurs, as it needs to record file operations to be able to revert them, in case of an attack.
#. **ownCloud Versions App.** Required to restore older file versions. The capabilities of Ransomware Protection depend on its configuration regarding version retention.
#. **ownCloud Trash Bin App.** Required to restore deleted files. The capabilities of Ransomware Protection depend on its configuration regarding trash bin retention.

Limitations
~~~~~~~~~~~

- Ransomware Protection works with master-key based storage encryption. With credential-based storage encryption, only Ransomware Prevention (Blocking) works.
- Rollback is not based on snapshots:

  * The `trash bin retention policy`_ may delete files, making them unrecoverable. To avoid this, set ``trashbin\_retention\_obligation`` to ``disabled``, or choose a conservative policy for trash bin retention. However, please be aware that this may increase storage requirements.
  * Trash bin items may be deleted by the user making them unrecoverable by Ransomware Protection => Users need to know this.
  * Versions have `a built-in "thin-out" policy`_ which makes it possible that required file versions are unrecoverable by Ransomware Protection. To help avoid this, set ``versions\_retention\_obligation`` to ``disabled`` or choose a conservative policy for version retention. Please be aware that this might increase your storage needs.
  * A specific version of a file that is needed for rollback might have been manually restored, making this version potentially unrecoverable by Ransomware Protection. Currently, after restoration the restored version `is not a version anymore`, e.g., the version is not present in versioning.

- Contents in secondary storages, such as *Windows network drives*, *Dropbox*, and *Google Drive*, are unrecoverable by Ransomware Protection, because they do not have versioning or trash bin enabled in ownCloud.
- Rolling files forward is not *currently* supported or tested. Therefore it is vital to:

  * Carefully decide the point in time to rollback to.
  * To have proper backups to be able to conduct the rollback again, if necessary.

.. Links

.. _trash bin retention policy: https://doc.owncloud.com/server/10.0/admin\_manual/configuration/server/config\_sample\_php\_parameters.html?highlight=trash%20bin#deleted-items-trash-bin
.. _a built-in "thin-out" policy: https://doc.owncloud.com/server/10.0/admin\_manual/configuration/server/config\_sample\_php\_parameters.html?highlight=trash%20bin#file-versions
.. _is not a version anymore: https://github.com/owncloud/core/issues/29666
.. _an ever-present threat: https://www.google.de/search?q=ransomeware&source=lnms&tbm=nws&sa=X&ved=0ahUKEwiqmvL9rdfXAhWCyaQKHSkgDosQ_AUICigB&biw=1680&bih=908
.. _a static extension list: https://fsrm.experiant.ca
.. _FSRM's API: https://fsrm.experiant.ca/api/v1/combined
.. _the Linux timestamp format: https://en.wikipedia.org/wiki/Unix_time
