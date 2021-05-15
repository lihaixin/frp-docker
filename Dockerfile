FROM alpine:3.8
MAINTAINER docker <docker@gmail.com>
ARG Frp_ver=0.36.2
ENV DASHBOARD_PWD password
ENV TOKEN 12345678
ENV ALLOW_PORTS 10000-10020
ENV MAX_POOL_COUNT 10
ENV SUBDOMAIN_HOST frps.com
ENV FRP_PORT 443
ENV V_HTTP_PORT 80
ENV V_HTTPS_PORT 443
ENV TZ=Asia/Shanghai

RUN apk add -U tzdata && \
    wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v${Frp_ver}/frp_${Frp_ver}_linux_amd64.tar.gz && \
    tar -zxf frp_${Frp_ver}_linux_amd64.tar.gz && \
    mkdir /var/frp && \
    mv frp_${Frp_ver}_linux_amd64/* /var/frp && \
    rm -rf frp_${Frp_ver}_linux_amd64.tar.gz 

RUN mkdir /var/frp/conf
ADD frpc.ini /var/frp/conf
ADD frps.ini /var/frp/conf
ADD 404.html /var/frp/conf
ADD server.crt /var/frp/conf
ADD server.key /var/frp/conf

# WORKDIR /var/frp

#ENTRYPOINT ./frps -c conf/frps.ini
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
