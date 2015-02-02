#!/bin/bash

#Clear all filters
echo "Flushing all policies"
iptables -F
iptables -X

#Set all rules to allow everything(default)
echo "Setting default policy to ALLOW"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
