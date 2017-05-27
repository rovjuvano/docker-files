#!/bin/bash
# Wrapper around `docker run`
#  - removes container after run
#  - automatically passes `-it` if tty present
#  - passes through TERM environment variable
#  - extensible list of parameters
#
# To pass additional parameters to `docker run`, define either:
#   - DOCKER_SHELL_RUN_ARGS - array of addition args
#   - docker-shell-set-run-args - function which sets DOCKER_SHELL_RUN_ARGS
#
# To set image name, set DOCKER_SHELL_IMAGE
#
# To preserve container, pass `--rm=false`
#
# To override user see docker-shell function
#
# Usage:
#
#     source "$0"
#     DOCKER_SHELL_IMAGE=...:...
#     DOCKER_SHELL_RUN_ARGS+=(...)
#     docker-shell command [args...]
if [[ "${DOCKER_SHELL_RUN_ARGS-unset}" == 'unset' ]]; then
  if command -v docker-shell-set-run-args &>/dev/null; then
    docker-shell-set-run-args
  else
    DOCKER_SHELL_RUN_ARGS=(
      -v "$(dirname "${PWD}"):/data"
      --workdir "/data/$(basename "${PWD}")"
    )
  fi
fi
function docker-shell {
  [[ -t 0 && -t 1 ]] && TTY_ARGS=(-it)
  local ARGS=(
    --rm
    "${TTY_ARGS[@]}"
    -e TERM
    "${DOCKER_SHELL_RUN_ARGS[@]}"
    "${DOCKER_SHELL_IMAGE:-debian:testing}"
  )
  exec docker run "${ARGS[@]}" "$@"
}
