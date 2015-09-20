# Rust + Cargo

Includes:
- The Rust Programming Language
- Cargo, Rust's Package Manager
- GDB: The GNU Project Debugger
- Valgrind
- racer (available \*-racer tagged images)

Based on Debian Jessie

# Create named volume for persistent/shared .cargo directory
```sh
# docker <= 1.8.x
docker rm $(docker create --volume dot-cargo:/whatever scratch .)
# docker >= 1.9.0
docker volume create --name dot-cargo
```

# Setup environment
## Using aliases
```sh
alias rust-shell='docker run --rm -it --volume dot-cargo:/root/.cargo --volume "${PWD}:${PWD}" --workdir="${PWD}" -e USER="${USER}" rovjuvano/rust-lang:1.3.0'
alias cargo='rust-shell cargo'
alias rustc='rust-shell rustc'
```
## Using the scripts from the [source project](https://github.com/rovjuvano/docker-files/tree/master/rust-lang/bin)
```sh
### Run inside throwaway container
# specify which rust image to use when creating the container
export DOCKER_RUST_TAG=rovjuvano/rust-lang:1.3.0-racer
cargo test

### exec inside reusable container for faster execution
# specify which rust image to use when creating the container and the name of reusable container
export DOCKER_RUST_TAG=rovjuvano/rust-lang:1.3.0-racer
export DOCKER_RUST_CONTAINER=rust-1.3-racer
rust-shell --start-container
cargo test
```

# Examples

## Run tests using cargo
```sh
cargo test
```

## Run gdb or valgrind against test binary
```sh
rust-shell gdb target/debug/my-bin-0123456789abcdef
rust-shell valgrind target/debug/my-bin-0123456789abcdef
```

## Get explanation of error
```sh
rustc -e ....
```

## Set environment variables
```sh
rust-shell env RUST_BACKTRACE=1 cargo run
```

## Open shell prompt inside container
```sh
rust-shell /bin/bash
```

## Notes
The `rust-shell` alias and script will auto-create the `dot-cargo` volume using the pre-1.9 technique, but this feature may be removed in future versions of docker in favor of the `docker volume` sub-command added in `1.9`.

Smoke tested with Docker Toolbox v1.8.1 on MacOS 10.10
