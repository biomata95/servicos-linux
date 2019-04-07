function deleta_arquivo(){
	echo $1 "Deletado"
	rm -r $1
}


flag_deleta=false
fs=/dev/sdb1
caminho=/home/administrador/Arquivos
for file in $(ls -i /home/administrador/Arquivos)
do
        diretorio=$caminho"/"$file
	if [ $flag_deleta == true ] && [ -f $diretorio ]
	then
		deleta_arquivo $diretorio
	fi
	if ! [ -f $diretorio ]
	then
		var=$(debugfs -R 'stat <'$file'>' $fs | grep crtime | awk '{print $5" "$6" "$7" "$8}')
		mes=$(echo $var | awk '{print $1}')
		dia=$(echo $var | awk '{print $2}')
	        ano=$(echo $var | awk '{print $4}')
		data=$dia"-"$mes"-"$ano
		data_criacao=$(date --date=$data +"%d-%m-%Y")
		data_referencia=$(date --date="8 day ago" +"%d-%m-%Y")
		if [ "$data_criacao" == "$data_referencia" ]
		then
			flag_deleta=true
		else
			flag_deleta=false
		fi
	fi
done
