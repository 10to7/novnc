[![Weekly update generator](https://github.com/10to7/novnc/actions/workflows/weekly_version_check.yml/badge.svg)](https://github.com/10to7/novnc/actions/workflows/weekly_version_check.yml)
[![All dependencies are up to date](https://github.com/10to7/novnc/actions/workflows/nightly_version_check.yml/badge.svg)](https://github.com/10to7/novnc/actions/workflows/nightly_version_check.yml)

# noVNC docker image

Used for a browser based X11 display.

You can find us on:
* [GitHub](https://github.com/10to7/novnc)
* [Docker Hub](https://hub.docker.com/r/10to7/novnc)

Dependencies:
* [noVNC](https://github.com/novnc/noVNC)
* [Websockify](https://github.com/novnc/websockify)

Based on a noVNC docker setup by psharkey, which can be found [here](https://github.com/psharkey/docker/tree/master/novnc).

## Example

You can run unix applications that require a $DISPLAY within a docker container.

Below is an example `docker-compose.yml` opening intelliJ inside a browser on port 8080.

[noVNC example gist](https://gist.github.com/3adb151df0501f1d609c2472bd7458bc.git)
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

In a browser open <http://localhost:8080/vnc.html>
