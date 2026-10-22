# 2026-10-22 by RouterOS 7.21.5
# system id = /ZzKcTaVcHI
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/routing bgp instance
add as=65000 name=bgp-edge router-id=10.255.0.1
/routing ospf instance
add name=default-v2 originate-default=always router-id=10.255.0.1
/routing ospf area
add instance=default-v2 name=backbone
/ip address
add address=192.0.2.2/30 comment=to-ISP-1 interface=ether1 network=192.0.2.0
add address=192.0.2.6/30 comment=to-ISP-2 interface=ether2 network=192.0.2.4
add address=10.0.0.1/30 comment=to-CORE-1 interface=ether3 network=10.0.0.0
add address=10.0.0.5/30 comment=to-CORE-2 interface=ether4 network=10.0.0.4
add address=10.255.0.1 interface=lo network=10.255.0.1
/ip firewall filter
add action=accept chain=input comment="Accept Est/Rel" connection-state=established,related
add action=accept chain=input comment="Accept BGP" dst-port=179 protocol=tcp
add action=accept chain=input comment="Accept OSPF" protocol=ospf
add action=accept chain=input comment="Accept ICMP para pruebas" protocol=icmp
add action=accept chain=input comment="SSH Mgmt loopbacks" dst-port=22 protocol=tcp src-address=10.255.0.0/24
add action=accept chain=input comment="SSH desde SRV" dst-port=22 protocol=tcp src-address=192.168.20.100
add action=drop chain=input comment="Drop resto de input"
add action=accept chain=forward comment="Accept Est/Rel Forward" connection-state=established,related
add action=drop chain=forward comment="Anti-spoofing ISP1" in-interface=ether1 src-address=10.0.0.0/8
add action=drop chain=forward comment="Anti-spoofing ISP1" in-interface=ether1 src-address=192.168.0.0/16
add action=drop chain=forward comment="Anti-spoofing ISP2" in-interface=ether2 src-address=10.0.0.0/8
add action=drop chain=forward comment="Anti-spoofing ISP2" in-interface=ether2 src-address=192.168.0.0/16
add action=accept chain=forward comment="Permitir salida a Internet (ISP-1)" out-interface=ether1
add action=accept chain=forward comment="Permitir salida a Internet (ISP-2)" out-interface=ether2
/ip service
set ftp disabled=yes
set ssh address=10.255.0.0/24,192.168.20.100/32
set telnet disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/routing bgp connection
add instance=bgp-edge local.address=192.0.2.2 .role=ebgp name=to-ISP1 output.redistribute=ospf remote.address=\
    192.0.2.1 .as=65001
add instance=bgp-edge local.address=192.0.2.6 .role=ebgp name=to-ISP2 output.redistribute=ospf remote.address=\
    192.0.2.5 .as=65002
/routing ospf interface-template
add area=backbone auth=md5 auth-id=1 interfaces=ether3,ether4 type=ptp
/system identity
set name=EDGE