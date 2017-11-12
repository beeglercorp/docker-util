#!/bin/bash


# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev

# @see https://stackoverflow.com/questions/687780/documenting-shell-scripts-parameters
usage () {
    cat <<EOM

    $(basename $0)  -i <image> -t <threshold>

   -h  Show this usage message.
   -i  {String} image The name of the Docker image to test.
   -t  {int} threshold A number, in MB, which the image size may not exceed.
       If the image size exceeds the threshold, the script will exit with a 1
       status code.
EOM
  exit 0
}

[ -z $1 ] && { usage; }

while getopts ":hi:t:" opt; do
  case ${opt} in
    h )
      usage
      ;;
    i )
      image=$OPTARG
      ;;
    t )
      threshold=$OPTARG
      ;;
    \? )
      echo ""
      echo "    Unknown option -$OPTARG. Proper usage:"
      usage >&2
      ;;
  esac
done

DOCKER_SIZE_STRING="$(docker images $image --format {{.Size}})"
DOCKER_SIZE_NUMBER=${DOCKER_SIZE_STRING%MB}

if [ ${#DOCKER_SIZE_STRING} -eq ${#DOCKER_SIZE_NUMBER} ]; then
  # the size is not in MB, we're going to assume it's in something greater than MB
  echo "Size >999MB."
  exit 1
fi

DOCKER_SIZE_ROUNDED="$(echo $DOCKER_SIZE_NUMBER | awk '{print int($1+0.9)}')"

if [ $threshold -ge $DOCKER_SIZE_ROUNDED ]; then
  echo "Passed: The ${image} image is ${DOCKER_SIZE_STRING}, and is less than or equal to the threshold ${threshold}MB."
else
  echo "Failed: The ${image} image is ${DOCKER_SIZE_STRING}, and is greater than the threshold ${threshold}MB."
  exit 1
fi
