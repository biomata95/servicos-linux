# A cada 1 minuto é gerado um backup

function geraData(){
	date=$(date +%F_%H-%M-%S)
	echo "$date"
}

while [ True ]
do
	date=$(geraData)
	touch ../Backup/logs/$date.log
	ls -R ../../Público/* >> ../Backup/logs/$date.log
	mkdir ../Backup/$date && cp -r ../../Público/* ../Backup/$date
	sleep 60 # pausa de 1 minuto (60 segundos)
done
