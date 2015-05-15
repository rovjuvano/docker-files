FROM debian:jessie

RUN : \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    curl ca-certificates \
    file \
    gcc \
    libc-dev \
    gdb \
    valgrind \
 && rm -rf /var/lib/apt/lists/* \
 && :

ENV LD_LIBRARY_PATH /usr/local/lib

WORKDIR /data

RUN curl -s https://static.rust-lang.org/rustup.sh | env SHELL=/bin/sh /bin/sh -s -- --revision 1.0.0-beta.5 --disable-sudo -y

CMD ["cargo", "help"]
