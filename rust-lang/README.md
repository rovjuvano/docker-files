# Rust + Cargo

Includes:
- The Rust Programming Language
- Cargo, Rust's Package Manager
- GDB: The GNU Project Debugger
- Valgrind

Based on Debian Jessie

# Examples

## Run tests using cargo
```sh
alias cargo='docker run --rm -t --volume "$(pwd):/data" rovjuvano/rust:1.0.0-beta.5 cargo'
```

```sh
cargo test
```

Runs `cargo test` against the current directory within the container

## Run gdb or valgrind against test binary
```sh
alias rust-shell='docker run --rm -it --volume "$(pwd):/data" rovjuvano/rust:1.0.0-beta.5'
```

```sh
rust-shell gdb target/debug/my-bin-0123456789abcdef
rust-shell valgrind target/debug/my-bin-0123456789abcdef
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
smoke tested with Docker v1.5.0 and Boot2Docker v1.5.0 on MacOS
