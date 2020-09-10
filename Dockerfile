FROM php:7.2.19-fpm

WORKDIR /build

COPY test.php /build/
COPY test.sql /build/

ENV USER me

RUN apt update \
    && apt install -y --no-install-recommends \
    wget \
    fossil \
    libsqlite3-dev \
    libfreexl-dev \
    libgeos-dev \
    automake \
    libtool \
    libminizip-dev \
    libexpat-dev \
    zlib1g-dev \
    libproj-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://git.osgeo.org/gitea/rttopo/librttopo/archive/librttopo-1.1.0.tar.gz \
    && tar -xzf librttopo-1.1.0.tar.gz \
    && cd librttopo \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make -j8 \
    && make install

RUN cd /build \
    && wget http://www.gaia-gis.it/gaia-sins/libspatialite-5.0.0.tar.gz \
    && tar -xzf libspatialite-5.0.0.tar.gz \
    && cd libspatialite-5.0.0 \
    && ./configure --disable-geos370 --enable-rttopo=yes --prefix=/usr \
    && make -j8 \
    && make install

RUN cd /build \
    && fossil clone https://www.gaia-gis.it/fossil/readosm readosm.fossil \
    && mkdir readosm \
    && cd readosm \
    && fossil open ../readosm.fossil \
    && ./configure --prefix=/usr \
    && make -j8 \
    && make install

RUN cd /build \
    && fossil clone https://www.gaia-gis.it/fossil/spatialite-tools spatialite-tools.fossil \
    && mkdir spatialite-tools \
    && cd spatialite-tools \
    && fossil open ../spatialite-tools.fossil \
    && ./configure --prefix=/usr \
    && make -j8 \
    && make install

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && echo "sqlite3.extension_dir=/usr/lib" > $PHP_INI_DIR/conf.d/sqlite.ini

RUN spatialite /build/address.db < /build/test.sql
