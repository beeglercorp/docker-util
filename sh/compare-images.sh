#!/bin/bash


# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev


if [ $# -ne 2 ]; then
  echo "This script expects 2, and only 2, arguments, but received $#."
  exit 1
fi

# @see https://stackoverflow.com/a/9847511
diff <(docker save $1) <(docker save $2)
