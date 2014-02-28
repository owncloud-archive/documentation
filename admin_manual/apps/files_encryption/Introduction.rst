Introduction
============

ownCloud contains an encryption app which, when enabled, encrypts all files stored in ownCloud.
The encryption is done automatically once the admin enables the app.
All encryption and decryption occur on the ownCloud server, which allows the user to continue to use other apps to view and edit the data.

The user’s password is used as the key to decrypt their data.
This means that if the user loses their login password, data will be lost.
To protect against password loss, the recovery key may be used as described in a later section.

What gets encrypted?
--------------------

All files stored in ownCloud will be encrypted with the following exceptions:

*   Old versions (versions created prior to enabling the encryption app)



*   Old files in the trash bin (files deleted prior to enabling the encryption app)



*   Existing files on external storage.
    Only new files placed on the external storage mount after encryption was enabled are encrypted.



*   Image thumbnails from the gallery app



*   Search index form the full text search app.



Decrypting the data
-------------------

If the encryption app is disable, users will get the following message alerting them how to decrypt their files.

|100000000000023B000000125381F51B_png|

Navigating to the Personal settings page, the user can enter their password and decrypt all files.

|100000000000018B000000A090F31164_png|

.. |100000000000023B000000125381F51B_png| image:: images/100000000000023B000000125381F51B.png
    :width: 5.948in
    :height: 0.1874in


.. |100000000000018B000000A090F31164_png| image:: images/100000000000018B000000A090F31164.png
    :width: 4.1146in
    :height: 1.6665in

