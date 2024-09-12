# example-labels

``` shell
cd examples/hadolint/
docker-build-args Dockerfile .docker-build-args.env > .env
source <(sed "s/^/export /g" .env)
cat Dockerfile | envsubst > Dockerfile.tmp
docker build \
  --build-arg API_PORT=${API_PORT} \
  --build-arg OS_NAME=${OS_NAME} \
  --build-arg OS_VERSION=${OS_VERSION} \
  -t docker-build-args/example:v1 \
  -t docker-build-args/example:latest \
  -f Dockerfile.tmp .

rm -f Dockerfile.tmp
```
