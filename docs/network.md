# Network

Default network is setup as router.

`wlan0` and `eth0` is combined by bridge-utils to `br0`.

And if you connect USB external network card or cell modem `eth1` will nated to `br0`.

> dhcp client works on `eth1`.

There is `dnsmasq`. It works in `br0` network.

The network has `192.168.11.0/24` addressing with `192.168.11.1` gateway. Also you can use domain name that equals the project name (by default `theimage`).

There is `hostapd`. It provide Wi-Fi AP. It's called `project-1234`.

Settings place in three files:

1. `/etc/dnsmasq.conf`
2. `/etc/hostapd/hostapd.conf`
3. `/etc/network/interfaces`
