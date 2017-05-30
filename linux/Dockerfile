FROM debian:testing

RUN : \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    bash-completion \
    bc \
    bind9-host \
    curl ca-certificates \
    dos2unix \
    dnsutils \
    file \
    git \
    git-annex gnupg nocache \
    locales \
    less \
    libdate-manip-perl \
    man \
    mlocate \
    mutt ssmtp \
    lsof \
    patch \
    poppler-utils \
    procps \
    rsync \
    sudo \
    symlinks \
    tree \
    unzip \
    vim-gtk \
    zip unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \

 && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
 && locale-gen \
 && update-locale LANG=en_US.UTF-8 \

 && docker_version=17.05.0-ce \
 && curl -sSL "https://get.docker.com/builds/Linux/x86_64/docker-${docker_version}.tgz" | tar xzf - --strip-components=1 -C /usr/bin docker/docker \
 && curl -sSL "https://raw.githubusercontent.com/docker/docker/v${docker_version}/contrib/completion/bash/docker" -o /usr/share/bash-completion/completions/docker \

 && sed -i -e 's/^# \(PRUNENAMES=\)/\1/' -e '/^PRUNEFS=/s%"$% vboxfs"%' /etc/updatedb.conf \
 && rm -rf /var/lib/mlocate \
 && ln -s /mnt/home /var/lib/mlocate \

 && :

ENV LANG=en_US.UTF-8 \
    SHELL=/bin/bash

COPY Dockerfile build run /src/rovjuvano/shell-linux/
