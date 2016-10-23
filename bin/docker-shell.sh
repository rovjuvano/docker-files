#!/bin/bash
if [ ${#BASH_SOURCE[@]} == 1 ]; then
  cat <<__USAGE__
# helper functions to run or exec commands inside docker containers. e.g.
cat <<'__EOF__' > my-shell
#!/bin/bash
source "${BASH_SOURCE[0]}"
DOCKER_SHELL_IMAGE=debian:jessie
DOCKER_SHELL_CONTAINER=shell-debian-jessie
DOCKER_SHELL_DAEMON_COMMAND=(/bin/bash)
DOCKER_SHELL_ARGS_RUN+=(-e MY_VAR=my-value)
DOCKER_SHELL_ARGS_CREATE=("\${DOCKER_SHELL_ARGS_RUN[@]}")
DOCKER_SHELL_ARGS_EXEC=(--user=nobody)
docker_shell "\$@"
__EOF__
chmod 775 my-shell
./my-shell run hostname
./my-shell run hostname
./my-shell run env
./my-shell run ls -l

./my-shell create

./my-shell stop
./my-shell start

./my-shell exec hostname
./my-shell exec hostname
./my-shell exec env
./my-shell exec ls -l
./my-shell exec id -un

./my-shell rm

./my-shell help

# environment
DOCKER_SHELL_CONFIG - path to file to source -- useful for setting array values
DOCKER_SHELL_IMAGE - name or id of image to use when creating container or running command
DOCKER_SHELL_CONTAINER - name or id of container to use when execing command
DOCKER_SHELL_WORKDIR - path inside container to use when creating container or running or execing command (defaults to '/data')
DOCKER_SHELL_DAEMON_COMMAND - an array specifying command and arguments used to keep container running (defaults to 'sleep infinity')
DOCKER_SHELL_ARGS_RUN - an array of additional arguments to pass to \`docker run\`
DOCKER_SHELL_ARGS_CREATE - an array of additional arguments to pass to \`docker create\`
DOCKER_SHELL_ARGS_EXEC - an array of additional arguments to pass to \`docker exec\`
DOCKER_SHELL_ARGS_START - an array of additional arguments to pass to \`docker start\`
DOCKER_SHELL_ARGS_STOP - an array of additional arguments to pass to \`docker stop\`
DOCKER_SHELL_ARGS_RM - an array of additional arguments to pass to \`docker rm\`

# public functions
docker_shell run ... - run command inside throwaway container
docker_shell create - create persistenent container
docker_shell exec ... - exec command inside persistent container
docker_shell start - start persistent container
docker_shell stop - stop persistent container
docker_shell rm - remove persistent container
docker_shell help - display usage message
usage - override to customize help message (see example)
usage_default - outputs default help message
usage_template - outputs template for default help message

# customize usage message
function usage {
  P=\$(basename "\$0")
  usage_template | \\
  sed \\
    -e 's/\(@SHELL_NAME@ run\).*/\1 my --run example/' \\
    -e 's/\(@SHELL_NAME@ exec\).*/\1 my --exec example/' \\
    -e "s/@SHELL_NAME@/\$P/g"
  cat <<__EOF__

More usage here.
__EOF__
}
__USAGE__
exit
fi
function usage {
  usage_default
}
function usage_default {
  P=$(basename "$0")
  usage_template | sed -e "s/@SHELL_NAME@/${P}/g"
}
function usage_template {
  cat <<__USAGE__
# run command inside throwaway container
@SHELL_NAME@ run bash --version

# exec command inside persistent container
@SHELL_NAME@ exec hostname

# create, start, stop, and remove persistent container
@SHELL_NAME@ create
@SHELL_NAME@ start
@SHELL_NAME@ stop
@SHELL_NAME@ rm

# print this message
@SHELL_NAME@ help
__USAGE__
}
DOCKER_SHELL_WORKDIR='/data'
DOCKER_SHELL_DAEMON_COMMAND=(sleep infinity)
if [[ -n "${DOCKER_SHELL_CONFIG}" ]]; then
  source "${DOCKER_SHELL_CONFIG}" || exit 1
fi
TTY_ARGS=(-i)
tty &>/dev/null && TTY_ARGS+=(-t)
function _docker_shell_run {
  local ARGS=(
    --rm
    "${TTY_ARGS[@]}"
    --workdir "${DOCKER_SHELL_WORKDIR}"
    "${DOCKER_SHELL_ARGS_RUN[@]}"
    "${DOCKER_SHELL_IMAGE:?}"
  )
  docker run "${ARGS[@]}" "$@"
}
function _docker_shell_create {
  cd ~
  local DOCKER_SHELL_ARGS_RUN=(
    --rm=false
    -d
    --name "${DOCKER_SHELL_CONTAINER:?}"
    "${DOCKER_SHELL_ARGS_CREATE[@]}"
  )
  _docker_shell_run "${DOCKER_SHELL_DAEMON_COMMAND[@]}"
}
function _docker_shell_exec {
  # exec docker exec "${TTY_ARGS[@]}" --workdir "${PWD}" "${DOCKER_SHELL_CONTAINER}" "$@"
  SCRIPT="
    if ! cd '${DOCKER_SHELL_WORKDIR}' 2>/dev/null; then
      echo 'ERROR: Cannot exec into container ${DOCKER_SHELL_CONTAINER}: Cannot cd: ${DOCKER_SHELL_WORKDIR}';
      exit 2;
    fi;
    exec \"\$@\""
  docker exec "${TTY_ARGS[@]}" "${DOCKER_SHELL_ARGS_EXEC[@]}" "${DOCKER_SHELL_CONTAINER:?}" bash -c "${SCRIPT}" -- "$@"
}
function docker_shell {
  case "$1" in
    exec) shift; _docker_shell_exec "$@";;
    run) shift; _docker_shell_run "$@";;
    create) _docker_shell_create;;
    start) exec docker start "${DOCKER_SHELL_ARGS_START[@]}" "${DOCKER_SHELL_CONTAINER:?}";;
    stop) exec docker stop "${DOCKER_SHELL_ARGS_STOP[@]}" "${DOCKER_SHELL_CONTAINER:?}";;
    rm) exec docker rm -f "${DOCKER_SHELL_ARGS_RM[@]}" "${DOCKER_SHELL_CONTAINER:?}";;
    *) usage;;
  esac
}
