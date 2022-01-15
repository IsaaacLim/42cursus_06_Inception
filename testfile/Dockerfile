# Mariadb

FROM alpine:3

# RUN apk update && apk add --no-cache mysql
# RUN apk update && apk add mysql \
# 	rm -rf /var/cache/apk/*
RUN apk add --no-cache mariadb

COPY tools/configure.sh configure.sh
ENTRYPOINT [ "sh", "configure.sh" ]
