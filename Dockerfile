FROM ubuntu:jammy-20221020 as system

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && apt-get autoclean -y \
    && apt-get autoremove -y

RUN apt-get install -y lxde
RUN apt-get install -y tigervnc-standalone-server
RUN apt-get install -y novnc python3-websockify python3-numpy
RUN apt-get install -y sudo
RUN apt-get install -y autocutsel     # Serve a collegare le clipboard

# rimozione app inutili
RUN apt-get remove -y deluge-common lxmusic smplayer mpv pulseaudio pulseaudio-utils evince tcl tcl8.6 pavucontrol tilix firefox usermode xscreensaver
RUN apt-get -y autoremove

# Installazione package generazione e cattura di pacchetti
RUN apt-get --yes install wireshark packeth
# Installazione strumenti di rete
RUN apt-get --yes install netcat iproute2 net-tools dnsutils iputils-ping traceroute nmap
# Installazione strumenti di sviluppo
RUN apt-get --yes install make git geany
# Installazione strumenti ssh
RUN apt-get --yes install openssh-client openssh-server
# Installazione firefox (no snapd)
RUN apt-get --yes install software-properties-common
RUN add-apt-repository ppa:mozillateam/ppa
COPY etc/apt/preferences.d/mozilla-firefox /etc/apt/preferences.d/mozilla-firefox
RUN apt-get --yes install firefox

### Cleanup (moved)
RUN apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* /tmp/a.txt /tmp/b.txt

ARG username="user"
ARG password="user"

RUN useradd \
	--create-home \
	--shell /bin/bash \
	--user-group \
	--groups adm,sudo \
	--password "$(openssl passwd -1 $password)"\
	$username
	
RUN mv /usr/bin/lxpolkit /usr/bin/lxpolkit.ORIG
RUN echo "desktop" > /etc/hostname

COPY entrypoint.sh /opt/
COPY config/pcmanfm /home/$username/.config/pcmanfm
COPY vnc/xstartup /home/$username/.vnc/
COPY wallpaper.jpg /usr/share/lxde/wallpapers/

COPY home/user/.config/lxterminal/lxterminal.conf /home/user/.config/lxterminal/lxterminal.conf
RUN chmod user:user /home/user/.config/lxterminal/lxterminal.conf


RUN chown --recursive $username:$username /home/$username

CMD /opt/entrypoint.sh

