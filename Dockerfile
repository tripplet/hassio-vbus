ARG BUILD_FROM
FROM $BUILD_FROM

# Install build packages
RUN apk update

RUN mkdir /src && cd /src

## vbus-collector
RUN apk add build-base git cmake sqlite-dev curl-dev linux-headers

# Add git repository source code
RUN git clone https://github.com/tripplet/vbus-collector.git --recursive --branch master --depth 1 /src/collector

RUN cd /src/collector/paho.mqtt.c && \
    mkdir build && cd build && \
    cmake -DPAHO_BUILD_STATIC=TRUE -DPAHO_ENABLE_CPACK=FALSE -DPAHO_HIGH_PERFORMANCE=TRUE .. && \
    make -j

RUN cd /src/collector/cJSON && \
    mkdir build && cd build && \
    cmake -DBUILD_SHARED_LIBS=OFF -DENABLE_CJSON_TEST=OFF -DENABLE_CJSON_UTILS=OFF -DENABLE_LOCALES=OFF .. && \
    make -j

RUN cd /src/collector && make -j && strip vbus-collector

## vbus-server
RUN apk add autoconf automake libtool

RUN git clone https://github.com/tripplet/vbus-server.git --recursive --branch master --depth 1 /src/server

RUN cd /src/server && \
    cmake -DCMAKE_BUILD_TYPE=Release -DDB_PATH=/data/data.db . && \
    make -j && strip vbus-server

#### Stage 2
FROM alpine

COPY --from=0 /src/collector/vbus-collector /bin/vbus-collector
COPY --from=0 /src/server/web/* /htdocs/

RUN apk update --no-cache && \
    apk add --no-cache tzdata libstdc++ libcurl sqlite-libs nginx fcgiwrap && \
    chown -R nginx: /htdocs && \
    chmod o+w /run

COPY rootfs /

LABEL maintainer="Tobias Tangemann"
LABEL io.hass.version="1.0" io.hass.type="addon" io.hass.arch="armhf|aarch64|amd64"

ENTRYPOINT ["/entrypoint.sh"]
