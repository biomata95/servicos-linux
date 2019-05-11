function nome(){
	ip=$1
	username=$(smbstatus -p | grep $ip | awk '{print $2}')
	echo "$username"
}

function imprime_informacoes(){
                echo "Usuário:" $2
                echo "IP:" $3
                echo "Hostname:" $4
                echo "-----------------------------------------"
                echo " "
}

function resolucao_hostname(){
	opcao=$1
	hostname=$2
	for ip in $(smbstatus -p | tail -n +5 |awk '{print $4}'); do
	        usuario=$(nome $ip)
	        hostname_encontrado=$(nmblookup -A $ip | sed -n 2p | awk '{print $1}')
		if [ "$opcao" == "-s" ] && [ "$hostname" == "$hostname_encontrado" ]; then
			imprime_informacoes $usuario $ip $hostname_encontrado
			return
		elif [ "$opcao" == "-l" ]; then
			imprime_informacoes $usuario $ip $hostname_encontrado
		fi
	done
}

opcao=$1
hostname=$2
if [ "$opcao" != "-l" ] && [ "$opcao" != "-s" ]; then
	echo ""
	echo "Digite ./identifica-hosts.sh -l para listar todos os hostnames conectados a rede."
	echo "Ou digite ./identifica-hosts.sh -s NOME_DA_MAQUINA para identificar o usuário da máquina desejada"
	echo ""
	exit
fi

echo ""
echo "Identificação de hostnames conectados ao servidor"
echo ""

resolucao_hostname $opcao $hostname
