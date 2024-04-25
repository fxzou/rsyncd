FROM alpine

VOLUME [ "/etc/periodic" ]

RUN apk add --no-cache rsync tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && apk del tzdata

RUN echo -e '#!/bin/sh \ncrond\nrsync --daemon --no-detach --config=/etc/rsyncd.conf' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
