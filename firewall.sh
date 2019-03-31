#!/bin/bash

# Configuração de Firewall do Servidor

interface=enp2s0f5
servidor=ip -4 addr show enp2s0f5 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
cliente=192.168.1.x
range=192.168.1.x-192.168.1.x

echo ""
echo "Configuração Firewall"
echo ""
#============= REMOVE CONFIGURAÇÕES ANITGAS =============#

iptables -F
iptables -X
echo "Configurações Antigas Removidas"

#========================================================#

#============= PERMITE LOOPBACK =============#

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
echo "Permissão Loopback"

#============================================#

#============= PERMITE SHH =============#

iptables -A INPUT -i  $interface -p tcp --dport 22 -s $cliente -d $servidor -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o  $interface -p tcp --sport 22 -d $cliente -s $servidor -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
echo "SSH Configurado"

#=======================================#

#============= PERMITE NETBIOS-SAMBA =============#


iptables -A INPUT -i  $interface  -p udp -m iprange --src-range $range --dport 137 -j ACCEPT
iptables -A INPUT -i  $interface  -p udp -m iprange --src-range $range --dport 138 -j ACCEPT
iptables -A INPUT -i  $interface  -p tcp -m iprange --src-range $range --dport 139 -j ACCEPT
iptables -A INPUT -i  $interface  -p tcp -m iprange --src-range $range --dport 445 -j ACCEPT
iptables -A INPUT -i  $interface  -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o  $interface  -p udp -m iprange --dst-range $range --dport 137 -j ACCEPT
iptables -A OUTPUT -o  $interface  -p udp -m iprange --dst-range $range --dport 138 -j ACCEPT
iptables -A OUTPUT -o  $interface  -p tcp -m iprange --dst-range $range --dport 139 -j ACCEPT
iptables -A OUTPUT -o  $interface  -p tcp -m iprange --dst-range $range -j ACCEPT
iptables -A OUTPUT -o  $interface  -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "Permissão Samba"

#=================================================#

#============= PING EXTERNO-INTERNO ==============#

iptables -A INPUT -i  $interface -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -o  $interface -p icmp --icmp-type echo-reply -j ACCEPT
echo "Permissão PING-EXTERNO-INTERNO"

#=================================================#


#============= PING INTERNO-EXTERNO ==============#

iptables -A OUTPUT -o  $interface -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -i  $interface -p icmp --icmp-type echo-reply -j ACCEPT
echo "Permissão PING-INTERNO-EXTERNO"

#=================================================#

#============= LOG-INPUT-DROPPED ==============#

iptables -N LOGGING-INPUT
iptables -A INPUT -j LOGGING-INPUT
iptables -A LOGGING-INPUT -m limit --limit 2/min -j LOG --log-prefix "*** INPUT-Dropped: ***" --log-level 4
iptables -A LOGGING-INPUT -j DROP
echo "LOG-INPUT-DROPPED"

#==============================================#

#============= LOG-OUTPUT-DROPPED ==============#

iptables -N LOGGING-OUTPUT
iptables -A INPUT -j LOGGING-OUTPUT
iptables -A LOGGING-OUTPUT -m limit --limit 2/min -j LOG --log-prefix "*** OUTPUT-Dropped: ***" --log-level 4
iptables -A LOGGING-OUTPUT -j DROP
echo "LOG-OUTPUT-DROPPED"

#===============================================#

#============= LOG-GERAL ==============#

iptables -A INPUT -m limit --limit 2/min -j LOG --log-prefix "* INPUT-Accepted: *" --log-level 4
iptables -A OUTPUT -m limit --limit 2/min -j LOG --log-prefix "* OUTPUT-Accepted: *" --log-level 4
echo "LOG-GERAL"

#======================================#

#============= BLOQUEIA O RESTO ================#

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
echo "BLOQUEIA RESTO"

#===============================================#

echo "* FIM CONFIGURAÇÃO FIREWALL *"
echo ""
