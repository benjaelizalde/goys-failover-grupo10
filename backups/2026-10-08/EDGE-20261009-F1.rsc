# 2026-10-09 11:50:16 by RouterOS 7.21.5
# system id = /ZzKcTaVcHI
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip address
add address=192.0.2.2/30 comment=to-ISP-1 interface=ether1 network=192.0.2.0
add address=192.0.2.6/30 comment=to-ISP-2 interface=ether2 network=192.0.2.4
add address=10.0.0.1/30 comment=to-CORE-1 interface=ether3 network=10.0.0.0
add address=10.0.0.5/30 comment=to-CORE-2 interface=ether4 network=10.0.0.4
add address=10.255.0.1 interface=lo network=10.255.0.1
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
set name=EDGE