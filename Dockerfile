FROM ubuntu:jammy-20221020 as system

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && apt-get autoclean -y \
    && apt-get autoremove -y

RUN apt-get install -y lxde
RUN apt-get install -y tightvncserver
RUN apt-get install -y novnc python3-websockify python3-numpy
RUN apt-get install -y sudo

ARG username=user
ARG password=user

RUN useradd \
	--create-home \
	--shell /bin/bash \
	--user-group \
	--groups adm,sudo \
	--password "$(openssl passwd -1 $password)"\
	$username
	
RUN mv /usr/bin/lxpolkit /usr/bin/lxpolkit.ORIG	

WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health

COPY entrypoint.sh /opt/
ENTRYPOINT ["/opt/entrypoint.sh"]

USER user
