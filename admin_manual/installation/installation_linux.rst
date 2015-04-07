===================
Linux Distributions
===================

Supported Distribution Packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Current ready-to-use packages are available at `openSUSE Build Service`_ for a 
variety of Linux distributions. You can `still get 6.0.7
<https://software.opensuse.org/download/package?project=isv:ownCloud:community:6
.0&package=owncloud>`_, which is the latest 6.0 version, though you really 
shouldn't be running such an old ownCloud version as it reaches end-of-life in 
June 2015, and newer releases have many improvements and fixes.

.. note:: Please don't move the folders provided by this packages after the installation.
   This will break further updates.

If your distribution is not listed please follow :doc:`installation_source`.

.. _openSUSE Build Service: http://software.opensuse.org/download.html?project=isv:ownCloud:community&package=owncloud


Additional installation guides and notes
****************************************

**Fedora:** Make sure `SELinux is disabled <https://fedoraproject.org/wiki/SELinux_FAQ#How_do_I_enable_or_disable_SELinux_.3F>`_
or else the installation process might fail.

**Archlinux:** The are two packages for ownCloud: `stable version`_ in the official community repository and `development version`_ in AUR.

.. _stable version: https://www.archlinux.org/packages/community/any/owncloud
.. _development version: http://aur.archlinux.org/packages.php?ID=38767


**PCLinuxOS:** Follow the Tutorial `ownCloud, installation and setup`_ on the PCLinuxOS web site.

.. _ownCloud, installation and setup: http://pclinuxoshelp.com/index.php/Owncloud,_installation_and_setup


**Debian/Ubuntu:** The package is installing an additional Apache config file to `/etc/apache2/conf.d/owncloud.conf`
which contains an `Alias` to the owncloud installation directory as well as some more needed configuration options.

Follow the wizard to complete your installation
***********************************************

For setting up your ownCloud instance after installation, please refer to the
:doc:`installation_wizard` section.
