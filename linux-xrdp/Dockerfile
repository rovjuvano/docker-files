FROM rovjuvano/shell-linux:1b5t

RUN : \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    lxterminal \
    xauth \
    xorg \
    xorgxrdp \
    xrdp \
    openbox \

 && sed -i -e 's/^use-ssh-agent/#\0/' /etc/X11/Xsession.options \
 && echo 'export GTK_IM_MODULE=xim' > /etc/X11/Xsession.d/80x11-disable-crtl-shift-u \

 && :

EXPOSE 3389

COPY Dockerfile build run /src/rovjuvano/shell-linux-xrdp/
