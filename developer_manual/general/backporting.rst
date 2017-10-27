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

Because pushing directly to particular ownCloud branches is forbidden (e.g., ``origin/stable-xx``), you need to create your own remote branch, based off of the branch that you wish to backport to.
However, doing so can involve a number of manual steps.
To reduce the effort and time involved, use the script below instead.

.. code-block:: console

  #!/bin/bash
  set -e

  if [ "$#" -lt 2 ]; then
      echo "Illegal number of parameters"
      echo "  $0 <commit-sha> <targetBranchName>"
      echo "  For example: $0 123456789 stable10"
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

Assuming that you store the script in a file called ``backport.sh``, the command would be called as follows:

.. code-block:: console

  ./backport.sh 123456 stable10

.. note:: 
   When doing this yourself, remember to adapt the commit hash and the target branch accordingly.

When the script completes, go to GitHub, where it will suggest that you make a PR from pushed branch. 
Change the base branch to be committed against, from ``master`` to ``stable10`` and continue.

In case you have installed the ``xdg-utils`` package, you can add at the end of the 
script above following code which opens the PR to be finalized in your browser:

.. code-block:: console

  repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*github.com[:/]\(.*\)\.git.*/\1/"`
  branch=`git name-rev --name-only HEAD`
  echo "Creating pull request for branch \"$branch\" in \"$repo\""
  
  xdg-open "https://github.com/$repo/pull/new/$targetBranch...$branch"
