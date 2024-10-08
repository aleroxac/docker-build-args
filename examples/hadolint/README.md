# example-hadolint

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
