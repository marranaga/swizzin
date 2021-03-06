#!/bin/bash
#
# Quassel Installer
#
# Originally written for QuickBox.io. Ported to Swizzin
# Author: liara
#
# QuickBox Copyright (C) 2016
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

function _installQuassel1() {
if [[ $distribution == Ubuntu ]]; then
  apt-get install -q -y software-properties-common > /dev/null 2>&1
	apt-add-repository ppa:mamarley/quassel -y >/dev/null 2>&1
	apt-get -qq -y --force-yes update >/dev/null 2>&1
  apt-get -q -y install quassel-core >/dev/null 2>&1
	mv /etc/init.d/quasselcore /etc/init.d/quasselcore.BAK
	systemctl enable quasselcore >/dev/null 2>&1
	systemctl start quasselcore >/dev/null 2>&1
  touch /install/.quassel.lock
else
  wget -r -l1 --no-parent --no-directories -A "quassel-core*.deb" https://iskrembilen.com/quassel-packages-debian/ >/dev/null 2>&1
  dpkg -i quassel-core* >/dev/null 2>&1
  rm quassel-core*
  apt-get install -f -y -q >/dev/null 2>&1
	mv /etc/init.d/quasselcore /etc/init.d/quasselcore.BAK
	systemctl enable quasselcore >/dev/null 2>&1
	systemctl start quasselcore >/dev/null 2>&1
  touch /install/.quassel.lock
fi
}


function _installQuassel2() {
  exit
}

if [[ -f /tmp/.install.lock ]]; then
  OUTTO="/root/logs/install.log"
elif [[ -f /install/.panel.lock ]]; then
  OUTTO="/srv/panel/db/output.log"
else
  OUTTO="/dev/null"
fi
distribution=$(lsb_release -is)
IP=$(ip route get 8.8.8.8 | awk '{printf $7}')
MASTER=$(cat /root/.master.info | cut -d: -f1)

echo "Installing Quassel PPA (Ubuntu) or grabbing latest backport (Debian) ... " >>"${OUTTO}" 2>&1;_installQuassel1;echo
echo "Quassel has now been installed! "
echo "Please install quassel-client on your personal computer "
echo "and connect to the newly created core at "
echo "${IP}:4242 to set up your account" >>"${OUTTO}" 2>&1;_installQuassel2
