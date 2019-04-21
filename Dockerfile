##
# ***************************************************************************
#     begin                : April 2019
#     author               : (C) 2019 by Luigi Pirelli
#     author email         : luipir at gmail dot com
#     copyright            : (C) 2019 INSITU
#     company web          : https://ingenieriainsitu.com/en/
# ***************************************************************************
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU General Public License as published by  *
# *   the Free Software Foundation; either version 2 of the License, or     *
# *   (at your option) any later version.                                   *
# *                                                                         *
# ***************************************************************************
##
# ginetto/gdal:2.4.1_ECW
#
# This creates a light Debian derived base image that installs GDAL 2 with ECW extension.
FROM debian:stable-slim
MAINTAINER Luigi Pirelli <luipir@gmail.com>

# Load assets overrided in docker-compose.yml
ENV ROOTDIR /usr/local/
ARG GDAL_VERSION=2.4.1
ARG ECW_INSTALLER=ERDASECWJP2SDKv54Update1forLinux
ARG ECW_UNZIPPED_INSTALLER=ERDAS_ECWJP2_SDK-5.4.0.bin
ARG ECW_INSTALLED_PATH=ERDAS-ECW_JPEG_2000_SDK-5.4.0

# Install basic dependencies
# on an update system
RUN apt-get update -y && \
    apt-get install -y \
    software-properties-common \
    build-essential \
    python-dev \
    python3-dev \
    python-numpy \
    python3-numpy \
    libspatialite-dev \
    sqlite3 \
    libpq-dev \
    libcurl4-gnutls-dev \
    libproj-dev \
    libxml2-dev \
    libgeos-dev \
    libnetcdf-dev \
    libpoppler-dev \
    libspatialite-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev \
    bash-completion \
    cmake \
    unzip

# maintain the system clean to slim it
RUN    apt clean \ 
    && apt autoclean \
    && apt autoremove

ADD https://go.hexagongeospatial.com/${ECW_INSTALLER} $ROOTDIR/ERDAS_ECW_SDK/
# use this in case already downloaded or hexagon change the way to download
#COPY ./${ECW_INSTALLER} $ROOTDIR/ERDAS_ECW_SDK/
ADD http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz $ROOTDIR/src/

# Prepare ECW SDK accepting the lincese and installing:
# Desktop_Read-Only (eg. choise 1)
# command MORE=-v is useful to avoid to block installer reading the license.
# see 'more' command documentation.
# printf '1\nyes\n' is useful only to simulate user to select and accept license
RUN    cd $ROOTDIR/ERDAS_ECW_SDK/ \
    && unzip ${ECW_INSTALLER} \
    && printf '1\nyes\n' | MORE=-V bash ./${ECW_UNZIPPED_INSTALLER} \
    && mv /hexagon $ROOTDIR

RUN rm -fr $ROOTDIR/ERDAS_ECW_SDK

# configuring ECW SDK to allow gdal compilation
RUN    cp -r $ROOTDIR/hexagon/${ECW_INSTALLED_PATH}/Desktop_Read-Only/* $ROOTDIR/hexagon \
    && rm -fr $ROOTDIR/hexagon/${ECW_INSTALLED_PATH}/Desktop_Read-Only \
    && rm -r $ROOTDIR/hexagon/lib/x64 \
    && mv $ROOTDIR/hexagon/lib/newabi/x64 $ROOTDIR/hexagon/lib/x64 \
    && cp $ROOTDIR/hexagon/lib/x64/release/libNCSEcw* $ROOTDIR/lib \
    && ldconfig $ROOTDIR/hexagon

# # Compile and install GDAL
WORKDIR $ROOTDIR/
RUN    cd src \
    && tar -xvf gdal-${GDAL_VERSION}.tar.gz \
    && cd gdal-${GDAL_VERSION} \
    && ./configure --with-python --with-spatialite --with-pg --with-curl --with-ecw=/usr/local/hexagon \
    && make -j $(nproc) \
    && make install && ldconfig \
    && apt-get update -y \
    && cd $ROOTDIR \
    && cd src/gdal-${GDAL_VERSION}/swig/python \
    && python3 setup.py build \
    && python3 setup.py install \
    && apt-get remove -y --purge build-essential  python-dev python3-dev \
    && cd $ROOTDIR \
    && rm -Rf src/gdal*

# # Output version and capabilities by default.
CMD    gdalinfo --version \
    && gdalinfo --formats \
    && ogrinfo --formats
