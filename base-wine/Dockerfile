# Wine docker image base
# fork of from maintainer "Jessie Frazelle <jess@linux.com>"
# docker build -t akrisiun/buster-wine:latest .
# docker push akrisiun/buster-wine

# RUN
# IP=<host ip> docker run -it -e DISPLAY=$IP:0 --name wine0 akrisiun/buster-wine bash
# macOS
# xhost local:root &
# IP=192.168.1.9 docker run -it -e DISPLAY=$IP:0 --name wine0 akrisiun/buster-wine bash

FROM debian:buster-slim
MAINTAINER AndriusK<akrisiun@gmail.com>

# install wine
RUN apt-get update && apt-get install -y \
    wine ca-certificates libgl1-mesa-dri libgl1-mesa-glx \
    --no-install-recommends && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    wine32 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV HOME /root
WORKDIR $HOME
