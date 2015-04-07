===================================================
Enabling Anonymous Uploads with File Drop (ES Only)
===================================================

The File Drop application, introduced in ownCloud 8.0.3 Enterprise 
Subscription, allows anyone to upload files with the click of a button to the 
directory of your choosing, without needing a login, and they cannot see or 
change the contents of the directory. It is the perfect replacement for 
attaching large files to email, maintaining an FTP server, and commercial 
file-sharing services.

When files are uploaded to your File Drop directory, you can manage them just 
like any other ownCloud share: you may share them, restrict access, edit, and 
delete them.

Setting Up the File Drop App
-----------------------------

Setting up File Drop is a matter of a few clicks. First go to your Apps page 
and enable it. You may optionally restrict it to certain user groups.

.. image:: ../images/files-drop-1.png

Now, all users who are authorized to use the File Drop app will see a 
configuration section on their Personal pages.

.. image:: ../images/files-drop-2.png

Click the **Choose** button to open a dialog to select your upload directory. 
You may wish to first create a special upload directory (on your Files page), 
which in the following example is name **upload**.

.. figure:: ../images/files-drop-3.png
   :scale: 50% 
   
   *Click to enlarge*
   
Now on your Personal page you should see a URL for your upload directory. Give 
this URL to whoever you want to enable them to upload files to you. Note that 
the maximum upload size in this example is 4GB. (The default upload file size 
limit is 512MB. See :doc:`../configuration_files/big_file_upload_configuration` 
to learn how to customize this.)

.. image:: ../images/files-drop-4.png

Using the File Drop App
------------------------

Uploading files via the File Drop app is very simple. Open your Web 
browser to the appropriate URL:

.. figure:: ../images/files-drop-5.png
   :scale: 50% 

   *Click to enlarge*

Click the **Click to upload file** button. This opens a file picker, and you 
select the file or directory you want to upload.


.. figure:: ../images/files-drop-6.png
   :scale: 50% 

   *Click to enlarge*
   
When your upload is completed, you'll see a confirmation message with the 
filenames.

.. figure:: ../images/files-drop-7.png

