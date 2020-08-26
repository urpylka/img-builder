# enable IP-forwarding
sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'

# for LAN
#iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
#iptables -A FORWARD -i eth1 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# for WLAN
#iptables -A FORWARD -i wlan0 -o eth1 -j ACCEPT
#iptables -A FORWARD -i eth1 -o wlan0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# allow traffic between LAN and WLAN
#iptables -A FORWARD -i wlan0 -o eth1 -j ACCEPT
#iptables -A FORWARD -i eth1 -o wlan0 -j ACCEPT

iptables -A FORWARD -i br0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o br0 -j ACCEPT

iptables -A POSTROUTING -o eth1 -t nat -j MASQUERADE

#iptables -L -n -v

#sh -c "iptables-save" > /etc/iptables.ipv4.nat

#iptables-restore < /etc/iptables.ipv4.nat
