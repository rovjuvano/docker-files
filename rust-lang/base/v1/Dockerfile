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

CMD ["cargo", "help"]
