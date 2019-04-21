<!--
***************************************************************************
    begin                : April 2019
    author               : (C) 2019 by Luigi Pirelli
    author email         : luipir at gmail dot com
    copyright            : (C) 2019 INSITU
    company web          : https://ingenieriainsitu.com/en/
***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************
-->

# Docker gdalecw

gdal:2.4.1_ECW Docker images (with Python 3).

```bash
docker run --rm -it ginetto/gdal:2.4.1_ECW
```

Using a data volume
```bash
$ export DATAFOLDER="-v /folder_with_your_testdata/:/home/datafolder"
$ docker run $DATAFOLDER --name gdalecw -it --rm ginetto/gdal:2.4.1 _ECW /bin/bash
```

## Build the image on your own
```bash
$ git clone https://github.com/luipir/docker-gdalecw.git
$ cd docker-gdalecw
$ docker-compose up
```
This will create and run automatically ```ginetto/gdal:2.4.1_ECW``` image.

## Build other GDAL version
To build with other gdal version see: ```docker-compose.yml``` build args.

## Adapt buid to ECW installer
Building process would download ECW redistributable installer, but the way to download it can change due to decision about this proprietary driver.
During time, ECW installer can change the way to download. Adapt ```Dockerfile``` reflecting these changes.
Actually the Build is based on downloading the following ECW installer:
```
ERDASECWJP2SDKv54Update1forLinux
```

# Changelog
 - https://trac.osgeo.org/gdal/wiki/Release/2.4.1-News

## GDAL 2 info
- http://download.osgeo.org/gdal/presentations/GDAL%202.1%20(FOSS4G%20Bonn%202016).pdf
- https://2015.foss4g-na.org/session/gdal-20-overview
- http://trac.osgeo.org/gdal/wiki/GDAL20Changes

## Credits
- https://github.com/OSGeo/gdal
- https://registry.hub.docker.com/u/geodata/gdal/
