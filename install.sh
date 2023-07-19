#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
package="curl wget software-properties-common git nano htop mc lshw zip unzip dialog sudo"

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  NOTICE: PGBlitz Version X - Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
By installing, you agreeing to the terms and conditions of the GNUv3 License!
Thanks To: You, the Linux Noobs, Sponsors, Supporters, Community & You!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please Standby!
EOF
#sleep 4

# Delete If it Exist for Cloning
if [ -e "/pg/blitz" ]; then rm -rf /pg/blitz; fi
if [ -e "/pg/stage" ]; then rm -rf /pg/stage; fi
rm -rf /pg/stage/place.holder 1>/dev/null 2>&1

# Make Critical Folders
mkdir -p /pg /pg/logs /pg/data /pg/stage /pg/logs /pg/tmp /pg/var/install
chmod 775 /pg /pg/logs /pg/data /pg/stage /pg/logs /pg/tmp /pg/var/install
chown 1000:1000 /pg /pg/logs /pg/data /pg/stage /pg/logs /pg/tmp /pg/var/install
rm -rf /pg/var/first.update 1>/dev/null 2>&1

# Clone the Program to Stage for Installation
git clone -b v10 --single-branch https://github.com/titooo7/Stage.git /pg/stage

# Checking to See if the Installer ever Installed Python; if so... skip
var37="/pg/var/python.firstime"
if [ ! -e "${var37}" ]; then
  bash /pg/stage/pyansible.sh
  touch /pg/var/python.firstime
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Executing a Base Install - Please Standby
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
apt-get install lsb-release -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get install software-properties-common -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Updating the Server - Please Standby (Can Take 1-2 Minutes)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

fullrel=$(lsb_release -sd)
osname=$(lsb_release -si)
relno=$(lsb_release -sr)
relno=$(printf "%.0f\n" "$relno")
hostname=$(hostname -I | awk '{print $1}')
# add repo

if echo $osname "Debian" &>/dev/null; then
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository non-free 2>&1 >> /dev/null
	add-apt-repository contrib 2>&1 >> /dev/null
elif echo $osname "Ubuntu" &>/dev/null; then
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository universe 2>&1 >> /dev/null
	add-apt-repository restricted 2>&1 >> /dev/null
	add-apt-repository multiverse 2>&1 >> /dev/null
elif echo $osname "Rasbian" "Fedora" "CentOS"; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ System Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Supported: UB 18.04/20.04 ~ LTS/SERVER and Debian 9+
This server may not be supported due to having the incorrect OS detected!

For more information, read:
https://pgblitz.com/threads/pg-install-instructions.243/
EOF
  sleep 10
fi

apt-get update -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get upgrade -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get dist-upgrade -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get autoremove -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get install $package -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Finished - Basic Updates
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

ansible-playbook /pg/stage/clone.yml
bash /pg/stage/pgcloner/solo/update.sh

# Copy Starting Commands for PGBlitz
path="/pg/stage/alias"
cp -t /bin $path/plexguide $path/pg $path/pgblitz

# Verifying the Commands Installed
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Verifiying Started Commands Installed via @ /bin
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Installation fails if the pgblitz command is not in the correct location
file="/bin/pgblitz"
if [ ! -e "$file" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! The PGBlitz Installer Failed ~ http://pgblitz.wiki
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please Reinstall PGBlitz by running the Command Again! This step is to
ensure that everything is working prior to the install!
Ensure that you utilizing the correct versions of linux as described on
the installation page!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EXITING!!!
EOF
exit
fi

# If nothing failed, notify the user that installation passed!
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASSED! The PGBlitz Command Installed! ~ http://pgblitz.wiki
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# creates a blank var; if this executes; pgblitz will go through the install process
touch /pg/var/new.install

chmod 775 /bin/plexguide /bin/pgblitz /bin/pg
chown 1000:1000 /bin/plexguide /bin/pgblitz /bin/pg

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> pgblitz [or] plexguide [or] pg
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
