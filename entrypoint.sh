#!/bin/bash
VNCPASSWD="user"
USER="user"

echo "* enable Wireshark capture from user $USER"
groupadd -r wireshark
usermod -a -G wireshark $USER
chgrp wireshark /usr/bin/dumpcap
chmod 4754 /usr/bin/dumpcap

echo "* start ssh daemon"
/etc/init.d/ssh start

echo "* start vnc server"
sudo -i -H -u user bash << EOF
echo $VNCPASSWD | vncpasswd -f > /home/user/.vnc/passwd
chmod go-rwx /home/user/.vnc/passwd
vncserver :1 -SecurityTypes None -geometry 1600x900 -depth 24
tail -F /home/user/.vnc/*.log &
EOF

echo "* start vnc web proxy"
websockify --web=/usr/share/novnc/ 6080 localhost:5901

#su $USER "touch /home/$USER/.Xauthority; xauth generate :0 . trusted; xauth add ${HOST}:0 . $(xxd -l 16 -p /dev/urandom)"
# su $USER xauth list

#echo "create certificate"
#openssl req -x509 -nodes -newkey rsa:3072 -keyout novnc.pem -out novnc.pem -days 3650 \
#	-subj "/C=IT/L=Trento/O=Università di Pisa/OU=Dipartimento di Informatica/CN=Augusto Ciuffoletti"

#echo "* start vnc server"
#tigervncserver $USER -xstartup /usr/bin/openbox -geometry 800x600 -localhost no :1
#websockify -D --web=/usr/share/novnc/ --cert=/home/ubuntu/novnc.pem 6080 localhost:5901


#### added nglab
#
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
