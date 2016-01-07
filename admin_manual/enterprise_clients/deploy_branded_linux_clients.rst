Deploy And Maintain Branded Linux Clients (Enterprise Only)
===========================================================

ownBrander user can enable the build of branded Linux in the “Desktop”
section of their account. They get a \*.tar file which contains
everything to set up complete self-hosted Linux repositories for the
selected Linux distributions.

This is the content of ``mycloud-2.0.2.450-linux.tar``:

::

    mycloud-2.0.2.450-linux
    ├── Fedora_20
    │   ├── my.repo
    │   ├── repocache
    │   ├── repodata
    │   │   ├── 893c197dfe8… …af4feaa87-filelists.xml.gz
    │   │   ├── 8cc4ccf1113… …62c8e1284-primary.xml.gz
    │   │   ├── 9473f469df6… …55a450060-other.xml.gz
    │   │   ├── repomd.xml
    │   │   ├── repomd.xml.asc
    │   │   └── repomd.xml.key
    │   ├── src
    │   │   ├── libqt5keychain-0.5-1.1.src.rpm
    │   │   ├── libqtkeychain-0.5-4.1.src.rpm
    │   │   └── mycloud-client-2.0.2-1.2.src.rpm
    │   └── x86_64
    │       ├── libmycloudsync-devel-2.0.2-1.2.x86_64.rpm
    │       ├── libmycloudsync0-2.0.2-1.2.x86_64.rpm
    │       ├── libqt5keychain-devel-0.5-1.1.x86_64.rpm
    │       ├── libqt5keychain0-0.5-1.1.x86_64.rpm
    │       ├── libqtkeychain-devel-0.5-4.1.x86_64.rpm
    │       ├── libqtkeychain0-0.5-4.1.x86_64.rpm
    │       ├── mycloud-client-2.0.2-1.2.x86_64.rpm
    │       ├── mycloud-client-doc-2.0.2-1.2.x86_64.rpm
    │       ├── mycloud-client-l10n-2.0.2-1.2.x86_64.rpm
    │       └── mycloud-client-nautilus-2.0.2-1.2.x86_64.rpm
    ├── Fedora_21
    │   └── …
    ├── Fedora_22
    │   └── …
    ├── Ubuntu_14.04
    │   └── …
    ├── Ubuntu_15.04
    │   └── …
    ├── download
    │   ├── Fedora.html
    │   ├── assets
    │   │   ├── application.css
    │   │   ├── application.js
    │   │   ├── arch.png
    │   │   ├── centos.png
    │   │   ├── debian.png
    │   │   ├── download.html
    │   │   ├── favicon.png
    │   │   ├── fedora.png
    │   │   ├── global-navigation-data-en.js
    │   │   ├── globalnav-im.png
    │   │   ├── header-logo.png
    │   │   ├── opensuse.png
    │   │   ├── repo.cfg
    │   │   ├── rhel.png
    │   │   ├── sl.png
    │   │   ├── sle.png
    │   │   ├── ubuntu.png
    │   │   ├── unknown.png
    │   │   └── ymp-added-repos.txt
    │   ├── bin
    │   │   └── repo-admin.py
    │   ├── example.sh
    │   ├── index.html
    │   ├── openSUSE.html
    │   ├── xUbuntu.html
    │   └── ymp
    │       ├── openSUSE_13.1
    │       │   └── mycloud-client.ymp
    │       ├── openSUSE_13.2
    │       │   └── mycloud-client.ymp
    │       └── openSUSE_ymp.html
    ├── openSUSE_13.1
    │   └── …
    └── openSUSE_13.2
        └── …

The download folder provides detailed instructions
(``download/index.html``) how to install the branded Linux clients on
the selected Linux distributions. All location information in the HTML
files is set to ``example.com``. All metadata in the repo is set to
``example.com`` too.

The download folder contains a shell script (\```download/example.sh``).
It allows to modify the HTML and the repo metadata itself according to
the custom repo location on the deployment webserver.

The ownBrander build system can be configured to include the custom repo
URL information in the \*.tar file. Currently, this parameter isn’t
available in the ownBrander web UI, but the ownCloud support
(support@owncloud.com) can add this information to the ownBrander
account.
