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
RUN apt-get install -y autocutsel     # Serve a collegare le clipboard

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

COPY entrypoint.sh /opt/
COPY config/pcmanfm /home/$username/.config/pcmanfm
COPY vnc/xstartup /home/$username/.vnc/

RUN chown --recursive $username:$username /home/$username

CMD ["/opt/entrypoint.sh"]

