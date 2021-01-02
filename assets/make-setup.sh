#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result



systemctl enable openvpn

# systemctl enable openvpn-client@<name>
# where <name>.conf in /etc/openvpn/client

echo "> Setting to deny byobu to check available updates"
sed -i "s/updates_available//" /usr/share/byobu/status/status
# sed -i "s/updates_available//" /home/pi/.byobu/status

echo "> Setting the max space for syslogs"
# https://unix.stackexchange.com/questions/139513/how-to-clear-journalctl
sed -i 's/#SystemMaxUse=/SystemMaxUse=200M/' /etc/systemd/journald.conf

echo "> Changing default keyboard layout to US"
sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT="us"/g' /etc/default/keyboard

echo "> Setting a short aliases"
cat << EOF >> /home/pi/.bashrc
alias status='sudo systemctl status'
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias enable='sudo systemctl enable'
alias disable='sudo systemctl disable'
alias reload='sudo systemctl reload'
alias log='sudo journalctl -fu'
alias dc='docker-compose'
alias d='docker'
EOF
