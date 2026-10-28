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
REPOSITORY="${DOCKER_REPOSITORY:-$DEFAULT_REPOSITORY}"

echo "Building and pushing Papersign image for $PLATFORM"
echo "Image repository: $REPOSITORY"
echo "App version: $APP_VERSION"
echo "Git SHA: $GIT_SHA"

TAG_ARGS=(
    -t "$REPOSITORY:latest"
    -t "$REPOSITORY:$GIT_SHA"
    -t "$REPOSITORY:sha-${GIT_SHA:0:7}"
)

if [ -n "$APP_VERSION" ] && [ "$APP_VERSION" != "undefined" ]; then
    TAG_ARGS+=(-t "$REPOSITORY:$APP_VERSION")
fi

docker buildx build \
    -f "$SCRIPT_DIR/Dockerfile" \
    --platform="$PLATFORM" \
    --progress=plain \
    --build-arg NEXT_PRIVATE_TELEMETRY_KEY="${NEXT_PRIVATE_TELEMETRY_KEY:-}" \
    --build-arg NEXT_PRIVATE_TELEMETRY_HOST="${NEXT_PRIVATE_TELEMETRY_HOST:-}" \
    "${TAG_ARGS[@]}" \
    --push \
    "$MONOREPO_ROOT"
