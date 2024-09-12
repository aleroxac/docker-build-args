# docker-build-args
Utility to facilitate the composition of arguments during docker image builds


## Use Cases
<details>
  <summary>Hadolint</summary>

### [Hadolint Scans](examples/hadolint/README.md)
- If you try to scan a Dockerfile with LABELs passing environment variables as value, will came across with the error [DL3048(Invalid label key)](https://github.com/hadolint/hadolint/wiki/DL3048) (if you are not using a hadolint config file)
- Possible errors if you are using a config file
  - [DL3052 - invalid url](https://github.com/hadolint/hadolint/wiki/DL3052)
  - [DL3053 - invalid RFC3339 time format](https://github.com/hadolint/hadolint/wiki/DL3053)
  - [DL3054 - invalid spdx license format](https://github.com/hadolint/hadolint/wiki/DL3054)
  - [DL3055 - invalid git hash](https://github.com/hadolint/hadolint/wiki/DL3055)
  - [DL3056 - invalid semantic versioning](https://github.com/hadolint/hadolint/wiki/DL3056)
  - [DL3058 - invalid RFC5322 email format](https://github.com/hadolint/hadolint/wiki/DL3058)

</details>

<details>
  <summary>Labels</summary>

### [Docker Image Labels](examples/labels/README.md)
- If you build a container image without set the raw values in your `LABEL` dockerfile instructions, when you inspect that, will see that all your labels were created, but with no value

``` shell
docker inspect aleroxac/docker-build-args:example --format "{{json .Config.Labels}}" | jq
{
  "maintainer": "",
  "org.label-schema.author-email": "",
  "org.label-schema.author-name": "",
  "org.label-schema.author-title": "",
  "org.label-schema.author-username": "",
  "org.label-schema.base": "",
  "org.label-schema.build-date": "",
  "org.label-schema.description": "",
  "org.label-schema.docker.cmd": "",
  "org.label-schema.docker.cmd.debug": "",
  "org.label-schema.docker.cmd.devel": "",
  "org.label-schema.docker.cmd.help": "",
  "org.label-schema.docker.cmd.test": "",
  "org.label-schema.docker.params": "",
  "org.label-schema.license": "",
  "org.label-schema.name": "",
  "org.label-schema.os-name": "",
  "org.label-schema.os-version": "",
  "org.label-schema.schema-version": "",
  "org.label-schema.url": "",
  "org.label-schema.usage": "",
  "org.label-schema.vcs-ref": "",
  "org.label-schema.vcs-url": "",
  "org.label-schema.version": "",
  "vendor": ""
}
```
</details>



## Installation
``` shell
git clone git@github.com/aleroxac/docker-build-args.git
cd docker-build-args
make install
docker-build-args Dockerfile docker-build-args.env
```


## Use mode
``` shell
cd examples/hadolint/
docker-build-args Dockerfile .docker-build-args.env > .env
source <(sed "s/^/export /g" .env)
cat Dockerfile | envsubst > Dockerfile.tmp
docker build \
  --build-arg API_PORT=${API_PORT} \
  --build-arg IMAGE_MAINTAINER=${IMAGE_MAINTAINER} \
  --build-arg IMAGE_VENDOR=${IMAGE_VENDOR} \
  --build-arg AUTHOR_NAME=${AUTHOR_NAME} \
  --build-arg AUTHOR_USERNAME=${AUTHOR_USERNAME} \
  --build-arg AUTHOR_TITLE=${AUTHOR_TITLE} \
  --build-arg AUTHOR_EMAIL=${AUTHOR_EMAIL} \
  --build-arg LICENSE=${LICENSE} \
  --build-arg SCHEMA_VERSION=${SCHEMA_VERSION} \
  --build-arg VCS_REF=${VCS_REF} \
  --build-arg VCS_URL=${VCS_URL} \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg IMAGE_NAME=${IMAGE_NAME} \
  --build-arg IMAGE_BASE=${IMAGE_BASE} \
  --build-arg IMAGE_VERSION=${IMAGE_VERSION} \
  --build-arg IMAGE_DESCRIPTION=${IMAGE_DESCRIPTION} \
  --build-arg IMAGE_USAGE=${IMAGE_USAGE} \
  --build-arg IMAGE_URL=${IMAGE_URL} \
  --build-arg OS_NAME=${OS_NAME} \
  --build-arg OS_VERSION=${OS_VERSION} \
  --build-arg DOCKER_CMD=${DOCKER_CMD} \
  --build-arg DOCKER_CMD_DEVEL=${DOCKER_CMD_DEVEL} \
  --build-arg DOCKER_CMD_TEST=${DOCKER_CMD_TEST} \
  --build-arg DOCKER_CMD_DEBUG=${DOCKER_CMD_DEBUG} \
  --build-arg DOCKER_CMD_HELP=${DOCKER_CMD_HELP} \
  --build-arg DOCKER_PARAMS=${DOCKER_PARAMS} \
  -t docker-build-args/example:v1 \
  -t docker-build-args/example:latest \
  -f Dockerfile.tmp .

hadolint -c hadolint.yaml Dockerfile.tmp > hadolint-$(date '+%Y%m%dT%H%M%S').log
rm -f Dockerfile.tmp
```


## Uninstallation
``` shell
cd docker-build-args
make uninstall
```
