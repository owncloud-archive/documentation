#!/bin/sh
#
# This is a quick script to make building all of the documentation
# that much simpler than it was before. It isn't a particularly
# sophisticated script, definitely not that defensive, yet.
#
# Authors:
#  Matthew Setter <msetter@owncloud.com>
#
# vm-build.sh
#

MANUALS=( admin developer user )

echo "building all the MANUALS."
echo

for dir in "${MANUALS[@]}"
do
  if [ -d "${dir}_manual" ]; then
    cd "${dir}_manual"
    DIR_NAME=$(echo "${dir}" | sed -e "s/\b\(.\)/\u\1/g")
    echo "  building the ${DIR_NAME} manual..."
    make latexpdf &> build.log
    echo "  finished building the ${dir} manual"
    echo 
    cd - > /dev/null
  fi
done

echo "finished building all the manuals"
