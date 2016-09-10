FROM alpine:3.4

EXPOSE 137 139 445

RUN apk add -U samba-common-tools samba-server \
 && addgroup smbuser \
 && ln -s /src/smb.conf /etc/samba/ \
 && ln -s /src/create-user /usr/local/bin/create-user \
 && ln -s /src/delete-user /usr/local/bin/delete-user \
 && rm -rf /var/cache/apk/*

CMD smbd -FS < /dev/null
COPY smb.conf create-user delete-user Dockerfile build run /src/
