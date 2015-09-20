# Rust + Cargo

Includes:
- The Rust Programming Language
- Cargo, Rust's Package Manager
- GDB: The GNU Project Debugger
- Valgrind

Based on Debian Jessie

# Setup useful aliases
```sh
alias rust-shell='docker run --rm -it --volume /var/lib/docker/tmp/dot-cargo:/root/.cargo --volume "$(pwd):/data" -e USER="${USER}" rovjuvano/rust-lang:1.2.0'
alias cargo='rust-shell cargo'
alias rustc='rust-shell rustc'
```
Use whatever you like for the .cargo directory. Example persists across restarts when using Docker Toolbox (formerly Boot2Docker).

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

Modifications to container are discarded. If you understand the rust-shell alias or the Dockerfile, feel free to create persistent containers or build your own updated images.

## Notes
smoke tested with Docker Toolbox v1.8.1 on MacOS 10.10
