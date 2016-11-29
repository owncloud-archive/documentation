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

All Documentation Repos
-----------------------

Admin, User, and Developer manuals
 https://github.com/owncloud/documentation
 
Android app manual 
 https://github.com/owncloud/android

Desktop sync client manual
 https://github.com/owncloud/client
 
iOS app manual 
 https://github.com/owncloud/ios
 
Branded clients manual
 https://github.com/owncloud/branded_clients

Index page for doc.owncloud.com 
 https://github.com/owncloud/doc-index-com
 
Index page for doc.owncloud.org
 https://github.com/owncloud/doc-index-org
 
The master config.sample.php
 https://github.com/owncloud/core/tree/master/config
 
https://doc.owncloud.org/server/9.2/admin_manual/configuration_server/config_sample_php_parameters.html is manually generated from the master config.sample.php with the conversion script at https://github.com/MorrisJobke/ownCloud-config-converter

ownCloud Appliance admin manual
 https://github.com/owncloud/enterprise/tree/master/appliance/vagrant/oc9ee
 
Enterprise installation READMEs on customer.owncloud.com/customer 

Enterprise documentation repo. This is obsolete and not used, but enterprise support people still post issues here. 
 https://github.com/owncloud/documentation-enterprise
 
Documenation Wiki, any GitHub member can contribute
 https://github.com/owncloud/documentation/wiki
 



 

 

