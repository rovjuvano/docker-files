# Rust + Cargo

Includes:
- The Rust Programming Language
- Cargo, Rust's Package Manager
- GDB: The GNU Project Debugger
- Valgrind
- racer (available \*-racer tagged images)

Based on Debian Jessie

# Setup environment (choose one)
## Using scripts and persistent containers (recommended)
- install [docker-shell.sh](https://github.com/rovjuvano/docker-files/tree/master/bin/docker-shell.sh) onto path
- install [rust-shell scripts](https://github.com/rovjuvano/docker-files/tree/master/rust-lang/bin) onto path and make executable

```sh
# specify which rust version to use when creating the container
export DOCKER_RUST_VERSION=1.5.0-racer

# create persistent container
rust-shell create

# run commands
rustc --version
cargo test

# more info
rust-shell help
```
## Or using aliases and throwaway containers
```sh
alias rust-shell='docker run --rm -it --volume "${PWD}:${PWD}" --workdir="${PWD}" -e USER="${USER}" rovjuvano/rust-lang:1.5.0 bash -c "\${@:2}" --'
alias cargo='rust-shell run cargo'
alias rustc='rust-shell run rustc'
```

# Example usage

## Run tests using cargo
```sh
cargo test
```

## Run gdb or valgrind against test binary
```sh
rust-shell exec gdb target/debug/my-bin-0123456789abcdef
rust-shell exec valgrind target/debug/my-bin-0123456789abcdef
```

## Get explanation of error
```sh
rustc --explain E0001
```

## Set environment variables
```sh
rust-shell exec env RUST_BACKTRACE=1 cargo run
```

## Open shell prompt inside container
```sh
rust-shell exec /bin/bash
```

## Notes
Smoke tested with Docker Toolbox v1.8.1 on MacOS 10.10
