===============
Importing Files
===============

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
