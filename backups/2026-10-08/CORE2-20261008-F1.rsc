# 2026-10-08 19:56:07 by RouterOS 7.21.5
# system id = osHzneTmGNJ
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip address
add address=10.255.0.12 interface=lo network=10.255.0.12
add address=10.0.0.6/30 comment=to-EDGE interface=ether1 network=10.0.0.4
add address=10.0.0.10/30 comment=to-CORE-1 interface=ether2 network=10.0.0.8
add address=10.0.0.21/30 comment=to-DIST-1 interface=ether3 network=10.0.0.20
add address=10.0.0.25/30 comment=to-DIST-2 interface=ether4 network=10.0.0.24
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
set name=CORE-2