### build a demo picolisp server image

### args
# picolisp version
ARG PIL_VER=latest

### final stage
FROM dbertolotto/picolisp:${PIL_VER}
COPY cert/dummy.key /cert/server.key
COPY cert/dummy.crt /cert/server.crt
COPY src /home/pil
COPY conf/entry.sh /home/pil/entry.sh
RUN chmod -R 500 /cert && \
    chown -R pil /home/pil && \
    chmod -R 755 /home/pil
# http gate port
EXPOSE 8000
# switch to normal 'pil' user
USER pil
WORKDIR /home/pil
ENTRYPOINT /home/pil/entry.sh

