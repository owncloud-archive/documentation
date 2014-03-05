File Systems
============

Once enabled, all files within ownCloud are encrypted, with the exceptions mentioned above.
This includes files in local storage, as well as files contained within external storage mounts.

The encryption app creates several key files/folders when enabled.
``~/data/public-keys`` contains the public keys for all users, and ``~/data/owncloud_private_keys`` contains system wide private keys utilized for public link shares as well as the recovery key.

.. code-block:: console

  root@server:/var/www/owncloud/data# ls
  files_encryption/  mount.json  owncloud.log           public-keys/ yogi/
  index.html         oc6admin/   owncloud_private_key/  user1/

The encryption app stores key information in the ``~/data/<user>/files_encryption`` directory.

.. code-block:: console

  root@server:/var/www/owncloud/data/user1/encryption# ls
  keyfiles/ user1.private.key share-keys/

As mentioned previously, the private key is generated from the user’s password.

Each file that the user owns will have a corresponding keyfile maintained in the keyfiles directory.

.. code-block:: console

  root@server:/var/www/owncloud/data/user1/files_encryption/keyfiles# ls
  documents/ ownCloud undelete.docx.key photos/
  music/     ownCloudUserManual.pdf.key test encryption.txt.key

In addition a share key will be generated for each file in the event that there is an external storage mount by the admin for multiple users or groups.

.. code-block:: console

  root@server:/var/www/owncloud/data/user1/files_encryption/share-keys# ls
  documents/
  music/
  ownCloud undelete.docx.recovery_5dcce10a.shareKey
  ownCloud undelete.docx.user1.shareKey
  ownCloudUserManual.pdf.recovery_5dcce10a.shareKey
  ownCloudUserManual.pdf.user1.shareKey
  photos/
  test encryption.txt.recovery_5dcce10a.shareKey
  test encryption.txt.user1.shareKey
  ...

When viewing a file directly on the ownCloud data directory, it will show up as encrypted.

.. code-block:: console

  root@server:/var/www/owncloud/data/user1/files# more test\ encryption.txt
  2JnmDdDh//8FVcDhLrnD1WH0JjhrzKpFKV6V61pAfUCu9IJX00iv007Yw3Tf/QBbtJFpQFxx
  
However, viewing the same file via the browser, the actual contents of the file are displayed.

.. image:: images/edit_encrypted_file.png

