ARG ALPINE_VERSION=3

FROM alpine:${ALPINE_VERSION}

ARG NO_VNC_TAG=v1.4.0 \
    WEB_SOCKIFY_TAG=v0.11.0

LABEL org.opencontainers.image.source="https://github.com/10to7/novnc" \
	  org.opencontainers.image.licenses="MIT" \
	  org.opencontainers.image.title="novnc" \
	  org.opencontainers.image.description="Alpine Linux with noVNC" \
	  org.opencontainers.image.url="10to7/novnc" \
	  org.opencontainers.image.vendor="10to7" \
	  org.opencontainers.image.documentation="https://github.com/10to7/novnc"

# Setup demo environment variables
ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	DISPLAY=:0.0 \
	DISPLAY_WIDTH=1024 \
	DISPLAY_HEIGHT=768

# Install git, supervisor, VNC, & X11 packages
RUN apk add \
	bash \
	git \
	socat \
	supervisor \
	x11vnc \
	xvfb \
	fluxbox --no-cache \
    && git clone --depth 1 --branch "${NO_VNC_TAG}" https://github.com/novnc/noVNC.git /root/noVNC \
	&& git clone --depth 1 --branch "${WEB_SOCKIFY_TAG}" https://github.com/novnc/websockify /root/noVNC/utils/websockify \
	&& rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/.gitignore \
	&& rm -rf /root/noVNC/.gitmodules \
	&& rm -rf /root/noVNC/.github \
	&& rm -rf /root/noVNC/.eslintignore \
	&& rm -rf /root/noVNC/.eslintrc \
	&& rm -rf /root/noVNC/tests \
	&& rm -rf /root/noVNC/utils/websockify/.git \
	&& rm -rf /root/noVNC/utils/websockify/.gitignore \
	&& apk del git \
	&& rm -rf /var/cache/apk/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080 6000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
