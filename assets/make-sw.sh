#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

# https://gist.github.com/letmaik/caa0f6cc4375cbfcc1ff26bd4530c2a3
# https://github.com/travis-ci/travis-build/blob/master/lib/travis/build/templates/header.sh
my_travis_retry() {
  local result=0
  local count=1
  while [ $count -le 3 ]; do
    [ $result -ne 0 ] && {
      echo -e "\n${ANSI_RED}The command \"$@\" failed. Retrying, $count of 3.${ANSI_RESET}\n" >&2
    }
    # ! { } ignores set -e, see https://stackoverflow.com/a/4073372
    ! { "$@"; result=$?; }
    [ $result -eq 0 ] && break
    count=$(($count + 1))
    sleep 1
  done

  [ $count -gt 3 ] && {
    echo -e "\n${ANSI_RED}The command \"$@\" failed 3 times.${ANSI_RESET}\n" >&2
  }

  return $result
}

echo "Software installing"
apt-get install --no-install-recommends -y \
unzip zip \
python3 python3-dev ipython3 \
screen byobu tmux \
nmap \
git vim \
tcpdump ltrace lsof \
cmake \
libpoco-dev \
build-essential \
ntpdate \
python3-opencv python3-systemd \
i2c-tools \
pigpio python-pigpio python3-pigpio \
espeak espeak-data python-espeak \
&& echo "Everything was installed!" \
|| (echo "Some packages wasn't installed!"; exit 1)

# mjpg-streamer \

# Deny byobu to check available updates
sed -i "s/updates_available//" /usr/share/byobu/status/status
# sed -i "s/updates_available//" /home/pi/.byobu/status

echo "Installing pip"
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
rm get-pip.py

echo "Make sure both pip and pip3 are installed"
pip3 --version

# echo "Install and enable Butterfly (web terminal)"
# echo "Workaround for tornado >= 6.0 breaking butterfly"
# my_travis_retry pip3 install tornado==5.1.1
# my_travis_retry pip3 install butterfly
# my_travis_retry pip3 install butterfly[systemd]
# systemctl enable butterfly.socket
