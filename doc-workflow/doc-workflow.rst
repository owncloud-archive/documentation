.. This will not build. It is kept in 
.. the documentation repository for easy access.
.. Created Nov. 28, 2016

===============================
ownCloud Documentation Workflow
===============================

This describes the workflow and required tools for writing and maintaining the ownCloud Admin, User, Developer, Desktop Sync Client, Android, and iOS client manuals.

Quickstart
----------

The documentation publishing workflow operates in this order:

Git > Sphinx > GitHub > Jenkins > doc.owncloud.com and doc.owncloud.org

Clone the appropriate ownCloud GitHub repos to your PC.
Branch the appropriate repo, and then write and edit the docs using Sphinx/RST.
Make local builds to test for errors.
Commit and push your branch to GitHub and open a pull request.
Tag the appropriate reviewers. You need two thumbs-up to merge.
Backport as necessary using ``git cherry-pick``.
Mr. Jenkins publishes all changes on GitHub.

Required accounts
-----------------
GitHub, VPN, Jenkins https://rotor.int.owncloud.com/ (Jenkins is behind the VPN), customer.owncloud.com/customer, Docker launcher docker.oc.solidgear.es, s3.owncloud.com/owncloud/

Required software:

#. Git
#. Sphinx Documentation Generator and Python
#. Python Image Library (PIL)
#. Sphinx PHPDomain
#. rst2pdf
#. LaTex. Install the whole works, which is several hundred megabytes.
#. VPN client, such as OpenVPN

The README on https://github.com/owncloud/documentation has instructions for setting up your build environment.

Tracking Tasks
--------------

Put everything in a GitHub issue. When anyone suggests a correction, have them open an issue. (Even better is they create a pull request.) You can assign people to Issues, give them milestones, labels, and sort and filter them.

All Documentation Repos
-----------------------

The technical writer is the boss of these repos.

Admin, User, and Developer manuals. 
 https://github.com/owncloud/documentation
  
Index page for doc.owncloud.com 
 https://github.com/owncloud/doc-index-com
 
Index page for doc.owncloud.org 
 https://github.com/owncloud/doc-index-org
 
Documentation Wiki, any GitHub member can contribute
 https://github.com/owncloud/documentation/wiki 
 
The manuals are integrated into the following repos, so the technical writer follows their rules for publishing changes.
 
Android app manual 
 https://github.com/owncloud/android

Desktop sync client manual
 https://github.com/owncloud/client
 
iOS app manual 
 https://github.com/owncloud/ios
 
Branded clients manual
 https://github.com/owncloud/branded_clients
 
The master config.sample.php
 https://github.com/owncloud/core/tree/master/config
 
https://doc.owncloud.org/server/9.2/admin_manual/configuration_server/config_sample_php_parameters.html is manually generated from the master config.sample.php with the conversion script at https://github.com/MorrisJobke/ownCloud-config-converter Download the conversion script, make the conversion to ``config_sample_php_parameters.rst``, and then push it to GitHub like any other document.

ownCloud Appliance admin manual
 https://github.com/owncloud/enterprise/tree/master/appliance/vagrant/oc9ee
 
Enterprise documentation repo. This is obsolete and not used, but enterprise support people still post issues here. 
 https://github.com/owncloud/documentation-enterprise
 
 owncloud.org and Obsolete Manuals
 ---------------------------------
 
The repository for owncloud.org is https://github.com/owncloud/owncloud.org. owncloud.com has its own separate system somewhere. I have been marking obsolete manuals with an "Unsupported" banner. The .org site templates are in the ``_shared_assets`` directory. See https://github.com/owncloud/documentation/commit/26022bb489218120977592409755152e63973d19 for example code, and https://doc.owncloud.org/server/8.0/user_manual/ to see how it looks. The manuals are left up because they come up in Google searches, so the banner tells users where to find current manuals.

Obsolete Pages
--------------

When you remove manual pages or change the paths, the old pages remain on the server. This is a problem because the obsolete pages come up in Google searches. Keep track of these pages and open a ticket with the sysadmin team to delete them from the server. (There may be a way to do this in Jenkins.)

 

