#/bin/bash
#
## 
## Usage: archlinux
## 
## This script automates the building of ownCloud documentation on the ArchLinux platform.
## While new, it should handle installing all of the required platform depencies, and afterwards
## build the documentation. 
##
## Author: Matthew Setter <msetter@owncloud.com>
##

function install_dependencies()
{
  sudo pacman-key --refresh-keys && \ 
  sudo pacman --noconfirm -Syy && \ 
  sudo pacman --noconfirm -S community/python2-rst2pdf community/python2-sphinx extra/texlive-core texlive-latexextra 
  sudo easy_install -U sphinxcontrib-phpdomain
}

install_dependencies
