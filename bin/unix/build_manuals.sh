#!/bin/sh
#
# This is a quick script to make building all of the documentation
# that much simpler than it was before. It isn't a particularly
# sophisticated script, definitely not that defensive, yet.
#
# Title: build_manuals - Build the three ownCloud documentation manuals
# Synopsis: build_manuals [-c|-h|-v] REGEX
# Date: 2016-12-06
# Version: 1.0
# Authors:
#   Matthew Setter <msetter@owncloud.com>

##
## Variable definitions
##
MANUALS=( admin developer user )

export CDPATH=".:~:/opt/"
cd documentation >/dev/null

##
##@ Description: does the actual work of building a manual
##@ Usage: build MANUAL
##
build()
{
  if [ -x "$1" ]; then
    echo "No manual name provided. Require at least this to build a manual."
    return
  fi

  if [ ! -d "manuals/${dir}" ]; then
    echo "  ${dir} manual not available. Skipping."
  fi

  DIR=$1

  cd "manuals/${DIR}" &>/dev/null

  echo "  building the ${DIR} manual..."
  make latexpdf #&> build.log
  echo "  finished building the ${DIR} manual"
  echo

  cd - &>/dev/null
}

echo "Building all the manuals."

## Build all the manuals
for dir in "${MANUALS[@]}"
do
    build "${dir}"
done

echo "Finished building all the manuals"
