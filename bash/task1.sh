#/bin/bash
# This script relates to task_1 by Andersen courses

connection='sudo netstat -tunapl'
usage="$(basename "$0") [-h] OPTION -- script for checking host connections

where:
    -h --help         show this help text
    -a --all          show all info from netstat util
    -p --program      show all info from netstat about PID or process (name)
    -d --details      show more information (WHOIS) about ip addresses (use only with -p or -i parameters)
    -i --ip           show information only about current ip address
    -s --state        show only one connection state info"

function check_program {
if ps -a | grep -v grep | grep $program > /dev/null || sudo netstat -tulpna | awk '{print $6, $7}' | grep $program
then
   echo "Program $program is running"
else
   echo "Program $program is NOT running"
   exit 1
fi
}

function check_state {
if sudo netstat -tulpna | grep -E "ESTABLISHED|SYN_SENT|SYN_RECV|FIN_WAIT1|FIN_WAIT2|TIME_WAIT|CLOSE|CLOSE_WAIT|LAST_ACK|LISTEN|CLOSING|UNKNOWN" | grep $state > /dev/null
then
   echo "State of connections $state is found"
else
   echo "State of connections $state is NOT found"
   exit 1
fi
}

function check_ip {
if sudo netstat -tulpna | awk '{print $4, $5}' | grep $ip > /dev/null
then
   echo "Connection with $ip is found"
else
   echo "Connection with $ip is NOT found"
   exit 1
fi
}

function det {
addr=$(sudo netstat -tunapl | grep $(echo $program)| awk '{print $5}' | cut -d: -f1 | sort | \
uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+')
for i in $(echo $addr)
do
  who=$(whois $i | awk -F':' '/^Organization/ {print $2}') ;
  if [ -n "$who" ] ;  then
  echo "Address $i has $who organization"
  else
  echo "Organisation field doesn't found for the $i address"
  fi
done
}

while [ 1 ] ; do
   if [ "$1" = "--all" ] ; then
      echo "Full information about processes"
      $connection
      exit 0
   elif [ "$1" = "-a" ] ; then
      echo "Full information about processes"
      $connection
      exit 0
   elif [ "${1#--program=}" != "$1" ] ; then
      program="${1#--program=}"
   elif [ "$1" = "-p" ] ; then
      shift ; program="$1"
   elif [ "${1#--ip=}" != "$1" ] ; then
      ip="${1#--ip=}"
   elif [ "$1" = "-i" ] ; then
      shift ; ip="$1"
   elif [ "${1#--state=}" != "$1" ] ; then
      state="${1#--state=}"
   elif [ "$1" = "-s" ] ; then
      shift ; state="$1"
   elif [ "$1" = "--details" ] ; then
      details=true
   elif [ "$1" = "-d" ] ; then
      details=true
   elif [ "$1" = "--help" ] ; then
      echo "$usage" && exit 0
   elif [ "$1" = "-h" ] ; then
      echo "$usage" && exit 0
   elif [ -z "$1" ] ; then
      break
   else
      echo "Error: unknown key�" 1>&2
      echo "You must provide at least one option"
      echo "$usage"
      exit 1
   fi
   shift
done

if [ -n "$program" ] ; then
    check_program
    connection=$($connection | grep $program)
    if [ -n "$details" ] ; then
       det
    fi
elif [ -n "$ip" ] ; then
    check_ip
    if [ -n "$details" ] ; then
       who=$(whois $ip | awk -F':' '/^Organization/ {print $2}') ;
        if [ -n "$who" ] ;  then
           echo "Address $i has $who organization"
        else
           echo "Organisation field doesn't found for the $i address"
        fi
    fi
    connection=$($connection | grep $ip)
elif [ -n "$state" ] ; then
    check_state
    connection=$($connection | grep $state)
else
    echo "$usage"
fi

echo "$connection"