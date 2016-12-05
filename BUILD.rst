==========================
Building The Documentation
==========================

To build the documentation requires a working installation of a range of tools
which you can see listed in the `The Required Dependencies`_ section. 

You can install the dependencies manually, for your platform of choice, if you 
want. If so, the details for doing so start at the 
`Installing The Required Dependencies`_. 

However, you can also use a custom Vagrant/Ansible virtual machine, which 
contains all of the dependencies, along with a script to build the three 
manuals. You can find the details of setting that up in the 
`Building With The Virtual Machine`_ section.

The Required Dependencies
-------------------------

These are the minimum dependencies you will need to build the documentation:

* Python
* `Python Image Library (PIL) <http://effbot.org/imagingbook/pil-index.htm>`_
* `Sphinx <http://www.sphinx-doc.org>`_
* `Sphinx PHPDomain <https://pypi.python.org/pypi/sphinxcontrib-phpdomain>`_
* `rst2pdf <https://github.com/rst2pdf/rst2pdf>`_

Building With The Virtual Machine
---------------------------------

To use the Vagrant/Ansible-based virtual machine, from the root directory of the 
documentation, run ``vagrant up``. This will provision the virtual machine, if
it’s not already been provisioned. 

If this is the first time provisioning the virtual machine, it may take a while 
to download the base box, as it’s based on Ubuntu 16.04. However, after it’s 
been provisioned, then it should be relatively quick to boot.

Building Manually
-----------------

Installing The Required Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The openSUSE way
^^^^^^^^^^^^^^^^

First add the repository "devel:languages:python". How 
this is done depends on your installation of openSUSE and the hardware 
architecture. For detailed instructions, refer to `the SUSE documentation <https://software.opensuse.org/download.html?project=devel:languages:python&package=bpython>`_. 
As an example, if you are using openSUSE 42.1, then you would run the following
commands::

  sudo zypper addrepo http://download.opensuse.org/repositories/devel:languages:python/openSUSE_Leap_42.1/devel:languages:python.repo && sudo zypper refresh

After that, install the base dependencies, by running the following commands::

  sudo zypper in python-Sphinx python-rst2pdf python-sphinxcontrib-phpdomain texlive-pdfjam texlive-threeparttable texlive-wrapfig texlive-multirow

Alternatively, you can run ``./bin/unix/install-dependencies/opensuse.sh``.

The Debian/Ubuntu way
^^^^^^^^^^^^^^^^^^^^^

To build the manual, first install the base dependencies, by 
running the following commands::

  sudo apt-get install python-pil python-sphinx python-sphinxcontrib.phpdomain rst2pdf texlive-fonts-recommended texlive-latex-extra texlive-latex-recommended

Alternatively, you can run ``./bin/unix/install-dependencies/debian-ubuntu.sh``.

The Arch Linux way
^^^^^^^^^^^^^^^^^^

To build the manual, first install the base dependencies, by 
running the following commands::

  sudo pacman-key --noconfirm --refresh-keys 
  sudo pacman --noconfirm -Syy 
  sudo pacman --noconfirm -S community/python2-rst2pdf community/python2-sphinx extra/texlive-core texlive-latexextra 
  sudo easy_install -U sphinxcontrib-phpdomain

Alternatively, you can run ``./bin/unix/install-dependencies/archlinux.sh``.

Windows
^^^^^^^

Running ``./bin/windows/setup.cmd`` will install Python 2.7 and install all dependencies.
Enter any manual and clicking the "Build HTML" shortcut will create a HTML
build. Likewise, "Build PDF" will build the PDF using the more lightweight,
but feature-incomplete RST2PDF tool. The results are in ``_build/html`` and
``_build/pdf`` respectively.

Generating The Documentation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ArchLinux
^^^^^^^^^

If you're on Arch Linux, the build script is called sphinx-build2 which will 
fail. You will need to provide a link to the expected script name::

     sudo ln -s /usr/bin/sphinx-build2 /usr/bin/sphinx-build

...then enter any of the manual directores ({admin,developer,user}_manual) and 
run ``make html``. The result can be found in the ``_build/html`` subdirectory. 
PDFs can be built with the ``make latexpdf`` command and are found in 
``_build/latex/`` directory.

All Other Linux Distributions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

With the dependencies installed, build the documentation by running the 
following commands::

  cd user_manual && make latexpdf

You can also run ``./bin/unix/build-docs.sh`` as well. The generated 
documentation will be located in ``_build/latex/``.

Viewing The Documentation
~~~~~~~~~~~~~~~~~~~~~~~~~~

Linux
^^^^^

If you’re not on a headless box, then you can use one of the many PDF viewers available for Linux. These include:

* `evince <https://wiki.gnome.org/Apps/Evince>`_ 
* `okular <https://en.opensuse.org/Okular>`_
* `xpdf <http://www.foolabs.com/xpdf/home.html>`_
* `gv <https://www.gnu.org/software/gv/>`_
* `qpdfview <https://launchpad.net/qpdfview>`_

If you’re using a headless box you can use ``less``. But you will need to have ``pdftotext`` installed as well. 

Mac OSX
^^^^^^^

You can either use the built-in Preview app, or `download <https://get.adobe.com/uk/reader/>`_ 
and install a copy of Adobe Acrobat Reader and use that to view the documentation.

Windows
^^^^^^^

You will likely have a copy of Adobe Acrobat Reader installed. If not, 
`download <https://get.adobe.com/uk/reader/>`_ and install a copy and use that 
to view the documentation.

