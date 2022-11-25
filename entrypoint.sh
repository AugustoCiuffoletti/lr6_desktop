#!/bin/bash
VNCPASSWD="user"
USER="user"

chown --recursive ${USER}:${USER} /home/${USER}

echo "* enable Wireshark capture from user $USER"
groupadd -r wireshark
usermod -a -G wireshark $USER
chgrp wireshark /usr/bin/dumpcap
chmod 4754 /usr/bin/dumpcap

echo "* start ssh daemon"
/etc/init.d/ssh start

echo "* create user keys"
sudo -u ${USER} ssh-keygen -b 2048 -t rsa -f /home/${USER}/.ssh/id_rsa -q -N ""

echo "* start vnc server"
sudo -i -H -u ${USER} bash << EOF
echo $VNCPASSWD | vncpasswd -f > /home/user/.vnc/passwd
chmod go-rwx /home/user/.vnc/passwd
vncserver :1 -SecurityTypes None -geometry 1600x900 -depth 24
tail -F /home/user/.vnc/*.log &
EOF

echo "* start vnc web proxy"
websockify --web=/usr/share/novnc/ 6080 localhost:5901
