FROM debian:testing

RUN : \
 && useradd --uid 2000 \
    --user-group --groups users,sudo \
    --shell /bin/bash --no-create-home \
     rjuliano \
 && mkdir -p /home/rjuliano \
 && chown rjuliano: /home/rjuliano \
 && mkdir -p /etc/sudoers.d \
 && echo 'rjuliano ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/rjuliano \

 && for n in $(seq 1 7); do ln -s "/mnt/home/rob/common/$n" /home/rjuliano/; done \
 && for n in bash.d gitconfig ssh vim; do ln -s "7/repos/dotfiles/$n" "/home/rjuliano/.$n"; done \
 && ln -s .bash.d/bash_profile.sh /home/rjuliano/.bash_profile \
 && ln -s /mnt/home/rob/common/mutt /home/rjuliano/.mutt \
 && ln -s /mnt/home/rob/common/frames /home/rjuliano/ \

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
    less \
    libdate-manip-perl \
    man \
    mlocate \
    mutt ssmtp \
    lsof \
    patch \
    poppler-utils \
    rsync \
    sudo \
    symlinks \
    tree \
    unzip \
    vim-gtk \
    zip unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \

 && curl -sSL 'https://get.docker.com/builds/Linux/x86_64/docker-1.12.1.tgz' | tar xzf - --strip-components=1 -C /usr/bin \
 && curl -sSL 'https://raw.githubusercontent.com/docker/docker/v1.12.1/contrib/completion/bash/docker' -o /usr/share/bash-completion/completions/docker \

 && sed -i -e 's/^# \(PRUNENAMES=\)/\1/' -e '/^PRUNEFS=/s%"$% vboxfs"%' /etc/updatedb.conf \
 && rm -rf /var/lib/mlocate \
 && ln -s /mnt/home /var/lib/mlocate \

 && :

ENV TERM=xterm-256color \
    LC_ALL=C.UTF-8 \
    SHELL=/bin/bash

USER rjuliano
WORKDIR /home/rjuliano
COPY Dockerfile build run /src/
