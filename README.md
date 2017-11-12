Docker Utilities
================

This repository hosts utilities used by other repositories that build or manage Docker images.

Installing
----------

1. Add this repository as a git [submodule](https://git-scm.com/docs/git-submodule).

    ```sh
    git submodule add https://github.com/beeglercorp/docker-util.git
    ```

1. You probably don't care about the history, so configure the submodule to clone shallowly.

    ```sh
    git config -f .gitmodules submodule.docker-util.shallow true
    ```

Choosing a Version, and/or Updating
-----------------------------------

You may wish to use a particular version. To update the submodule to use a specific release (i.e. [tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging)), run the following, making sure to replace _{VERSION}_ with the version you desire.

    ```sh
    cd docker-util
    git fetch --tags
    git checkout v{VERSION}
    cd ../
    ```

If you prefer to use a branch, rather than a version (see above), periodically you will want to pull in the latest commits from the remote repository.

```sh
git submodule update --recursive --remote docker-util
```

Then, commit and push as usual.

Using a Utility
---------------

### docker-util/sh/

#### `install-docker-on-trusty.sh`

Use the `install-docker-on-trusty.sh` script to update the Docker installation. You will typically run this in a Travis container, via _.travis.yml_.

##### Usage

_.travis.yml_
```yml
before_install:
  - ./docker-util/sh/install-docker-on-trusty.sh
  - sudo dockerd --experimental &
```

#### `push-image.sh`

Use the `push-image.sh` script to `docker login` and then `docker push` an existing, top-level image.

##### Usage

```sh
docker-util/sh/push-image.sh -i <image> -n <name> -p <password> -t [<tag>] -u <username>
```

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
