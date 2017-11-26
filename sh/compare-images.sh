#!/bin/bash


if [ $# -ne 2 ]; then
  echo "This script expects 2, and only 2, arguments, but received $#."
  exit 1
fi

# @see https://stackoverflow.com/a/9847511
diff <(docker save $1) <(docker save $2)
