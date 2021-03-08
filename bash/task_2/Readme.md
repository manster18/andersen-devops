# Task number 2

## Become financial guru
```sh
# Download the database
curl -s https://yandex.ru/news/quotes/graph_2000.json > ./quotes.json
```
Now you have historical quotes for EUR/RUB pair since late November 2014. It's time to have some fun:
```sh
# let's get the mean value for the last 14 days and decide whether to buy Euros:
jq -r '.prices[][]' quotes.json | grep -oP '\d+\.\d+' | tail -n 14 | awk -v mean=0 '{mean+=$1} END {print mean/14}'
```
* try to understand the command above. Read something related to `jq` and `awk`.
* remove the `grep -oP '\d+\.\d+'` part, do the same thing without any pattern matching

My solution:
```sh
jq -r '.prices[]|@csv' quotes.json | awk -F "," '{print $2}' | tail -n 14 | awk -v mean=0 '{mean+=$1} END {print mean/14}'
```
* tell me which March the price was the least volatile since 2015? To do so you'll have to find the difference between MIN and MAX values for the period.

## Usage script task2.sh:

## Dependencies

For this script to work correctly you need to install the GAWK package

```sh
apt update
apt install gawk
```

```sh
$ ./task2.sh [DATABSE][OPTIONS]
```

## Examples of usage script:

```sh
$ ./task2.sh -f quotes.json -m 03 -s 2015 -l 2020

Max value in 03/2015 = 70
Min value in 03/2015 = 62.284
Volatility for the 03/2015 = 3.858

Max value in 03/2016 = 80.188
Min value in 03/2016 = 75.688
Volatility for the 03/2016 = 2.250

Max value in 03/2017 = 63.075
Min value in 03/2017 = 59.89
Volatility for the 03/2017 = 1.592

Max value in 03/2018 = 71.345
Min value in 03/2018 = 69.61
Volatility for the 03/2018 = 0.867

Max value in 03/2019 = 74.875
Min value in 03/2019 = 72.51
Volatility for the 03/2019 = 1.182

Max value in 03/2020 = 88.3275
Min value in 03/2020 = 73.7775
Volatility for the 03/2020 = 7.275

Result: Best volatility month/year - 03/2018 and best volatility value - 0.867
```

```sh
$ ./task_2.sh -f quotes.json -m 11 -s 2019

Max value in 11/2019 = 70.9525
Min value in 11/2019 = 70.14
Volatility for the 11/2019 = 0.406

Max value in 11/2020 = 93.775
Min value in 11/2020 = 89.68
Volatility for the 11/2020 = 2.047

Result: Best volatility month/year - 11/2019 and best volatility value - 0.406

```

## Help
```sh
$ ./task_2.sh -h
task_2.sh [-h] OPTION -- script for checking host connections
where:
    -h --help         show this help text
    -f --file         path to the file with data
    -m --month        month of the year (01 - 12), but less than 02/2021
    -s --start        first year for the period (please use value from 2015 to 2021, but less than a last parameter)
    -l --last         last year for the period (please use value from 2015 to 2021, but more than a start parameter)

Example:
- ./task_2.sh -f quotes.json -m 02 -s 2019 -l 2021

Notice: this script has default values of variables:

file=quotes.json
month=03
start=2015
last=2020
```
