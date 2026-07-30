#!/usr/bin/env bash
set -euo pipefail


: ${REVERB_COMPOSE_FILE:=compose.yaml}
: ${REVERB_SERVICES:=}
: ${REVERB_DOCKER_BUILD_CACHE_DIR:=/tmp/docker-build-cache}
: ${DEBUG:=0}
if [ ${DEBUG} != 0 ]; then set -x; fi
export DOCKER_BUILDKIT=1

die() { echo "${1:-}" >&2; exit 1; }
log() { echo "$@" >&2; }

#============================================================

initialize() {
#  docker compose version
#  initializeComposeFile
#  initializeServices
}

initializeComposeFile() {
  if [ ! -f ${REVERB_COMPOSE_FILE} ]; then die "Compose file not found: ${REVERB_COMPOSE_FILE}"; fi
  log "Using compose file: ${REVERB_COMPOSE_FILE}"
}

initializeServices() {
  if [ -n "${REVERB_SERVICES:-}" ]; then return; fi
  REVERB_SERVICES=$(docker compose config --format json \
    | jq -r '.services|to_entries[]|select(.value.build != null and .value.image != null)|.key' \
    | paste -sd ' ')
  if [ -z "${REVERB_SERVICES:-}" ]; then die "No services found to publish. Add service.*.image and service.*.build information."; fi
  log "Services: ${REVERB_SERVICES}"
}

build() {
  log "Building images"
  # docker compose build
  for i in $(seq 1 ${DELAY:10}); do echo "wait for it"; sleep 1; done

}

release() {
  #docker images
  #log "Pushing images ..."
  #docker compose push -q $REVERB_SERVICES
  log "Pretend releasing ..."
}

#============================================================

main() {
  initialize
  case "${1:-help}" in
    b*) build;;
    r*) release;;
    *) die "Usage: $0 <build|release>";;
  esac
  log "Done"
}
main $@
