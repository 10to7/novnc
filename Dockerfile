ARG ALPINE_VERSION=3
ARG NO_VNC_TAG=v1.4.0
ARG WEB_SOCKIFY_TAG=v0.11.0

FROM alpine:${ALPINE_VERSION} AS git_sources
RUN apk add \
    bash \
    git

ARG NO_VNC_TAG \
    WEB_SOCKIFY_TAG

RUN git clone --depth 1 --branch "${NO_VNC_TAG}" https://github.com/novnc/noVNC.git /tmp/noVNC
RUN git clone --depth 1 --branch "${WEB_SOCKIFY_TAG}" https://github.com/novnc/websockify /tmp/noVNC/utils/websockify

RUN cd /tmp/noVNC \
    && rm -rf .git* \
    docs \
    tests \
    snap \
    .eslint* \
    karma.conf.js

RUN cd /tmp/noVNC/utils/websockify \
    && rm -rf .git* \
    docker \
    docs \
    tests \
    Windows \
    .eslint* \
    karma.conf.js

# Add index.html to all directories
RUN echo "<head><meta http-equiv=\"refresh\" content=\"0; URL='/vnc.html'\"/></head>" > /tmp/noVNC/index.html
RUN for dir in `find /tmp/noVNC -type d` ; do cp /tmp/noVNC/index.html $dir/index.html ; done


FROM alpine:${ALPINE_VERSION}

# Setup environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

# Install dependencies and then clean up
RUN apk add \
    bash \
    socat \
    supervisor \
    x11vnc \
    xvfb \
    fluxbox --no-cache \
    && rm -rf /var/cache/apk/*

# add novnc
COPY --from=git_sources /tmp/noVNC /root/noVNC
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports for noVNC and X11
EXPOSE 8080 6000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

ARG NO_VNC_TAG \
    WEB_SOCKIFY_TAG \
    TARGETPLATFORM \
    ALPINE_VERSION

LABEL org.opencontainers.image.source="https://github.com/10to7/novnc" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.title="novnc" \
      org.opencontainers.image.description="Alpine Linux with noVNC" \
      org.opencontainers.image.url="10to7/novnc" \
      org.opencontainers.image.vendor="10to7" \
      org.opencontainers.image.documentation="https://github.com/10to7/novnc" \
      org.opencontainers.image.version=${TARGETPLATFORM}-alpine:${ALPINE_VERSION},novnc:${NO_VNC_TAG},websockify:${WEB_SOCKIFY_TAG}