# Initialization of the image

After you build the image, you need to configure the image before run at device:

1. Setup configuration of your Wi-Fi network at `/boot/img-builder/wpa_supplicant.conf`
2. Setup OpenVPN configuration at `/boot/img-builder/theimage.ovpn`

Also you can modify `/boot/img-builder/interfaces.conf` it will replace `/etc/network/interfaces`.

You can change this files whenever you want: it will be used after reboot. Script who do that is runned by `rc.local`.
