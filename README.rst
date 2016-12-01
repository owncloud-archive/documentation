======================
ownCloud Documentation
======================

Documentation is published on `<https://doc.owncloud.org>`_ and 
`<https://doc.owncloud.com>`_.

The `documentation Wiki <https://github.com/owncloud/documentation/wiki>`_ is 
available for tips, tricks, edge cases, and anyone who wants to contribute more 
easily, without having to learn Git and Sphinx.

See the `Style Guide <https://github.com/owncloud/documentation/blob/master/style_guide.rst>`_ for formatting and style conventions.

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

Style Guide
-----------

For detailed information, please refer to `the ownCloud Style Guide <style_guide.rst>`_.
Otherwise, source files are written using the `Sphinx Documentation Generator
<http://sphinx.pocoo.org/>`_. The syntax follows the `reStructuredText
<http://docutils.sourceforge.net/rst.html>`_ style, and can also be edited
from GitHub.

License
-------

All documentation in this repository is licensed under the Creative Commons
Attribution 3.0 Unported license (`CC BY 3.0`_). You can find a local copy of 
the license in `LICENSE ./LICENSE`.

.. _CC BY 3.0: http://creativecommons.org/licenses/by/3.0/deed.en_US

Contributing
------------

To know how to contribute to this repository, please refer to `the contributing guide <CONTRIBUTING.rst>`_.

Building The Documentation
--------------------------

For detailed information, please refer to `the build guide <BUILD.rst>`_.

Importing Word and OpenDocument files
-------------------------------------

Sometimes, existing documentation might be in Word or LibreOffice format. To
make it part of this documentation collection, install the prerequisites and 
then run through the steps in the Process section.

Prerequisites
^^^^^^^^^^^^^

1. Install Python
2. Install odt2sphinx (``easy_install odt2sphinx``)
3. Install GCC/clang (`Xcode command line tools`_ required on Mac OS)

Process
^^^^^^^

1. ``doc/docx`` files need to be stored as odt first
2. Run ``odt2sphinx my.docx``
3. Move the resulting ``rst`` files in place and reference them
4. Wrap text lines at 80 chars, apply markup fixes

Then run the following commands to build the documentation::

  cd user_manual && make latexpdf

If you’re not on a headless box, then you can use `okular <https://en.opensuse.org/Okular>`_ 
to view the generated documentation by using the following command::

* okular _build/latex/ownCloudUserManual.pdf

.. _CC BY 3.0: http://creativecommons.org/licenses/by/3.0/deed.en_US
.. _`Xcode command line tools`: http://stackoverflow.com/questions/9329243/xcode-4-4-and-later-install-command-line-tools
