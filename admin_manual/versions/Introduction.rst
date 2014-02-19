Introduction
============

The ownCloud Versions app maintains older versions of a file which have been modified by an ownCloud user.

Expiry of versions
------------------

The versions app expires old versions automatically to make certain that the user doesn’t run out of space.
The following algorithm is used to delete old versions:

*   ownCloud keeps one new version every 2 seconds for the first 10 seconds



*   ownCloud keeps one new version every minute for the first hour



*   ownCloud keeps one new version every hour for the first 24 hours



*   ownCloud keeps one new version every day for the first 30 days



*   ownCloud keeps one new version every week thereafter.



The versions are adjusted along this algorithm every time a new version is created.

Space limitations
-----------------

In addition to the expiry of versions, ownCloud’s versions app makes certain never to use more than 50% of the user’s currently available free space.
If stored versions exceed this limit, ownCloud will delete the oldest versions first until it meets this limit.

