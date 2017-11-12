#!/bin/bash


# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
#set -ev

# @see https://stackoverflow.com/questions/687780/documenting-shell-scripts-parameters
usage () {
    cat <<EOM

    $(basename $0)  -i <image> -n <name> -p <password> -t [<tag>] -u <username>

   -h             Show this usage message.
   -i  <image>    Name of an existing top-level image.
   -n  <name>     The public image name. Used by "docker push".
   -p  <password> Docker registry password. Used by "docker login".
   -t  [<tag>]    The appropriate tag. Used by "docker push". Optional.
                   Default is "latest".
   -u  <username> Docker registry username. Used by "docker login".
EOM
  exit 0
}

# show usage instructions if run without arguments
[ -z $1 ] && { usage; }

TAG=latest

while getopts ":hi:n:t:p:u:" opt; do
  case ${opt} in
    h )
      usage
      ;;
    i )
      IMAGE_NAME=$OPTARG
      ;;
    n )
      PUBLIC_IMAGE_NAME=$OPTARG
      ;;
    p )
      PASSWORD=$OPTARG
      ;;
    t )
      TAG=$OPTARG
      ;;
    u )
      USERNAME=$OPTARG
      ;;
    \? )
      echo ""
      echo "    Unknown option -$OPTARG. Proper usage:"
      usage >&2
      ;;
  esac
done

docker login -u "$USERNAME" -p "$PASSWORD"
docker tag $IMAGE_NAME $PUBLIC_IMAGE_NAME:$TAG
docker push $PUBLIC_IMAGE_NAME:$TAG
