Backporting
===========

.. sectionauthor:: Morris Jobke, Jos Poortvliet

General
-------

We backport important fixes and improvements from the current master release to get them to our users faster.

Process
-------

We mostly consider bug fixes for back porting. Occasionally, important changes to the API can be backported to make it easier for developers to keep their apps working between major releases. If you think a pull request (PR) is relevant for the stable release, go through these steps:

1. Make sure the PR is merged to master
2. Ask the feature maintainer if the code should be backported and add the label `backport-request <https://github.com/owncloud/core/labels/Backport-Request>`_ to the PR
3. If the maintainer say yes then create a new branch based on the respective stable branch, cherry-pick the needed commits to that branch and create a PR on GitHub.
4. Specify the corresponding milestone for that series to this PR and reference the original PR in there. This enables the QA team to find the backported items for testing and having the original PR with detailed description linked.

.. note:: Before each patch release there is a freeze to be able to test everything as a whole without pulling in new changes. This freeze is announced on the `owncloud-devel mailinglist <https://mailman.owncloud.org/pipermail/devel/>`_. While this freeze is active a backport isn't allowed and has to wait for the next patch release.

The QA team will try to reproduce all the issues with the X.Y.Z-next-maintenance milestone on the relevant release and verify it is fixed by the patch release (and doesn't cause new problems). Once the patch release is out, the post-fix -next-maintenance is removed and a new -next-maintenance milestone is created for that series.

Steps
-------

Because pushing directly to particular branches of ownCloud like stable versions is forbidden,
(eg. no direct push to origin/stable-xx) you need to create your own remote branch and set the 
base for this PR correctly.
Following example is a backport of commit ``123456`` in PR ``789`` to branch ``stable10``.
Adopt the referenced commit-sha to be backported and the target branch accordingly.

You can ease the process by using the script below.
Assuming you name the script ``backport.sh``, the command would look like:
``./backport.sh 123456 stable10``

When done, go to GitHub and it will suggest that you make a PR from that branch. 
Change the base to be comitted against from ``master`` to ``stable10`` and continue.

.. code-block::

  #!/bin/bash
  set -e
  if [ "$#" -lt 2 ]; then
      echo "Illegal number of parameters"
      echo "  $0 <commit-sha> <targetBranchName>"
      echo "Example: $0 123456789 stable10"
      exit
  fi
  commit=$1
  targetBranch=$2
  echo "backporting $commit to $targetBranch"

  git fetch -p
  git checkout $targetBranch
  git pull --rebase
  git checkout -b $targetBranch-$commit
  git cherry-pick $commit || git cherry-pick -m 1 $commit

  message=`git log -1 --pretty=%B`
  git commit --amend -m "[$targetBranch] $message"
  git push origin $targetBranch-$commit

