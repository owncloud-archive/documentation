============
Contributing
============

Contributing to the documentation requires `a Github account <https://github.com/>`_. 
Make sure you are working in the correct branch for your version of ownCloud or 
client apps. If your edits pertain to multiple manual versions, be prepared to 
backport as needed.

To edit a document, you can edit the .rst files on your local system, or work 
directly on Github. The latter is only suitable for small fixes and improvements 
because substantial editing efforts are easier on your local PC. 

The best way is to install a complete Sphinx build environment and work on your 
local machine. You will be able to make your own local builds, which is the fastest 
and best way to preview for errors. Sphinx will report syntax errors, missing images, 
and formatting errors. The Github preview is not complete and misses many mistakes.

For details on how to setup a Sphinx build environment, have a read through the
`build instructions <BUILD.rst>`_.

Working On A Patch
------------------

We recommend you do each new feature or bugfix in a new branch. This simplifies
the task of review as well as the task of merging your changes into the
canonical repository.

A typical workflow will then consist of the following:

1. Create a new local branch based off either your master or develop branch.
2. Switch to your new local branch. (This step can be combined with the
   previous step with the use of ``git checkout -b``.)
3. Do some work, commit, repeat as necessary.
4. Push the local branch to your remote repository.
5. Send a pull request.

The mechanics of this process are actually quite trivial. Below, we will
create a branch for fixing an issue in the tracker.

::

    $ git checkout -b hotfix/9295
    Switched to a new branch 'hotfix/9295'

... do some work ...

::

    $ git commit

... write your log message ...::

    $ git push origin hotfix/9295:hotfix/9295
    Counting objects: 38, done.
    Delta compression using up to 2 threads.
    Compression objects: 100% (18/18), done.
    Writing objects: 100% (20/20), 8.19KiB, done.
    Total 20 (delta 12), reused 0 (delta 0)
    To ssh://git@github.com/owncloud/documentation.git
       b5583aa..4f51698  HEAD -> master

To send a pull request, you have two options.

If using GitHub, you can do the pull request from there. Navigate to
your repository, select the branch you just created, and then select the
"Pull Request" button in the upper right. Select the user/organization
"owncloud/documentation" as the recipient.

What Branch To Issue The Pull Request Against?
----------------------------------------------

Which branch should you issue a pull request against?

- For fixes against the stable release, issue the pull request against the
  "master" branch.
- For new features, or fixes that introduce new elements to the public API (such
  as new public methods or properties), issue the pull request against the
  "develop" branch.

Branch Cleanup
--------------

As you might imagine, if you are a frequent contributor, you'll start to
get a ton of branches both locally and on your remote.

Once you know that your changes have been accepted to the master
repository, we suggest doing some cleanup of these branches.

Local branch cleanup
~~~~~~~~~~~~~~~~~~~~

::

  $ git branch -d <branchname>

Remote branch removal
~~~~~~~~~~~~~~~~~~~~

::

  $ git push origin :<branchname>

Editing Directly On GitHub
--------------------------

To edit on Github, `fork the repository <https://help.github.com/articles/fork-a-repo/>`_ 
(see top-right of the screen, under your username). You will then be able to make 
changes easily. Once done, you can `create a pull request <https://help.github.com/articles/creating-a-pull-request/>`_ and get the changes reviewed and back into the official repository.

