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

# Sponsored by
This Docker image has been sponsored by INSITU Ingenieria: https://ingenieriainsitu.com/en/

# Docker gdalecw

gdal:2.4.4_ECW Docker images (with Python 3).

```bash
docker run --rm -it ginetto/gdal:2.4.4_ECW
```

Using a data volume
```bash
$ export DATAFOLDER="-v /folder_with_your_testdata/:/home/datafolder"
$ docker run $DATAFOLDER --name gdalecw -it --rm ginetto/gdal:2.4.4_ECW /bin/bash
```

## How to abandon ECW to compressed GTiff

if my ECW image is ```/path/to/my.ecw``` I can convert with:
```
docker run --rm -it --name gdalecw -v /path/to/:/home/datafolder
            ginetto/gdal:2.4.4_ECW
            gdal_translate
                /home/datafolder/my.ecw
                /home/datafolder/my.tif
```
Use ```-u``` option in ```docker run``` command to avoid to have result with uid=0 (root). See https://docs.docker.com/engine/reference/run/

### GTIFF compression parameters

see guides in:
http://blog.cleverelephant.ca/2015/02/geotiff-compression-for-dummies.html
https://kokoalberti.com/articles/geotiff-compression-optimization-guide/

apply optimization as ```-wo``` options to ```gdal_translate``` command


## Build the image on your own
```bash
$ git clone https://github.com/luipir/docker-gdalecw.git
$ cd docker-gdalecw
$ docker-compose up
```
This will create and run automatically ```ginetto/gdal:2.4.4_ECW``` image.

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
 - https://trac.osgeo.org/gdal/wiki/Release/2.4.4-News

## GDAL 2 info
- http://download.osgeo.org/gdal/presentations/GDAL%202.1%20(FOSS4G%20Bonn%202016).pdf
- https://2015.foss4g-na.org/session/gdal-20-overview
- http://trac.osgeo.org/gdal/wiki/GDAL20Changes

## Credits
- https://github.com/OSGeo/gdal
- https://registry.hub.docker.com/u/geodata/gdal/

GDAL compilations steps are inspired by:
- https://github.com/GeographicaGS/Docker-GDAL2

ECW installation is inspired by:
- https://gist.github.com/klokan/bfd4a07e8072ffae4bb6
