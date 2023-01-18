FROM alpine:3.17.1

USER root

COPY /jq /app

RUN apk update; \
    apk add --upgrade \
        libtool \
        make \
        autoconf \
        automake \
        build-base \
        bison \
        flex \
        python3 \
        py3-pip \
        wget \
    && \
    pip3 install pipenv && \
    pipenv lock && \
    (cd /app/docs && pipenv sync) && \
    (cd /app && \
        autoreconf -fi && \
        ./configure --disable-valgrind --enable-all-static --prefix=/usr/local && \
        make -j8 && \
        make check )

FROM alpine:3.17.1

RUN adduser -D jq jq

USER jq

COPY --from=0 --chown=jq:jq /app/jq /jq

ENTRYPOINT ["./jq"]
CMD []