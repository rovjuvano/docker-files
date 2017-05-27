FROM alpine:3.6

EXPOSE 137 139 445

RUN apk add --no-cache samba-common-tools samba-server \
 && addgroup smbuser \
 && ln -sf /src/smb.conf /etc/samba/ \
 && ln -s /src/create-user /usr/local/bin/create-user \
 && ln -s /src/delete-user /usr/local/bin/delete-user

CMD smbd -FS < /dev/null
COPY smb.conf create-user delete-user Dockerfile build run /src/
