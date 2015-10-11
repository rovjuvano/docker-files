#!/bin/bash -e
if [ ${#BASH_SOURCE[@]} == 1 ]; then
  cat <<__USAGE__
# helper functions to run or exec commands inside docker containers. e.g.
cat <<'__EOF__' > my-shell
#!/bin/bash
source "${BASH_SOURCE[0]}"
DOCKER_SHELL_IMAGE=debian:jessie
DOCKER_SHELL_CONTAINER=shell-debian-jessie
DOCKER_SHELL_DAEMON_COMMAND=/bin/bash
DOCKER_SHELL_ARGS_RUN='-e MY_VAR=my-value'
DOCKER_SHELL_ARGS_EXEC='--user=nobody'
DOCKER_SHELL_ARGS_CREATE="\${DOCKER_SHELL_ARGS_RUN}"
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
DOCKER_SHELL_IMAGE - image to use when creating container or running command
DOCKER_SHELL_CONTAINER - container to use when execing command
DOCKER_SHELL_ARGS_RUN - additional arguments to pass to \`docker run\`
DOCKER_SHELL_ARGS_EXEC - additional arguments to pass to \`docker exec\`
DOCKER_SHELL_ARGS_CREATE - additional arguments to pass to \`docker create\`
DOCKER_SHELL_ARGS_START - additional arguments to pass to \`docker start\`
DOCKER_SHELL_ARGS_STOP - additional arguments to pass to \`docker stop\`
DOCKER_SHELL_ARGS_RM - additional arguments to pass to \`docker rm\`
DOCKER_SHELL_DAEMON_COMMAND - command to keep container running (defaults to \`sleep infinity\`)

# public functions
docker_shell run ... - run command inside throwaway container with current host directory as working directory
docker_shell exec ... - exec command inside persistent container with current host directory as working directory
docker_shell create - create persistenent container with host home directory mounted inside container
docker_shell start - start persistent container
docker_shell stop - stop persistent container
docker_shell rm - remove persistent container
docker_shell help - display usage message
usage - override to customize help message (see example)
usage_default - outputs default help message
usage_template - outputs template for default help message

# customize usage message
function usage() {
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
function usage() {
  usage_default
}
function usage_default() {
  P=$(basename "$0")
  usage_template | sed -e "s/@SHELL_NAME@/${P}/g"
}
function usage_template() {
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

function _docker_shell_tty_arg() {
  echo "$(tty >/dev/null && echo -it)"
}
function _docker_shell_run() {
  docker run --rm \
    --volume "${PWD}:${PWD}" \
    --workdir "${PWD}" \
    -e TERM="${TERM}" \
    $(_docker_shell_tty_arg) \
    ${DOCKER_SHELL_ARGS_RUN} \
    "${DOCKER_SHELL_IMAGE:?}" \
    "$@"
}
function _docker_shell_create() {
  cd ~
  DOCKER_SHELL_ARGS_RUN="${DOCKER_SHELL_ARGS_CREATE} --rm=false -d --name ${DOCKER_SHELL_CONTAINER:?}"
  _docker_shell_run ${DOCKER_SHELL_DAEMON_COMMAND:-sleep infinity}
}
function _docker_shell_exec() {
  # exec docker exec $(_docker_shell_tty_arg) --workdir "${PWD}" "${DOCKER_SHELL_CONTAINER}" "$@"
  SCRIPT="
    if ! cd '${PWD}' 2>/dev/null; then
      echo 'ERROR: Cannot exec into container ${DOCKER_SHELL_CONTAINER}: Cannot cd: ${PWD}'
      exit 2
    fi
    $@"
  docker exec $(_docker_shell_tty_arg) ${DOCKER_SHELL_ARGS_EXEC} "${DOCKER_SHELL_CONTAINER:?}" bash -c "${SCRIPT}"
}
function docker_shell() {
  case "$1" in
    exec) shift; _docker_shell_exec "$@";;
    run) shift; _docker_shell_run "$@";;
    create) _docker_shell_create;;
    start) exec docker start ${DOCKER_SHELL_ARGS_START} "${DOCKER_SHELL_CONTAINER:?}";;
    stop) exec docker stop  ${DOCKER_SHELL_ARGS_STOP} "${DOCKER_SHELL_CONTAINER:?}";;
    rm) exec docker rm -f ${DOCKER_SHELL_ARGS_RM} "${DOCKER_SHELL_CONTAINER:?}";;
    *) usage;;
  esac
}
