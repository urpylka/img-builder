#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

echo "> Writing update-network.sh to /etc/rc.local"
SCRIPT="sudo /root/update-network.sh"
sed -i "20a${SCRIPT}" /etc/rc.local

cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig

systemctl disable hostapd
systemctl disable dnsmasq
systemctl enable openvpn

usermod -aG docker pi

echo "> Setting to deny byobu to check available updates"
sed -i "s/updates_available//" /usr/share/byobu/status/status
# sed -i "s/updates_available//" /home/pi/.byobu/status

echo "> Setting the max space for syslogs"
# https://unix.stackexchange.com/questions/139513/how-to-clear-journalctl
sed -i 's/#SystemMaxUse=/SystemMaxUse=200M/' /etc/systemd/journald.conf

echo "> Changing default keyboard layout to US"
sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT="us"/g' /etc/default/keyboard

# https://pip.pypa.io/en/stable/installing/

# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
# 	LANGUAGE = (unset),
# 	LC_ALL = (unset),
# 	LC_CTYPE = "UTF-8",
# 	LANG = "en_GB.UTF-8"
#     are supported and installed on your system.
# perl: warning: Falling back to a fallback locale ("en_GB.UTF-8").
# locale: Cannot set LC_CTYPE to default locale: No such file or directory
# locale: Cannot set LC_ALL to default locale: No such file or directory

# https://stackoverflow.com/questions/11300633/svn-cannot-set-lc-ctype-locale
# https://rtfm.co.ua/linux-cannot-set-lc_ctype-to-default-locale-no-such-file-or-directory/
# https://proadminz.ru/ispravlenie-oshibok-locale-cannot-set/

# echo "> Setting LC_CTYPE and LC_ALL"
# cat << EOF >> /home/pi/.bashrc
# export LANG='C.UTF-8'
# export LC_ALL='C.UTF-8'
# EOF

sed -i 's/en_GB.UTF-8 UTF-8/#en_GB.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

echo "> Setting a short aliases"
cat << EOF >> /home/pi/.bashrc
alias status='sudo systemctl status'
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias enable='sudo systemctl enable'
alias disable='sudo systemctl disable'
alias reload='sudo systemctl daemon-reload'
alias log='sudo journalctl -fu'
alias dc='docker-compose'
alias d='docker'
EOF
