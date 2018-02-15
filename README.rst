======================
ownCloud Documentation
======================

This repository stores the official documentation for ownCloud. Here, you will 
find all the information that you need to contribute to the official
documentation. 

The documentation is published on `<https://doc.owncloud.org>`_ and 
`<https://doc.owncloud.com>`_. A `documentation Wiki <https://github.com/owncloud/documentation/wiki>`_ 
is available for tips, tricks, edge cases, and anyone who wants 
to contribute more easily, without having to learn Git and Sphinx.

Manuals
-------

This repository hosts three manuals:

* **Users' Manual**
* **Administration Manual**
* **Developers Manual** 
  
Please work in the appropriate branch. 

* Stable8 is 8.0
* Stable8.1 is 8.1
* Stable8.2 is 8.2
* Stable9 is 9.0
* Stable9.1 is 9.1
* Master is 9.2

.. note:: ``configuration_server/config_sample_php_parameters.rst`` is auto-generated from the core
   config.sample.php file; changes to this file must be made in core `<https://github.com/owncloud/core/tree/master/config>`_

How To Create An Issue
----------------------

For detailed information on how to create an issue in the documentation
repository, please refer to `the "How To Create An Issue" guide
<CREATING_ISSUES.rst>`_. 

This process overrides **all** previous practices and aims to formalize and
simplify the process of creating requests for change within the ownCloud
documentation. 

Issues should no longer be created in any of the other ownCloud repositories.
Doing so makes it too difficult and time-intensive to stay on top of all the
requests for change relating to documentation. 

What’s more, issues created in other repositories may be closed without being
actioned (though more than likely they’ll be gently requested to be recreated
within this repository).

Style Guide
-----------

For detailed information, please refer to `the ownCloud Style Guide <style_guide.rst>`_.
Otherwise, source files are written using the `Sphinx Documentation Generator
<http://sphinx.pocoo.org/>`_. The syntax follows the `reStructuredText
<http://docutils.sourceforge.net/rst.html>`_ style, and can also be edited
from GitHub.

License
-------

All documentation in this repository is licensed under `the Creative Commons
Attribution 3.0 Unported license <http://creativecommons.org/licenses/by/3.0/deed.en_US>`_. 
You can find a local copy of the license in `LICENSE <LICENSE>`_.

Contributing
------------

To know how to contribute to this repository, please refer to `the contributing guide <CONTRIBUTING.rst>`_.

Building The Documentation
--------------------------

For detailed information, please refer to `the build guide <BUILD.rst>`_.

Importing Files
---------------

For detailed information, please refer to `the importing files guide <importing_files.rst>`_.
