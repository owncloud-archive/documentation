#/bin/bash
#
## 
## Usage: build-opensuse
## 
## This script automates the building of ownCloud documentation on the openSUSE platform.
## While new, it should handle installing all of the required platform depencies, and afterwards
## build the documentation. 
##
## Author: Matthew Setter <msetter@owncloud.com>
##

set -e

function install_dependencies()
{
    # first check if the repository's already been added and add it if not
    if ! zypper lr | grep --silent devel_languages_python; then
        echo "Adding the devel:languages:python repository to the available repository list"
        sudo zypper addrepo --refresh http://download.opensuse.org/repositories/devel:languages:python/openSUSE_Leap_42.1/devel:languages:python.repo
    fi;

    echo "Installing required platform dependencies..."
    sudo zypper in -yf python-Sphinx python-rst2pdf python-sphinxcontrib-phpdomain texlive-pdfjam texlive-threeparttable texlive-wrapfig texlive-multirow

    echo "Dependencies installed."
}

install_dependencies
