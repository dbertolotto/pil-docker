### build picolisp (64bit w/ httpGate) and create a lightweight base image
### see also https://software-lab.de/INSTALL

### args
# alpine container tag
ARG ALPINE_VER=latest
# picolisp version (leave empty for latest)
ARG PIL_VER=
# flag to compile httpgate with ipv4 (for windows compatibility)
ARG GATE_IPV4=TRUE

### builder stage for building picolisp
FROM alpine:${ALPINE_VER} AS builder
WORKDIR /build
ARG PIL_VER
ARG GATE_IPV4
# requires build-base for build tools
# requires java to bootstrap 64-bit version
# requires openssl to build httpGate
RUN apk add --no-cache build-base openjdk11 openssl-dev
# hack to compile httpGate for IPv4 and make it work on windows
# see https://github.com/ckkashyap/picoLisp/blob/contrib/src/httpGate.c
# credits to ckkashyap
COPY httpGateIPv4.c httpGate.c
# picolisp install
RUN wget -O picoLisp.tgz https://software-lab.de/picoLisp`[ -n "$PIL_VER" ] && echo "-$PIL_VER"`.tgz && \
    tar xfz picoLisp.tgz && \
    cd picoLisp && \
    (cd src64; make) && \
    `[ -n "$GATE_IPV4" ] && cp /build/httpGate.c ./src` && \
    (cd src; make gate)

### final stage
# add a "pil" user
FROM alpine:${ALPINE_VER}
ARG ALPINE_VER
ARG PIL_VER
ARG GATE_IPV4
# installs tini for process handling
# installs sudo for httpGate handling
RUN apk add --no-cache tini sudo
# get picolisp from the previous build stage
COPY --from=builder /build/picoLisp /picolisp
# setup
RUN chmod -R 555 /picolisp && \
    ln -s /picolisp /usr/lib/picolisp && \
    ln -s /picolisp/bin/picolisp /usr/bin/picolisp && \
    ln -s /picolisp/bin/pil /usr/bin/pil && \
    ln -s /picolisp/bin/httpGate /usr/bin/httpGate && \
    adduser --disabled-password -u 1000 pil && \
    echo "pil ALL=(ALL) NOPASSWD: /usr/bin/httpGate" > /etc/sudoers.d/pil

LABEL alpine.version=${ALPINE_VER} \
      picolisp.version=${PIL_VER} \
      httpgate.ipv4=${GATE_IPV4}
