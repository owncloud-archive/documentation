#/bin/bash
#
## 
## Usage: build-docs
## 
## This script automates the building of ownCloud documentation.
##
## Author: Matthew Setter <msetter@owncloud.com>
##

set -e

function build_documentation() 
{
    echo "Building the documentation..."

    cd user_manual && make latexpdf && cd -

    echo "Documentation built."
}

build_documentation
