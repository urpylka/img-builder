#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

# clever image version
echo "$1" >> /etc/clever_version
# Origin image file name
echo "${2%.*}" >> /etc/clever_origin

echo "Writing magic script to /etc/rc.local"
MAGIC_SCRIPT="sudo /root/make-once.sh; sudo sed -i '/sudo \\\/root\\\/make-once.sh/d' /etc/rc.local && sudo reboot"
sed -i "19a${MAGIC_SCRIPT}" /etc/rc.local

echo "Set max space for syslogs"
# https://unix.stackexchange.com/questions/139513/how-to-clear-journalctl
sed -i 's/#SystemMaxUse=/SystemMaxUse=200M/' /etc/systemd/journald.conf

echo "Install apt keys & repos"

# TODO: This STDOUT consist 'OK'
curl http://repo.smirart.ru/aptly_repo_signing.key 2> /dev/null | apt-key add -
apt-get update \
&& apt-get install --no-install-recommends -y dirmngr > /dev/null
# && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Used apt-get because apt does not have a stable CLI interface.

# echo "deb http://packages.ros.org/ros/ubuntu buster main" > /etc/apt/sources.list.d/ros-latest.list
# echo "deb http://repo.smirart.ru/clever buster main" > /etc/apt/sources.list.d/opencv3.list

echo "Update apt cache"
# TODO: FIX ERROR: /usr/bin/apt-key: cannot create /dev/null: Permission denied
apt-get update
# && apt upgrade -y

# echo "Attempting to kill dirmngr"
# gpgconf --kill dirmngr
# # dirmngr is only used by apt-key, so we can safely kill it.
# # We ignore pkill's exit value as well.
# pkill -9 -f dirmngr || true

echo "Change default keyboard layout to US"
sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT="us"/g' /etc/default/keyboard

cat << EOF >> /home/pi/.bashrc
alias status='sudo systemctl status'
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart'sudo systemctl restart'
alias enable='sudo systemctl enable'
alias disable='sudo systemctl disable'
alias reload='sudo systemctl reload'
alias log='sudo journalctl -fu'
alias dc='docker-compose '
alias d='docker '
EOF

# мб добавить поддержку других синтаксисов
echo "Add .vimrc"
cat << EOF > /home/pi/.vimrc
set mouse-=a
syntax on
autocmd BufNewFile,BufRead *.launch set syntax=xml
EOF
