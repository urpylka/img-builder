# Network

Image's network based on `networking` service. It uses `ifup`, `ifdown` utilites. File `/etc/network/interfaces.d/redirect` has the string to use configs from `/boot/img-builder/interfaces.d`. All files without extensions will be used by `networking` service.

There are two pre-configurations of network `/boot/img-builder/interfaces.d/router` and `/boot/img-builder/interfaces.d/client.uncommentme`.

Default network is setup as router.

## Router

`wlan0` and `eth0` is combined by bridge-utils to `br0`.

And if you connect USB external network card or cell modem `eth1` will nated to `br0`.

> dhcp client works on `eth1`.

There is `dnsmasq`. It works in `br0` network.

The network has `192.168.11.0/24` addressing with `192.168.11.1` gateway. Also you can use domain name that equals the project name (by default `theimage`).

There is `hostapd`. It provide Wi-Fi AP. It's called `project-1234`.

Settings place in three files:

1. `/boot/img-builder/dnsmasq.conf` (temporary isn't used)
2. `/boot/img-builder/hostapd.conf`
3. `/boot/img-builder/interfaces.d/`

## Client

To use client version you need to comment router-config file and uncomment client-config. After that you need to change `/boot/img-builder/wpa_supplicant.conf` (setup one or more Wi-Fi networks used to connect to them).

### wpa_supplicant

Earlier there was used `wpa_supplicant` as Wi-Fi access point.

```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
# systemctl status wifi-country
country=US

network={
    ssid="Access point"
    psk="password"
    mode=2
    proto=WPA RSN
    key_mgmt=WPA-PSK
    pairwise=CCMP
    group=CCMP
    auth_alg=OPEN
}
```

But it was deprecated, beacuse it isn't correct way to use `wpa_supplicant`. Also there was used `dhcpcd` as network manager.

> More about parameters of wpa_supplicant here:
>
> * [habr.com](https://habr.com/ru/post/315960/)
> * [gist/penguinpowernz](https://gist.github.com/penguinpowernz/ce4ed0e64ce0fa99a5e335c1a4c954b3)
> * [centos.name](https://centos.name/?page/howto/Laptops/WpaSupplicant)
