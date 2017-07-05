#!/bin/bash

MINPARAMS=1

if [ $# -lt "$MINPARAMS" ]
then
  echo "This script needs at least $MINPARAMS command-line arguments"
fi

WHICH_MANUAL="$1"
AVAILABLE_MANUALS=( admin developer user )

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

if [ $(contains "${AVAILABLE_MANUALS[@]}" "$WHICH_MANUAL") == "y" ]; then
    echo "Rebuilding the $WHICH_MANUAL manual"
    echo
    vagrant ssh -c "cd /opt/documentation/${WHICH_MANUAL}_manual && make html-org"
    echo
    echo "Finished rebuilding the $WHICH_MANUAL manual"
fi
