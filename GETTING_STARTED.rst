==============
Getting Started
==============

ownCloud Documentation Workflow
-------------------------------

This describes the workflow and required tools for writing and maintaining the 
ownCloud Admin, User, Developer, Desktop Sync Client, Android, and iOS client 
manuals.

Quickstart
----------

The documentation publishing workflow operates in this order:

Git > Sphinx > GitHub > Jenkins > doc.owncloud.com and doc.owncloud.org

To get started:

1. Clone the appropriate ownCloud GitHub repositories to your computer
2. Branch the appropriate repo, and then write and edit the docs using Sphinx/RST
3. Make local builds to test for errors
4. Commit and push your branch to GitHub and open a pull request
5. Tag the appropriate reviewers. You need two thumbs-up to merge
6. Backport as necessary using ``git cherry-pick``
7. Mr. Jenkins publishes all changes on GitHub

Required Accounts
-----------------

============================== =============================== =====================================
Account                        URL                             Notes
============================== =============================== =====================================
GitHub                         http://github.com
VPN                            ?
Jenkins                        https://rotor.int.owncloud.com/ Which is behind the VPN
ownCloud Customer Installation customer.owncloud.com/customer 
Docker Launcher                docker.oc.solidgear.es          Your ownCloud email details will work
ownCloud S3 Installation       s3.owncloud.com/owncloud/
============================== =============================== =====================================

Required Software
-----------------

#. Git
#. Sphinx Documentation Generator and Python
#. Python Image Library (PIL)
#. Sphinx PHPDomain
#. rst2pdf
#. LaTex. Install the whole works, which is several hundred megabytes.
#. VPN client, such as OpenVPN

The README on https://github.com/owncloud/documentation has instructions for setting 
up your build environment.

Release Updates
---------------

Sphinx/RST supports some variable substitutions, for example, see the title in 
``admin_manual/index.rst``, where the version is pulled from ``conf.py.``. 
However, some URLs have to be manually updated; ``grep`` is your best friend for 
finding these. 

Tracking Tasks
--------------

Put everything in a GitHub issue. When anyone suggests a correction, have them 
open an issue; even better - create a pull request. You can assign 
people to issues, give them milestones, labels, and sort and filter them.

Document Formats
----------------

The build system creates HTML pages and PDF manuals. ``conf.py`` controls 
version numbers, titles, and build options. Read the ``Makefile`` to see the 
complete list of output formats and commands.

The PDF manuals have formatting problems because they are generated from the 
same source files as the HTML pages. On the Web sites, images resize automatically 
according to the window size. 

But the PDFs print the original image size, and image placement in LaTex is 
always "fun". The solution may be to separate the HTML and PDF builds, if there is 
ever time and resources.

All Documentation Repos
-----------------------

The technical writer is the boss of these repos:

=================================== =========================================
Manual                              Url
=================================== =========================================
Admin, User, and Developer manuals. https://github.com/owncloud/documentation
Index page for doc.owncloud.com     https://github.com/owncloud/doc-index-com
Index page for doc.owncloud.org     https://github.com/owncloud/doc-index-org
=================================== =========================================
  
Any GitHub member can contribute to `the Documentation Wiki <https://github.com/owncloud/documentation/wiki>`_   

The manuals are integrated into the following repos, so the technical writer follows their 
rules for publishing changes.

============================ ===================================================
Manual                       Url
============================ ===================================================
Android app manual           https://github.com/owncloud/android
Desktop sync client manual   https://github.com/owncloud/client
iOS app manual               https://github.com/owncloud/ios
Branded clients manual       https://github.com/owncloud/branded_clients
============================ ===================================================

The master config.sample.php https://github.com/owncloud/core/tree/master/config
 
https://doc.owncloud.org/server/latest/admin_manual/configuration/server/config_sample_php_parameters.html is manually generated from the master config.sample.php with the conversion script at https://github.com/MorrisJobke/ownCloud-config-converter Download the conversion script, make the conversion to ``config_sample_php_parameters.rst``, and then push it to GitHub like any other document.

=============================== ==========================================================================
Manual                          Url
=============================== ==========================================================================
ownCloud Appliance admin manual https://github.com/owncloud/enterprise/tree/master/appliance/vagrant/oc9ee
=============================== ==========================================================================

Obsolete Documentation
----------------------

Enterprise Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`This is obsolete <https://github.com/owncloud/documentation-enterprise>`_ and 
not used, but enterprise support people still post issues here. 

Manuals and owncloud.org
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
The repository for owncloud.org is https://github.com/owncloud/owncloud.org. owncloud.com has its own 
separate system somewhere. I have been marking obsolete manuals with an "Unsupported" banner. The .org site 
templates are in the ``_shared_assets`` directory. 

See https://github.com/owncloud/documentation/commit/26022bb489218120977592409755152e63973d19 
for example code, and https://doc.owncloud.org/server/latest/user_manual/ to see how it looks. The manuals are 
left up because they come up in Google searches, so the banner tells users where to find current manuals.

Pages
^^^^^^^^^^^^^^

When you remove manual pages or change the paths, the old pages remain on the server. This is a problem because the obsolete pages come up in Google searches. Keep track of these pages and open a ticket with the sysadmin team to delete them from the server. (There may be a way to do this in Jenkins.)

Put everything in a GitHub issue. When anyone suggests a correction, have them open an issue. (Even better is they create a pull request.) You can assign people to Issues, give them milestones, labels, and sort and filter them.

Document Formats
----------------

The build system creates HTML pages and PDF manuals. ``conf.py`` controls version numbers, titles, and build options. Read the ``Makefile`` to see the complete list of output formats and commands.

The PDF manuals have formatting problems because they are generated from the same source files as the HTML pages. On the Web sites images resize automatically according to window size. But the PDFs print the original image size, and image placement in LaTex is always "fun". The solution may be to separate the HTML and PDF builds, if there is ever time and resources.

All Documentation Repos
-----------------------

The technical writer is the boss of these repos:

=================================== =========================================
Manual                              Url
=================================== =========================================
Admin, User, and Developer manuals. https://github.com/owncloud/documentation
Index page for doc.owncloud.com     https://github.com/owncloud/doc-index-com
Index page for doc.owncloud.org     https://github.com/owncloud/doc-index-org
=================================== =========================================
  
Any GitHub member can contribute to `the Documentation Wiki <https://github.com/owncloud/documentation/wiki>`_   

The manuals are integrated into the following repos, so the technical writer follows their 
rules for publishing changes.

============================ ===================================================
Manual                       Url
============================ ===================================================
Android app manual           https://github.com/owncloud/android
Desktop sync client manual   https://github.com/owncloud/client
iOS app manual               https://github.com/owncloud/ios
Branded clients manual       https://github.com/owncloud/branded_clients
============================ ===================================================

The master config.sample.php https://github.com/owncloud/core/tree/master/config
 
https://doc.owncloud.org/server/latest/admin_manual/configuration/server/config_sample_php_parameters.html is manually generated from the master config.sample.php with the conversion script at https://github.com/MorrisJobke/ownCloud-config-converter Download the conversion script, make the conversion to ``config_sample_php_parameters.rst``, and then push it to GitHub like any other document.

=============================== ==========================================================================
Manual                          Url
=============================== ==========================================================================
ownCloud Appliance admin manual https://github.com/owncloud/enterprise/tree/master/appliance/vagrant/oc9ee
=============================== ==========================================================================

Obsolete Documentation
----------------------

Enterprise Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`This is obsolete <https://github.com/owncloud/documentation-enterprise>`_ and 
not used, but enterprise support people still post issues here. 

Manuals and owncloud.org
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
The repository for owncloud.org is https://github.com/owncloud/owncloud.org. owncloud.com has its own 
separate system somewhere. I have been marking obsolete manuals with an "Unsupported" banner. The .org site 
templates are in the ``_shared_assets`` directory. 

See https://github.com/owncloud/documentation/commit/26022bb489218120977592409755152e63973d19 
for example code, and https://doc.owncloud.org/server/latest/user_manual/ to see how it looks. The manuals are 
left up because they come up in Google searches, so the banner tells users where to find current manuals.

Pages
^^^^^^^^^^^^^^

When you remove manual pages or change the paths, the old pages remain on the server. This is a problem because the obsolete pages come up in Google searches. Keep track of these pages and open a ticket with the sysadmin team to delete them from the server. (There may be a way to do this in Jenkins.)
