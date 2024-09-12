# syntax=docker/dockerfile:1
FROM golang:1.23.1 AS base

ARG \
    API_PORT \
    OS_NAME \
    OS_VERSION

LABEL \
    OS_NAME=${OS_NAME} \
    OS_VERSION=${OS_VERSION}

ENV API_PORT=${API_PORT}

FROM base AS build
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server main.go

# FROM scratch
FROM base AS main
WORKDIR /app
COPY --from=build /build/server /app/
CMD ["/app/server"]
EXPOSE ${API_PORT}
