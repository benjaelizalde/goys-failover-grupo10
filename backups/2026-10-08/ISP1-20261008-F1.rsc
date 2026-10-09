# 2026-10-08 19:43:13 by RouterOS 7.21.5
# system id = g/rcEjehrwH
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip neighbor discovery-settings
set discover-interface-list=none
/ip address
add address=198.51.100.1 interface=lo network=198.51.100.1
add address=192.0.2.1/30 interface=ether1 network=192.0.2.0
/ip dhcp-client
# Interface not active
add interface=ether4
/ip service
set ftp disabled=yes
set ssh address=192.0.2.2/32
set telnet disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=ISP-1