# 2026-10-08 19:55:11 by RouterOS 7.21.5
# system id = 7cXzajnemaA
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip neighbor discovery-settings
set discover-interface-list=none
/ip address
add address=198.51.100.2 interface=lo network=198.51.100.2
add address=192.0.2.5/30 interface=ether1 network=192.0.2.4
/ip dhcp-client
add interface=ether1
/ip service
set ftp disabled=yes
set ssh address=192.0.2.6/32
set telnet disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=ISP-2