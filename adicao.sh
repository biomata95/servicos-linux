#!/bin/bash

# Permite que uma máquina acesse o servidor via SSH

host=$1
servidor=192.168.1.6
interface=enp2s0f5

echo ""
echo "Adicionar máquina para acessar via SSH"
echo ""

#============= PERMITE SHH =============#

iptables -I INPUT 1 -i  $interface -p tcp --dport 22 -s $host -d $servidor -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I OUTPUT 1 -o  $interface -p tcp --sport 22 -d $host -s $servidor -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
echo "Máquina $host Adicionada"
echo ""

#=======================================#
