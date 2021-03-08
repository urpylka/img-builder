# Initialization of the image

After you build the image, you need to configure the image before run at device:

1. Select one of network configuration in `/boot/img-builder/interfaces.d/` (see more in [Network](/docs/network.md));
2. Setup configuration of your Wi-Fi network at `/boot/img-builder/wpa_supplicant.conf` (only for Wi-Fi client);
3. Setup OpenVPN configuration at `/boot/img-builder/openvpn.ovpn` (it will work only if you update this file).
