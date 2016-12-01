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
  
Please work in the appropriate branch. Stable8 is 8.0, stable8.1 is 8.1, stable8.2 is 8.2, stable9 is 9.0, stable9.1 is 9.1, and master is 9.2.

.. note:: ``configuration_server/config_sample_php_parameters.rst`` is auto-generated from the core
   config.sample.php file; changes to this file must be made in core `<https://github.com/owncloud/core/tree/master/config>`_

Spelling and Capitalization Conventions
---------------------------------------

As this grows it may be moved to its own page.

* ownCloud Apps Store
* synchronize
* Web (Web page, Web site)

License
-------

All documentation in this repository is licensed under the Creative Commons
Attribution 3.0 Unported license (`CC BY 3.0`_). You can find a local copy of 
the license in `LICENSE ./LICENSE`.

.. _CC BY 3.0: http://creativecommons.org/licenses/by/3.0/deed.en_US

Style
-----

Source files are written using the `Sphinx Documentation Generator
<http://sphinx.pocoo.org/>`_. The syntax follows the `reStructuredText
<http://docutils.sourceforge.net/rst.html>`_ style, and can also be edited
from GitHub.
Contributing
------------

Contributing to the documentation requires `a Github account <https://github.com/>`_. 
Make sure you are working in the correct branch for your version of ownCloud or 
client apps. If your edits pertain to multiple manual versions, be prepared to 
backport as needed.

To edit a document, you can edit the .rst files on your local system, or work 
directly on Github. The latter is only suitable for small fixes and improvements 
because substantial editing efforts are easier on your local PC. 

The best way is to install a complete Sphinx build environment and work on your 
local machine. You will be able to make your own local builds, which is the fastest 
and best way to preview for errors. 

Sphinx will report syntax errors, missing images, and formatting errors. The 
Github preview is not complete and misses many mistakes. 

Create a new branch against the master or stable branch you are editing, make 
your edits, then push your new branch to Github and open a new PR. 

To edit on Github, `fork the repository <https://help.github.com/articles/fork-a-repo/>`_ 
(see top-right of the screen, under your username). You will then be able to make 
changes easily. Once done, you can `create a pull request <https://help.github.com/articles/creating-a-pull-request/>`_ and get the changes reviewed and back into the official repository.

Installing The Required Dependencies
------------------------------------

Linux and OS X
^^^^^^^^^^^^^^

Regardless of whether you’re using a Linux distribution, or Mac OSX, firstly, 
make sure that the following are installed:

* Python
* `Python Image Library (PIL) <http://effbot.org/imagingbook/pil-index.htm>`_
* `Sphinx <http://www.sphinx-doc.org>`_
* `Sphinx PHPDomain <https://pypi.python.org/pypi/sphinxcontrib-phpdomain>`_
* `rst2pdf <https://github.com/rst2pdf/rst2pdf>`_

If you're on Arch Linux, the build script is called sphinx-build2 which
will fail. You will need to provide a link to the expected script name::

     sudo ln -s /usr/bin/sphinx-build2 /usr/bin/sphinx-build

...then enter any manual directory, then run ``make html``. The result can
be found in the ``_build/html`` subdirectory.  PDFs can be built with the
``make latexpdf`` command and are found in _build/latex/ directory.

The openSUSE way
~~~~~~~~~~~~~~~~

First add the repository "devel:languages:python". How 
this is done depends on your installation of openSUSE and the hardware 
architecture. For detailed instructions, refer to `the SUSE documentation <https://software.opensuse.org/download.html?project=devel:languages:python&package=bpython>`_. 
As an example, if you are using openSUSE 42.1, then you would run the following
commands::

  sudo zypper addrepo http://download.opensuse.org/repositories/devel:languages:python/openSUSE_Leap_42.1/devel:languages:python.repo \
    && sudo zypper refresh

After that, install the base dependencies, by running the following commands::

  sudo zypper in python-Sphinx python-rst2pdf python-sphinxcontrib-phpdomain \
    texlive-pdfjam texlive-threeparttable texlive-wrapfig texlive-multirow

The Debian/Ubuntu way
~~~~~~~~~~~~~~~~~~~~~

To build the manual, first install the base dependencies, by 
running the following commands::

  sudo apt-get install python-pil python-sphinx python-sphinxcontrib.phpdomain \
    rst2pdf texlive-fonts-recommended texlive-latex-extra texlive-latex-recommended

The Arch Linux way
~~~~~~~~~~~~~~~~~~

To build the manual, first install the base dependencies, by 
running the following commands::

  sudo pacman-key --noconfirm --refresh-keys && \ 
  sudo pacman --noconfirm -Syy && \ 
  sudo pacman --noconfirm -S community/python2-rst2pdf community/python2-sphinx \ 
    extra/texlive-core texlive-latexextra 

  sudo easy_install -U sphinxcontrib-phpdomain

Windows
^^^^^^^

Running ``setup.cmd`` will install Python 2.7 and install all dependencies.
Enter any manual and clicking the "Build HTML" shortcut will create a HTML
build. Likewise, "Build PDF" will build the PDF using the more lightweight,
but feature-incomplete RST2PDF tool. The results are in ``_build/html`` and
``_build/pdf`` respectively.

Building The Documentation
--------------------------

With the dependencies installed, build the documentation by running the 
following commands::

  cd user_manual && make latexpdf

The generated documentation will be located in ``_build/latex/``.

Viewing The Documentation
--------------------------

Linux
^^^^^

If you’re not on a headless box, then you can use one of the many PDF viewers 
available for Linux. These include:

* `evince <https://wiki.gnome.org/Apps/Evince>`_ 
* `okular <https://en.opensuse.org/Okular>`_
* `xpdf <http://www.foolabs.com/xpdf/home.html>`_
* `gv <https://www.gnu.org/software/gv/>`_
* `qpdfview <https://launchpad.net/qpdfview>`_

If you’re using a headless box you can use ``less``. But you will need to have 
``pdftotext`` installed as well. 

Mac OSX
^^^^^^^

You can either use the built-in Preview app, or `download <https://get.adobe.com/uk/reader/>`_ 
and install a copy of Adobe Acrobat Reader and use that to view the documentation.

Windows
^^^^^^^

You will likely have a copy of Adobe Acrobat Reader installed. If not, 
`download <https://get.adobe.com/uk/reader/>`_ and install a copy and use that 
to view the documentation.

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

.. _CC BY 3.0: http://creativecommons.org/licenses/by/3.0/deed.en_US
.. _`Xcode command line tools`: http://stackoverflow.com/questions/9329243/xcode-4-4-and-later-install-command-line-tools
