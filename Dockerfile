FROM alpine:latest

RUN apk add --no-cache curl \
	gcc\
	gdb\
	make \
	valgrind

