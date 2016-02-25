==================================
Configuring External Storage (GUI)
==================================

The External Storage Support application enables you to mount external storage
services and devices as secondary ownCloud storage devices. You may also allow
users to mount their own external storage services.

Enabling External Storage Support
---------------------------------

The External storage support application is enabled on your Apps page.

.. figure:: external_storage/images/enable_app.png
   :alt: Enable external storage on your Apps page.

Storage Configuration
---------------------

To create a new external storage mount, select an available backend from the
dropdown **Add storage**. Each backend has different required options, which
are configured in the configuration fields.

.. figure:: external_storage/images/add_storage.png

Each backend may also accept multiple authentication methods. These are selected
with the dropdown under **Authentication**. Different backends support different
authentication mechanisms; some specific to the backend, others are more
generic. See :doc:`external_storage/auth_mechanisms` for more detailed
information.

When you select an authentication mechanism, the configuration
fields change as appropriate for the mechanism. Some backends are not yet
migrated to
the new authentication mechanism system, and are displayed with a mechanism
of **Built-in**. The SFTP backend, to give an example, supports both
password-based authentication and public key authentication.

.. figure:: external_storage/images/auth_mechanism.png
   :alt: An SFTP configuration example.

Required fields are marked with a red border. When all required fields are
filled, the storage is automatically saved. A green dot next to the storage row
indicates the storage is ready for use. A red or yellow icon indicates
that ownCloud could not connect to the external storage, so you need to
re-check your configuration and network availability.

User and Group Permissions
--------------------------

A storage configured in a user's Personal settings is available only to the user
that created it. A storage configured in the Admin settings is available to
all users by default, and it can be restricted to specific users and groups in
the **Available for** field.

.. figure:: external_storage/images/applicable.png
   :alt: User and groups selector

.. _external_storage_mount_options_label:

Mount Options
-------------

Hover your cursor to the right of any storage configuration to expose
the settings button and trashcan. Click the trashcan to delete the
mountpoint. The settings button allows you to configure each storage mount
individually with the following options:

* Encryption
* Previews
* Filesystem check frequency (Never, Once per direct access, every time the
  filesystem is used)

.. figure:: external_storage/images/mount_options.png
   :alt: Additional mount options exposed on mouseover.

Using Self-Signed Certificates
------------------------------

When using self-signed certificates for external storage mounts the certificate
must be imported into the personal settings of the user. Please refer to
`ownCloud HTTPS External Mount
<http://ownclouden.blogspot.de/2014/11/owncloud-https-external-mount.html>`_
for more information.

Available storage backends
--------------------------

The following backends are provided by the external storages app. Other apps
may provide their own backends, which are not listed here.

.. toctree::
    :maxdepth: 1

    external_storage/amazons3
    external_storage/dropbox
    external_storage/ftp
    external_storage/google
    external_storage/local
    external_storage/openstack
    external_storage/owncloud
    external_storage/sftp
    external_storage/smb
    external_storage/webdav

.. note:: A non-blocking or correctly configured SELinux setup is needed
   for these backends to work. Please refer to the :ref:`selinux-config-label`.

Allow Users to Mount External Storage
-------------------------------------

Check **Enable User External Storage** to allow your users to mount their own
external storage services, and check the backends you want to allow. Beware, as
this allows a user to make potentially arbitrary connections to other services
on your network!

.. figure:: external_storage/images/user_mounts.png
   :alt: Checkboxes to allow users to mount external storage services.

Adding Files to External Storages
---------------------------------

We recommend configuring the background job **Webcron** or
**Cron** (see :doc:`../configuration_server/background_jobs_configuration`)
to enable ownCloud to automatically detect files added to your external
storages.

ownCloud may not always be able to find out what has been
changed remotely (files changed without going through ownCloud), especially
when it's very deep in the folder hierarchy of the external storage.

You might need to setup a cron job that runs ``sudo -u www-data php occ files:scan --all``
(or replace "--all" with the user name, see also :doc:`../configuration_server/occ_command`)
to trigger a rescan of the user's files periodically (for example every 15 minutes), which includes
the mounted external storage.

Configuration File
------------------

Storage mount configurations are stored in a JSON formatted file. Admin
storages are stored in ``data/mount.json``, while personal storages are stored
in ``data/$user/mount.json``. For more advanced use cases, including
provisioning external storages from outside ownCloud, see
:doc:`external_storage_configuration`.
