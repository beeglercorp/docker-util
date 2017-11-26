#!/bin/bash


function attempt {
    local DELAY="${ATTEMPT_DELAY_DURATION:-1}"
    local MAX_ATTEMPTS="${ATTEMPT_MAX_ATTEMPTS:-5}"

    for ((i=1; i<=$MAX_ATTEMPTS; i++)); do SUPPRESSED_OUTPUT=`$@ 2>&1` && [[ $? = 0 ]] && echo $SUPPRESSED_OUTPUT && break || {
        [[ $DELAY = 1 ]] && UNIT="second" || UNIT="seconds"

        if [[ $i -lt $MAX_ATTEMPTS ]]; then
            echo "Attempt $i of $MAX_ATTEMPTS failed. Retrying \"$@\" in $DELAY $UNIT."
            sleep $DELAY;
        else
            (>&2 echo "Attempt $i of $MAX_ATTEMPTS failed with error \"$SUPPRESSED_OUTPUT\".")
            (>&2 echo "\"$@\" failed $MAX_ATTEMPTS attempts while sleeping $DELAY $UNIT between attempts.")
            exit 1
        fi
    }
    done
}