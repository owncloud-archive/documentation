====================
ownCloud Test Pilots
====================

.. toctree::
   :maxdepth: 2
   :hidden:

The ownCloud Test Pilots help to test and improve different server and client setups with ownCloud.

What do you do
--------------

You will receive emails from the mailing list and also from the bug tracker if developers need your help. 
Also, there will be announcements of new releases and preview releases on the mailing list, which give you the possibility to test releases early and to help the developers fix them.

We are looking forward to working with you :)

Why do you want to join
-----------------------

There are many different setups, and people have different interests. 
If we want ownCloud to run well on NGINX, for instance, someone has to test this configuration.
Furthermore, during bug fixing the ownCloud developers often do not have the possibility to reproduce the bug in a given environment, nor are they able confirm if it was fixed. 

As a member of the Test Pilot Team you could act as a contact person for a particular area to help developers **fix the bugs you care about**. 
Testing ownCloud before it is released is the best way of making sure it does what you need.

Another benefit is a closer relationship with the developers, because you will know which people are responsible for which parts, and it will be easier to get help.

If you want, you can also be listed as an active contributor on the `owncloud.org <https://owncloud.org>`_ page.

Who can join
------------

Anyone who is interested in improving the quality on his/her setup and is willing to communicate with developers and other testers.

How do you join
---------------

Just register on the `testpilot mailing list <https://mailman.owncloud.org/mailman/listinfo/testpilots>`_ and send an introduction containing your personal setup and interests to `testpilots@owncloud.org <testpilots@owncloud.org>`_
For further questions or help you can also send a mail to mstingl@owncloud.com.

How do you test
---------------

Testing follows these steps:

#. Setup your testing environment
#. Pick something to test
#. Test it
#. Go Back to step 2 until something unexpected/bad happens
#. Check if what you found is a genuine bug
#. File the bug

Installing ownCloud
-------------------

Testing starts with setting up a testing environment. 
We urge you not to put your production data on testing releases unless you have a backup somewhere!

Start by installing ownCloud, either on real hardware or in a VM.
You can find instructions for installation in the `documentation <https://doc.owncloud.org/server/latest/admin_manual/installation/>`_.

Please note that we are still working on the documentation and if you bump into a problem, you can `help us fix it <https://github.com/owncloud/documentation>`_. 
Small things can be edited straight on GitHub.

The Real Testing
----------------

Testing is a matter of trying out some scenarios you decide on or were asked to test, for example, sharing a folder and mounting it on another ownCloud instance. 
If it works – awesome, move on. 
If it doesn't, find out as much as you can about why it doesn't and use that for a bug report.

This is the stage where you should see if your issue is already reported by checking :doc:`the relevant bug tracker <../bugtracker/index>`. 
It might even be fixed, sometimes! 
Alternatively, just ask on the test-pilots mailing list.

Finally, if the issue you bump into is a definite bug and the developers are not aware of it, file it as a new issue in :doc:`the relevant bug tracker <../bugtracker/index>`. 

.. Links
   
.. _the issue tracker: https://github.com/owncloud/core/issues
