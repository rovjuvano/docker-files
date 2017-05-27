#!/bin/bash
# Wrapper around `docker run`
#  - removes container after run
#  - automatically passes `-it` if tty present
#  - passes through TERM environment variable
#  - runs as user with specific name, UID, GID, and groups
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
# run container as specific user
#  - run as user with name, UID, GID, and groups of current user
#    `$0 command [args...]`
#  - run as default user defined in image
#    `$0 --as-default command [args...]`
#  - run as owner of file
#    `$0 --as-owner file command [args...]`
#  - run as root user
#    `$0 --as-root command [args...]`
#  - run as given user
#    `$0 --as-user username userspec groups command [args...]`
#      - username   - desired value of USER environment variable
#      - userspec   - argument to `--user`
#      - groups     - space or comma delimited list of additional groups/gids
#      pass empty string to use the default defined by the image
function docker-shell {
  case "$1" in
    --as-default) shift; docker-shell::as-user '' '' '' "$@";;
    --as-owner)
      read -r uid gid username < <(stat -c '%u %g %U' "$2")
      shift 2;
      docker-shell::as-user "${username}" "${uid}:${gid}" '' "$@"
    ;;
    --as-root) shift; docker-shell::as-user root 0:0 '' "$@";;
    --as-user) shift; docker-shell::as-user "$@";;
    *) docker-shell::as-user "${USER:-$(id -un)}" "$(id -u):$(id -g)" "$(id -G)" "$@";;
  esac
}
# see `docker-shell --as-user`
function docker-shell::as-user {
  local username="$1"; shift
  local userspec="${1:-${username}}"; shift
  local groups="$1"; shift
  [[ -t 0 && -t 1 ]] && TTY_ARGS=(-it)
  local ARGS=(
    --rm
    "${TTY_ARGS[@]}"
    -e TERM
  )
  [[ -n "${username}" ]] && ARGS+=(-e "USER=${username}")
  [[ -n "${userspec}" ]] && ARGS+=(--user "${userspec}")
  [[ -n "${groups}" ]] && ARGS+=($(IFS=' ,'; printf " --group-add %s" $groups))
  ARGS+=(
    "${DOCKER_SHELL_RUN_ARGS[@]}"
    "${DOCKER_SHELL_IMAGE:-debian:testing}"
  )
  exec docker run "${ARGS[@]}" "$@"
}
