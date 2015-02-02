#!/bin/bash

#Clear existing rules
iptables -F
iptables -X

#Set the default policies to DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

#User defined chains to keep track of www, shh
iptables -N sshIn
iptables -N sshOut
iptables -N wwwIn
iptables -N wwwOut

#Drop inbound traffic to port (http) from source ports less than 1024
iptables -A INPUT -p tcp --dport 80 --sport 0:1023 -j DROP
#iptables -A OUTPUT -p tcp --sport 80 --dport 0:1023 -j DROP
#iptables -A INPUT -p tcp --dport 80 ! --sport 0:1023 -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 80 ! --dport 0:1023 -j ACCEPT

#Drop all incoming packets from reserved port 0
iptables -A INPUT -p tcp --sport 0 -j DROP
iptables -A INPUT -p udp --sport 0 -j DROP
iptables -A OUTPUT -p tcp --dport 0 -j DROP
iptables -A OUTPUT -p udp --dport 0 -j DROP

#Allow DHCP on all adapters
iptables -A INPUT -p udp --sport 67:68 --dport 67:68 -j ACCEPT
#iptables -A OUTPUT -p udp --sport 67:68 --dport 67:68 -j ACCEPT

#Allow DNS on all adapters
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A INPUT -p tcp --sport 53 -j ACCEPT

#send inbound/outbound ssh chains
iptables -A INPUT -p tcp --dport 22 -j sshIn
iptables -A OUTPUT -p tcp --dport 22 -j sshOut
iptables -A INPUT -p tcp --sport 22 -j sshIn
iptables -A OUTPUT -p tcp --sport 22 -j sshOut

#Aman live demo
#iptables -A INPUT -p tcp --dport 2 -j ACCEPT		
#iptables -A OUTPUT -p tcp --dport 2 -j ACCEPT
#iptables -A INPUT -p tcp --sport 2 -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 2 -j ACCEPT

#Permit inbound/outbound ssh packets
iptables -A sshIn -p tcp --dport 22 -j ACCEPT
iptables -A sshOut -p tcp --dport 22 -j ACCEPT
iptables -A sshIn -p tcp --sport 22 -j ACCEPT
iptables -A sshOut -p tcp --sport 22 -j ACCEPT

#Send inbound/outbound https chains
iptables -A INPUT -p tcp --sport 443 -j wwwIn
iptables -A OUTPUT -p tcp --dport 443 -j wwwOut
iptables -A INPUT -p tcp --dport 443 -j wwwIn
iptables -A OUTPUT -p tcp --sport 443 -j wwwOut

#Permit inbound/outbound https packets
iptables -A wwwIn -p tcp --dport 443 -j ACCEPT
iptables -A wwwOut -p tcp --sport 443 -j ACCEPT
iptables -A wwwIn -p tcp --sport 443 -j ACCEPT
iptables -A wwwOut -p tcp --dport 443 -j ACCEPT

#Send inbound/outbound www chains
iptables -A INPUT -p tcp --sport 80 -j wwwIn
iptables -A OUTPUT -p tcp --dport 80 -j wwwOut
iptables -A INPUT -p tcp --dport 80 -j wwwIn
iptables -A OUTPUT -p tcp --sport 80 -j wwwOut

#Permit inbound/outbound www packets
iptables -A wwwIn -p tcp --sport 80 -j ACCEPT
iptables -A wwwOut -p tcp --dport 80 -j ACCEPT
iptables -A wwwIn -p tcp --dport 80 -j ACCEPT
iptables -A wwwOut -p tcp --sport 80 -j ACCEPT



