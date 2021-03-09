#/bin/bash
# This is a second task where I become a financial guru :)


usage="$(basename "$0") [-h] OPTION -- script for checking host connections
where:
    -h --help         show this help text
    -f --file         path to the file with data
    -m --month        month of the year (01 - 12), but less than 02/2021
    -s --start        first year for the period (please use value from 2015 to 2021, but less than a "last" parameter)
    -l --last         last year for the period (please use value from 2015 to 2021, but more than a "start" parameter)

Example:
- ./task_2.sh -f quotes.json -m 02 -s 2019 -l 2021

Notice: this script has default values of variables:

file="quotes.json"
month=03
start=2015
last=2020"

# default script variables
file="quotes.json"
month=03
start=2015
last=2020
a=0
MIN=999
MAX=1.01

# defining script parameters
while [ -n "$1" ]; do
  param="$1"
  case $param in
    -h|--help)
    echo "$usage" && exit 0
    shift
    ;;
    -f|--file)
    file="$2"
    shift
    shift
    ;;
    -m|--month)
    month="$2"
    shift
    shift
    ;;
    -s|--start)
    start="$2"
    shift
    shift
    ;;
    -l|--last)
    last="$2"
    shift
    shift
    ;;
    *)
    echo "Error: unknown key" 1>&2
    echo "You must provide at least one option"
    echo "$usage"
    exit 1
    shift
    ;;
  esac
done

#checking if the file "quotes.json" exists
if [[ ! -f "$file" ]]; then
  curl -s https://yandex.ru/news/quotes/graph_2000.json > $file
fi

#create table with human-readable date format
while read -r line; do
  data_table+=( "$line" )
done < <( jq -r '.prices[][]' $file |
  awk '{
    if (NR%2)
      {$1 = $1/1000; print strftime("%m/%Y", $1)}
    else {print}}' )


# create table with nedeble months
while [ $start -le $last ]
do
  for i in "${!data_table[@]}";
  do
    if [[ $(echo "${data_table[i]}" | grep "$month/$start") == "$month/$start" ]] ; then
       if [[ $"${data_table[i+1]}" < "$MIN" ]] ; then
          MIN=$"${data_table[i+1]}"
       fi
       if [[ $"${data_table[i+1]}" > "$MAX" ]] ; then
          MAX=$"${data_table[i+1]}"
       fi
    fi
  done

  volatility=`echo "scale=3; ($MAX-$MIN) / 2" | bc -l | awk '{printf "%.3f", $0}'`
  volat_array[a]=$(echo "$month/$start")
  volat_array[a+1]=$volatility
  a=$[ $a + 2 ]

  echo "Max value in "$month"/"$start" = "$MAX""
  echo "Min value in "$month"/"$start" = "$MIN""
  echo -e "Volatility for the "$month"/"$start" = "$volatility"\n"
  start=$[ $start + 1 ]
  MIN=999.01
  MAX=0.01
done

# Find best year volatility
MIN_VOLAT=$"${volat_array[1]}"
MIN_VOLAT_DATE=$"${volat_array[0]}"
for i in "${!volat_array[@]}";
  do
    if [[ $( echo "${volat_array[i]}" | grep -v "/") > 0 ]]; then
      if [[ $( echo "${volat_array[i]}" ) < "$MIN_VOLAT" ]] ; then
      MIN_VOLAT=$"${volat_array[i]}"
      MIN_VOLAT_DATE=$"${volat_array[i-1]}"
      fi
    fi
done

echo "Result: Best volatility month/year - "$MIN_VOLAT_DATE" and best volatility value - "$MIN_VOLAT""
