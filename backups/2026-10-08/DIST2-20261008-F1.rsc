# 2026-10-08 19:56:36 by RouterOS 7.21.5
# system id = wC/AbFOPeZB
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip address
add address=10.255.0.22 interface=lo network=10.255.0.22
add address=10.0.0.18/30 comment=to-CORE-1 interface=ether1 network=10.0.0.16
add address=10.0.0.26/30 comment=to-CORE-2 interface=ether2 network=10.0.0.24
add address=192.168.10.3/24 comment=LAN-USERS interface=ether3 network=192.168.10.0
add address=192.168.20.3/24 comment=LAN-SERVERS interface=ether4 network=192.168.20.0
/ip dhcp-client
add interface=ether1
/ip service
set ftp disabled=yes
set ssh address=10.255.0.0/24,192.168.20.100/32
set telnet disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=DIST-2