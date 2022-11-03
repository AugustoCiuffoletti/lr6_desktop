FROM ubuntu:jammy-20221020 as system

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get --yes install sudo ca-certificates
RUN apt-get --yes install lxde
# rimozione app lxde inutili
RUN apt-get remove -y deluge-common lxmusic smplayer mpv pulseaudio pulseaudio-utils evince tcl tcl8.6 pavucontrol tilix firefox usermode xscreensaver
# Installazione server VNC
RUN apt-get --yes install tigervnc-standalone-server
# Installazione proxy VNC and default to vnc (not vnc_lite)
RUN apt-get --yes install novnc python3-websockify python3-numpy
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html
RUN apt-get --yes install autocutsel     # Serve a collegare le clipboard novnc


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

### Cleanup
RUN apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* /tmp/a.txt /tmp/b.txt

ARG username="user"
ARG password="user"

RUN useradd \
	--create-home \
	--shell /bin/bash \
	--groups adm,sudo \
	--password "$(openssl passwd -1 $password)"\
	$username
RUN mkdir /home/$username/.ssh
	
RUN mv /usr/bin/lxpolkit /usr/bin/lxpolkit.ORIG
RUN echo "desktop" > /etc/hostname

COPY entrypoint.sh /opt/
COPY config/pcmanfm /home/$username/.config/pcmanfm
COPY vnc/xstartup /home/$username/.vnc/
COPY wallpaper.jpg /usr/share/lxde/wallpapers/

COPY home/user/.config/lxterminal/lxterminal.conf /home/$username/.config/lxterminal/lxterminal.conf

CMD /opt/entrypoint.sh

