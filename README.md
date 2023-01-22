# noVNC docker image
Used for a browser based X11 display.

Based on https://github.com/psharkey/docker/tree/master/novnc

## Example

You can run unix applications that require a $DISPLAY within a docker container.

Below is an example `docker-compose.yml` opening intelliJ inside a browser on port 8080.
```yaml
version: '3.8'

services:
  ide:
    image: psharkey/intellij:latest
    environment:
      - DISPLAY=novnc:0.0
    depends_on:
      - novnc
  novnc:
    image: 10to7/novnc:latest
    environment:
      # Adjust to your screen size
      - DISPLAY_WIDTH=1600
      - DISPLAY_HEIGHT=968
    ports:
      - "8080:8080"
```

### To run: 

`docker-compose up -d`

In a browser open http://localhost:8080/vnc.html
