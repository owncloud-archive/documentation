File Systems
============

Once enabled, all files within ownCloud are encrypted, with the exceptions mentioned above.
This includes files in local storage, as well as files contained within external storage mounts.

The encryption app creates several key files/folders when enabled.
~/data/public-keys contains the public keys for all users, and ~/data/owncloud_private_keys contains system wide private keys utilized for public link shares as well as the recovery key.

|10000000000002C700000048F3729BAA_png|

The encryption app stores key information in the ~/data/<user>/files_encryption directory.

|100000000000024400000027BEE1E4A9_png|

As mentioned previously, the private key is generated from the user’s password.

Each file that the user owns will have a corresponding keyfile maintained in the keyfiles directory.

|100000000000026E0000003672ADCB6E_png|

In addition a share key will be generated for each file in the event that there is an external storage mount by the admin for multiple users or groups.

|100000000000029F000000B8A83D0275_png|

When viewing a file directly on the ownCloud data directory, it will show up as encrypted.

|10000000000002B30000003A5B960711_png|

However, viewing the same file via the browser, the actual contents of the file are displayed.

|10000000000001A40000006C954442CE_png|




.. |10000000000002C700000048F3729BAA_png| image:: images/10000000000002C700000048F3729BAA.png
    :width: 6.5in
    :height: 0.6583in


.. |100000000000024400000027BEE1E4A9_png| image:: images/100000000000024400000027BEE1E4A9.png
    :width: 6.0417in
    :height: 0.4063in


.. |100000000000029F000000B8A83D0275_png| image:: images/100000000000029F000000B8A83D0275.png
    :width: 6.5in
    :height: 1.7819in


.. |100000000000026E0000003672ADCB6E_png| image:: images/100000000000026E0000003672ADCB6E.png
    :width: 6.4791in
    :height: 0.5626in


.. |10000000000001A40000006C954442CE_png| image:: images/10000000000001A40000006C954442CE.png
    :width: 4.3752in
    :height: 1.1252in


.. |10000000000002B30000003A5B960711_png| image:: images/10000000000002B30000003A5B960711.png
    :width: 6.5in
    :height: 0.5457in

