#!/bin/bash
interface="eth0"
id_provided=false
id="$RANDOM"

def_type="bmx6"
type="bmx6"

cmd="bmx6 debug=0 dev=$interface"
log_base="/var/log"

log_file=$log_base/docker-$id


#support ipv6 missing
wait_interface(){
	delay=5
	FOUND=`grep $interface /proc/net/dev`

	while  [ ! -n "$FOUND" ] ;do
		echo "$interface not present yet, waiting $delay seconds"
		FOUND=`grep $interface /proc/net/dev`
		sleep $delay
	done
	echo "$interface PRESENT"
}


usage(){
cat <<-ENDOFMESSAGE
			usage: docker run <options> docker_image_name  [OPTION...] 

			        OPTIONS:
			                -t <type>:      start a container type. 
			                                type can be: olsrd, OLSRD, BMX6 or bmx6.
			                -i <id_number>: provide the id of the container, 
			                                defaults to a Random Number
			                -h:             display this message


			        NOTE:   if no parameters are provided 
			                the defaults are BMX6 and a random id.
			
ENDOFMESSAGE

}


while getopts ht:i: opt; do
	case "$opt" in
		t)
		  	type=$OPTARG
		  	case $type in
			  	"bmx6"|"BMX6"|"b"|"B")
					echo "BMX6 container selected"
					type="bmx6"
					cmd="bmx6 debug=0 dev=$interface"
					;;
				"olsrd"|"OLSRD"|"o"|"O")
					echo "OLSR container selected" 
					type="olsrd"
					cmd="olsrd -f /etc/olsrd/olsrd.conf -i $interface -nofork"
					;;
				*)
					if [ -z "$type" ];then
						type=$def_type
					else
						echo "wrong type '$type' should be: BMX6 or OLSRD"
						exit 0
					fi
					;;
		   	esac
		  ;;
		
		i)
			
			#if [ "$OPTARG" -eq "$OPTARG" ] 2>/dev/null; then
				id_provided=true	
				id=$OPTARG			
			#else	
				#echo "id '$OPTARG' is NAN"
  				#usage
  				#exit 0
			#fi
			;;
		h)
			usage
			exit 0
			;;
		\?)
			#usage
			exit 0
			;;
	esac

done

start(){
	log_base=$log_base/$type
	mkdir $log_base 2>/dev/null
	chmod 775 -R $log_base
	log_file=$log_base/docker-$id
	#always errase the logfile on first start
	echo " " > $log_file
	chmod 775 $log_file

	ifconfig $interface | tee -a $log_file

	echo "LOGFILE: $log_file" |tee -a $log_file

	case $type in
		"bmx6")
			echo "BMX6 container selected" | tee -a $log_file
			;;
		"olsrd")
			echo "OLSR container selected" |tee -a $log_file
			;;	
	esac


	cmd="${cmd}"
	echo "CMD:   $cmd " |tee -a $log_file

	echo "[$(date +%D-%T)] STARTING: container-$id"|tee -a $log_file

	eval $cmd | tee -a $log_file
}


##wait until eth0 is present
wait_interface

start







