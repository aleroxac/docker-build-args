# syntax=docker/dockerfile:1
FROM python:3.11.1-alpine3.17 AS base



# ---------- ARGS
ARG \
  IMAGE_MAINTAINER \
  IMAGE_VENDOR \
  AUTHOR_NAME \
  AUTHOR_USERNAME \
  AUTHOR_TITLE \
  AUTHOR_EMAIL \
  LICENSE \
  SCHEMA_VERSION \
  VCS_REF \
  VCS_URL \
  BUILD_DATE \
  IMAGE_NAME \
  IMAGE_BASE \
  IMAGE_VERSION \
  IMAGE_DESCRIPTION \
  IMAGE_USAGE \
  IMAGE_URL \
  OS_NAME \
  OS_VERSION \
  DOCKER_CMD \
  DOCKER_CMD_DEVEL \
  DOCKER_CMD_TEST \
  DOCKER_CMD_DEBUG \
  DOCKER_CMD_HELP \
  DOCKER_PARAMS



# ---------- LABELS
LABEL \
  maintainer=${IMAGE_MAINTAINER} \
  vendor=${IMAGE_VENDOR} \
  org.label-schema.author-name=${AUTHOR_NAME} \
  org.label-schema.author-username=${AUTHOR_USERNAME} \
  org.label-schema.author-title=${AUTHOR_TITLE} \
  org.label-schema.author-email=${AUTHOR_EMAIL} \
  org.label-schema.license=${LICENSE} \
  org.label-schema.schema-version=${SCHEMA_VERSION} \
  org.label-schema.vcs-ref=${VCS_REF} \
  org.label-schema.vcs-url=${VCS_URL} \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.name=${IMAGE_NAME} \
  org.label-schema.base=${IMAGE_BASE} \
  org.label-schema.version=${IMAGE_VERSION} \
  org.label-schema.description=${IMAGE_DESCRIPTION} \
  org.label-schema.usage=${IMAGE_USAGE} \
  org.label-schema.url=${IMAGE_URL} \
  org.label-schema.os-name=${OS_NAME} \
  org.label-schema.os-version=${OS_VERSION} \
  org.label-schema.docker.cmd=${DOCKER_CMD} \
  org.label-schema.docker.cmd.devel=${DOCKER_CMD_DEVEL} \
  org.label-schema.docker.cmd.test=${DOCKER_CMD_TEST} \
  org.label-schema.docker.cmd.debug=${DOCKER_CMD_DEBUG} \
  org.label-schema.docker.cmd.help=${DOCKER_CMD_HELP} \
  org.label-schema.docker.params=${DOCKER_PARAMS}



# ---------- BUILD
FROM base AS build
WORKDIR /build
COPY requirements.txt /build/requirements.txt
RUN apk add --no-cache --upgrade --virtual go && \
    pip install --no-cache-dir --prefix=/build -r /build/requirements.txt



# ---------- ENVS
ENV DOCKER_CONTENT_TRUST=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1



# ---------- MAIN
FROM base AS main
WORKDIR /app
COPY --from=build /build /usr/local
COPY src/main.py /app/
ENTRYPOINT ["python", "/app/main.py"]
