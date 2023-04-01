ARG ALPINE_TAG=3.17.3
ARG NOVNC_NOVNC_TAG=v1.4.0
ARG NOVNC_WEBSOCKIFY_TAG=v0.11.0

FROM alpine:${ALPINE_TAG} AS git_sources
RUN apk add \
    bash \
    git

ARG NOVNC_NOVNC_TAG \
    NOVNC_WEBSOCKIFY_TAG

RUN git clone --depth 1 --branch "${NOVNC_NOVNC_TAG}" https://github.com/novnc/noVNC.git /tmp/noVNC
RUN git clone --depth 1 --branch "${NOVNC_WEBSOCKIFY_TAG}" https://github.com/novnc/websockify /tmp/noVNC/utils/websockify

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


FROM alpine:${ALPINE_TAG}

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

ARG NOVNC_NOVNC_TAG \
    NOVNC_WEBSOCKIFY_TAG \
    TARGETPLATFORM \
    ALPINE_TAG

LABEL org.opencontainers.image.source="https://github.com/10to7/novnc" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.title="novnc" \
      org.opencontainers.image.description="Alpine Linux with noVNC" \
      org.opencontainers.image.url="10to7/novnc" \
      org.opencontainers.image.vendor="10to7" \
      org.opencontainers.image.documentation="https://github.com/10to7/novnc" \
      org.opencontainers.image.version=${TARGETPLATFORM}-alpine:${ALPINE_TAG},novnc:${NOVNC_NOVNC_TAG},websockify:${NOVNC_WEBSOCKIFY_TAG}