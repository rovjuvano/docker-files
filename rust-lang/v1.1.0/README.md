# Rust + Cargo

Includes:
- The Rust Programming Language
- Cargo, Rust's Package Manager
- GDB: The GNU Project Debugger
- Valgrind

Based on Debian Jessie

# Create data container for persistent .cargo directory
```sh
docker run --name dot-cargo --volume /root/.cargo tianon/true:latest
```

# Setup useful aliases
```sh
alias rust-shell='docker run --rm -it --volumes-from dot-cargo --volume "$(pwd):/data" rovjuvano/rust-lang:1.1.0'
alias cargo='rust-shell cargo'
alias rustc='rust-shell rustc'
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
rust-shell env USER="foo <foo@example.com>" cargo new bar
```

## Open shell prompt inside container
```sh
rust-shell /bin/bash
```

Modifications to container are discarded. If you understand the rust-shell alias or the Dockerfile, feel free to create persistent containers or build your own updated images.

## Notes
smoke tested with Docker v1.5.0 and Boot2Docker v1.5.0 on MacOS
