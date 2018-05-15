=========================
Command Line Installation
=========================

ownCloud can be installed entirely from the command line. 
This is convenient for scripted operations and for systems administrators who prefer using the command line over a GUI. 
It involves five steps:

#. Ensure your server meets :ref:`the ownCloud prerequisites <prerequisites_label>`
#. Download and unpack the source
#. Install using the ``occ`` command
#. Set the correct owner and permissions
#. Optional post#.installation considerations

Let's begin. To install ownCloud, first `download the source`_ (whether community or enterprise) directly from ownCloud, and then unpack (decompress) the tarball into the appropriate directory.

With that done, you next need to set your webserver user to be the owner of your unpacked ``owncloud`` directory, as in the example below.

::

  $ sudo chown -R www-data:www-data /var/www/owncloud/

With those steps completed, next use the ``occ`` command, from the root directory of the ownCloud source, to perform the installation. 
This removes the need to run the `Graphical Installation Wizard`_. Here’s an example of how to do it

::

 # Assuming you’ve unpacked the source to /var/www/owncloud/
 $ cd /var/www/owncloud/
 $ sudo -u www-data php occ maintenance:install \ 
    --database "mysql" --database-name "owncloud" \
    --database-user "root" --database-pass "password" \
    --admin-user "admin" --admin-pass "password" 

.. NOTE::
   You must run ``occ`` as your HTTP user. See :ref:`http_user_label`

If you want to use a directory other than the default (which is `data` inside the root ownCloud directory), you can also supply the ``--data-dir`` switch.
For example, if you were using the command above and you wanted the data directory to be ``/opt/owncloud/data``, then add ``--data-dir /opt/owncloud/data`` to the command.
 
When the command completes, apply the correct permissions to your ownCloud files and directories (see :ref:`strong_perms_label`). This is extremely important, as it helps protect your ownCloud installation and ensure that it will operate correctly.
See :ref:`command_line_installation_label` for more information.

.. Links

.. _download the source: https://owncloud.org/install/#instructions-server 
.. _Graphical Installation Wizard: installation_wizard.html
