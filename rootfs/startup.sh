#!/bin/bash

vncserver :1 -geometry 1280x800 -depth 24 && tail -F ${HOME}/.vnc/*.log
websockify -D --web=/usr/share/novnc/ --cert=/home/ubuntu/novnc.pem 6080 localhost:5901

USER=user
PASSWORD=user

### added nglab
#echo "* start ssh daemon"
#/etc/init.d/ssh start
### end added

#if [ -n "$VNC_PASSWORD" ]; then
    #echo -n "$VNC_PASSWORD" > /.password1
    #x11vnc -storepasswd $(cat /.password1) /.password2
    #chmod 400 /.password*
    #sed -i 's/^command=x11vnc.*/& -rfbauth \/.password2/' /etc/supervisor/conf.d/supervisord.conf
    #export VNC_PASSWORD=
#fi

#if [ -n "$X11VNC_ARGS" ]; then
    #sed -i "s/^command=x11vnc.*/& ${X11VNC_ARGS}/" /etc/supervisor/conf.d/supervisord.conf
#fi

#if [ -n "$OPENBOX_ARGS" ]; then
    #sed -i "s#^command=/usr/bin/openbox\$#& ${OPENBOX_ARGS}#" /etc/supervisor/conf.d/supervisord.conf
#fi

#if [ -n "$RESOLUTION" ]; then
    #sed -i "s/1024x768/$RESOLUTION/" /usr/local/bin/xvfb.sh
#fi

echo "* create custom user: $USER"
useradd --create-home --shell /bin/bash --user-group --groups adm,sudo $USER
echo "$USER:$PASSWORD" | chpasswd
su $USER "touch /home/$USER/.Xauthority; xauth generate :0 . trusted; xauth add ${HOST}:0 . $(xxd -l 16 -p /dev/urandom)"
# su $USER xauth list

echo "create certificate"
openssl req -x509 -nodes -newkey rsa:3072 -keyout novnc.pem -out novnc.pem -days 3650 \
	-subj "/C=IT/L=Trento/O=Università di Pisa/OU=Dipartimento di Informatica/CN=Augusto Ciuffoletti"

echo "* record vnc password"
mkdir /home/$USER/.vnc
echo $PASSWORD | vncpasswd -f > /home/$USER/.vnc/passwd
chown -R $USER:$USER /home/$USER/.vnc
chmod 0600 /home/$USER/.vnc/passwd

echo "* start vnc server"
tigervncserver $USER -xstartup /usr/bin/openbox -geometry 800x600 -localhost no :1

websockify -D --web=/usr/share/novnc/ --cert=/home/ubuntu/novnc.pem 6080 localhost:5901

while true; do sleep 1000; done



#sed -i -e "s|%USER%|$USER|" -e "s|%HOME%|$HOME|" /etc/supervisor/conf.d/supervisord.conf

#### added nglab
#echo "* enable Wireshark capture from user $USER"
#groupadd -r wireshark
#usermod -a -G wireshark $USER
#chgrp wireshark /usr/bin/dumpcap
#chmod 4754 /usr/bin/dumpcap
#### end added

## home folder
#if [ ! -x "$HOME/.config/pcmanfm/LXDE/" ]; then
    #mkdir -p $HOME/.config/pcmanfm/LXDE/
    #ln -sf /usr/local/share/doro-lxde-wallpapers/desktop-items-0.conf $HOME/.config/pcmanfm/LXDE/
    #chown -R $USER:$USER $HOME
#fi

## clearup
#PASSWORD=
#HTTP_PASSWORD=

#exec /bin/tini -- supervisord -n -c /etc/supervisor/supervisord.conf
