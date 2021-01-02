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

## Other

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
