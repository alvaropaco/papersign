#!/usr/bin/env bash

command -v docker >/dev/null 2>&1 || {
    echo "Docker is not running. Please start Docker and try again."
    exit 1
}

SCRIPT_DIR="$(readlink -f "$(dirname "$0")")"
MONOREPO_ROOT="$(readlink -f "$SCRIPT_DIR/../")"
DEFAULT_REPOSITORY="ghcr.io/alvaropaco/papersign"
PLATFORM="${PLATFORM:-linux/amd64}"

APP_VERSION="$(git name-rev --tags --name-only "$(git rev-parse HEAD)" | head -n 1 | sed 's/\^0//')"
GIT_SHA="$(git rev-parse HEAD)"

echo "Building Papersign image for $PLATFORM"
echo "App version: $APP_VERSION"
echo "Git SHA: $GIT_SHA"

REPOSITORY="${DOCKER_REPOSITORY:-$DEFAULT_REPOSITORY}"
echo "Image repository: $REPOSITORY"

docker buildx build \
    -f "$SCRIPT_DIR/Dockerfile" \
    --platform="$PLATFORM" \
    --progress=plain \
    --build-arg NEXT_PRIVATE_TELEMETRY_KEY="${NEXT_PRIVATE_TELEMETRY_KEY:-}" \
    --build-arg NEXT_PRIVATE_TELEMETRY_HOST="${NEXT_PRIVATE_TELEMETRY_HOST:-}" \
    -t "papersign-base" \
    "$MONOREPO_ROOT"

docker tag "papersign-base" "$REPOSITORY:latest"
docker tag "papersign-base" "$REPOSITORY:$GIT_SHA"
docker tag "papersign-base" "$REPOSITORY:sha-${GIT_SHA:0:7}"

if [ -n "$APP_VERSION" ] && [ "$APP_VERSION" != "undefined" ]; then
    docker tag "papersign-base" "$REPOSITORY:$APP_VERSION"
fi

docker rmi "papersign-base"
