# FROM --platform=${TARGETPLATFORM} alpine:latest
FROM --platform=${TARGETPLATFORM} ubuntu:22.04
# LABEL maintainer="V2Fly Community <dev@v2fly.org>"

WORKDIR /tmp
ARG TARGETPLATFORM
ARG ISCHINA
COPY entrypoint.sh /entrypoint.sh
COPY v2ray-linux-64/v2ray "${WORKDIR}"/v2ray
COPY v2ray-linux-64/geosite.dat "${WORKDIR}"/geosite.dat
COPY v2ray-linux-64/geoip.dat "${WORKDIR}"/geoip.dat
COPY v2ray-linux-64/config.json "${WORKDIR}"/config.json

RUN if [ -n "$ISCHINA" ] ; then sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean && apt-get update ; fi

# Install Warp plus
RUN apt-get install curl gnupg -y \
    && curl https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ jammy main" | tee /etc/apt/sources.list.d/cloudflare-client.list \ 
    && apt-get update \
    && apt-get install cloudflare-warp -y

# Install V2ray
RUN set -ex \
    && apt-get install ca-certificates unzip -y \
    && mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/v2ray/access.log \
    && ln -sf /dev/stderr /var/log/v2ray/error.log \
    && chmod +x "${WORKDIR}"/v2ray \
    && mv "${WORKDIR}"/v2ray /usr/bin/ \
    && mv "${WORKDIR}"/geosite.dat "${WORKDIR}"/geoip.dat /usr/local/share/v2ray/ \
    && mv "${WORKDIR}"/config.json /etc/v2ray/config.json

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]