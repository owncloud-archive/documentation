#/bin/bash
#
## 
## Usage: debian-ubuntu
## 
## This script automates the building of ownCloud documentation on Debian and Ubuntu distributions.
## While new, it should handle installing all of the required platform depencies, and afterwards
## build the documentation. 
##
## Author: Matthew Setter <msetter@owncloud.com>
##

set -e

function install_dependencies()
{
    # Update the Apt cache so that there are no errors based on an outdated package database
    sudo apt-get update

    # Install the required dependencies
    sudo apt-get install python-pil python-sphinx python-sphinxcontrib.phpdomain rst2pdf texlive-fonts-recommended texlive-latex-extra texlive-latex-recommended
}

install_dependencies
