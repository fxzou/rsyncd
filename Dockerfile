FROM alpine

VOLUME [ "/config" ]

RUN apk add --no-cache rsync tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && apk del tzdata

COPY ./scripts /scripts

COPY ./templates /templates

RUN chmod +x /scripts/*.sh

ENTRYPOINT [ "sh", "/scripts/entrypoint.sh" ]
