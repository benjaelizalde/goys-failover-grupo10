# 2026-10-22 by RouterOS 7.21.5
# system id = g/rcEjehrwH
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/routing bgp instance
add as=65001 name=bgp-isp1 router-id=198.51.100.1
/ip neighbor discovery-settings
set discover-interface-list=none
/ip address
add address=198.51.100.1 interface=lo network=198.51.100.1
add address=192.0.2.1/30 interface=ether1 network=192.0.2.0
/ip firewall address-list
add address=198.51.100.1 list=bgp-networks
/ip service
set ftp disabled=yes
set ssh address=192.0.2.2/32
set telnet disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/routing bgp connection
add instance=bgp-isp1 local.address=192.0.2.1 .role=ebgp name=to-EDGE output.default-originate=always .network=\
    bgp-networks remote.address=192.0.2.2 .as=65000
/system identity
set name=ISP-1