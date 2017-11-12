Docker Utilities
================

This repository hosts utilities used by other repositories that build or manage Docker images.

Included Utilities
------------------

### docker-util/sh/

#### `test-image-size.sh`

Use the `test-image-size.sh` script to test the size of an image, in MB, against a threshold.

##### Usage

```sh
docker-util/sh/test-image-size.sh -i <image> -t <threshold>
```

##### Example

The following will exit with a 0 status code if the _foo_ image is less than or equal to 25MB. If the image is greater than 25MB, the script will exit with a 1 status code.

```sh
docker-util/sh/test-image-size.sh -i foo -t 25
```

#### `install-docker-on-trusty.sh`

Use the `install-docker-on-trusty.sh` script to update the Docker installation. You will typically run this in a Travis container, via _.travis.yml_.

##### Usage

_.travis.yml_
```yml
before_install:
  - ./docker-util/sh/install-docker-on-trusty.sh
  - sudo dockerd --experimental &
```
