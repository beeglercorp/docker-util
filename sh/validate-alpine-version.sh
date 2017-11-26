#!/bin/bash


# @see https://stackoverflow.com/questions/687780/documenting-shell-scripts-parameters
usage () {
    cat <<EOM

    $(basename $0)  -i <image> -v <version>

   -h             Show this usage message.
   -i  <image>    Name of an existing image.
   -v  <version>  The expected Alpine version.

EOM
  exit 0
}

# show usage instructions if run without arguments
[ -z $1 ] && { usage; }

while getopts ":hi:v:" opt; do
  case ${opt} in
    h )
      usage
      ;;
    i )
      DOCKER_IMAGE_NAME=$OPTARG
      ;;
    v )
      ALPINE_VERSION=$OPTARG
      ;;
    \? )
      echo ""
      echo "    Unknown option -$OPTARG. Proper usage:"
      usage >&2
      ;;
  esac
done

# get the Alpine version from the container
CONTAINER_ALPINE_VERSION=$(docker run --entrypoint cat --rm $DOCKER_IMAGE_NAME /etc/alpine-release)

# remove anything past <major>.<minor>
NORMALIZED_CONTAINER_ALPINE_VERSION=`expr "$CONTAINER_ALPINE_VERSION" : '\([0-9]*\.[0-9]*\)'`

# normalize the expected version to an actual version, not the name of a tag
case $ALPINE_VERSION in
  edge)
    EXPECTED_ALPINE_VERSION=3.6
    ;;
  latest)
    EXPECTED_ALPINE_VERSION=3.6
    ;;
  *)
    EXPECTED_ALPINE_VERSION=$ALPINE_VERSION
    ;;
esac

# validate Alpine version (<major.<minor> only)
if [ $NORMALIZED_CONTAINER_ALPINE_VERSION = $EXPECTED_ALPINE_VERSION ]; then
  echo "Passed: The normalized Alpine version ${NORMALIZED_CONTAINER_ALPINE_VERSION} matches the expected version."
else
  echo "Failed: The normalized Alpine version ${NORMALIZED_CONTAINER_ALPINE_VERSION} does not match the expected version ${EXPECTED_ALPINE_VERSION}."
  exit 1
fi
