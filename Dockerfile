# FROM --platform=${TARGETPLATFORM} alpine:latest
FROM --platform=${TARGETPLATFORM} ubuntu:22.04
# LABEL maintainer="V2Fly Community <dev@v2fly.org>"

WORKDIR /tmp
ARG TARGETPLATFORM
COPY v2ray-linux-64/v2ray "${WORKDIR}"/v2ray
COPY v2ray-linux-64/geosite.dat "${WORKDIR}"/geosite.dat
COPY v2ray-linux-64/geoip.dat "${WORKDIR}"/geoip.dat
COPY v2ray-linux-64/config.json "${WORKDIR}"/config.json

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update

RUN set -ex \
    && apt-get install ca-certificates unzip -y \
    && mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/v2ray/access.log \
    && ln -sf /dev/stderr /var/log/v2ray/error.log \
    && chmod +x "${WORKDIR}"/v2ray \
    && cp "${WORKDIR}"/v2ray /usr/bin/ \
    && cp "${WORKDIR}"/geosite.dat "${WORKDIR}"/geoip.dat /usr/local/share/v2ray/ \
    && cp "${WORKDIR}"/config.json /etc/v2ray/config.json

# ENTRYPOINT ["/usr/bin/v2ray"]
