# Script task1.sh

This script designed to get the necessary information from the "netstat" utility. It can help you get information about found processes, IP addresses, or "WHOIS" information of the address you are looking for.

## Installation

You should download this repository [manster18/andersen-devops](git@github.com:manster18/andersen-devops.git) to use script.

```bash
git pull git@github.com:manster18/andersen-devops.git
```

## Usage

```bash
cd bash/
chmod +x task1.sh

./task1.sh -p firefox  #find connections with name "firefox"
Program firefox is running
tcp        0      0 192.168.10.201:51608    54.70.104.236:443       ESTABLISHED 1700/firefox-esr

./task1.sh --state=ESTABLISHED  #find connections with ESTABLISHED state
State of connections ESTABLISHED is found
tcp        0      0 192.168.*.*:22       192.168.112.41:52684     ESTABLISHED 19678/sshd: user2
tcp        0      0 192.168.*.*:57900    142.250.186.42:443       ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.*.*:51608    54.70.104.236:443        ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.*.*:22       192.168.111.11:51697     ESTABLISHED 856/sshd: user

./task1.sh -p firefox --details  #show more details about connections (only 5 lines) WHOIS/Organization
Program firefox is running
Address 54.239.192.65 has    Amazon Technologies Inc. (AT-88-Z)   Amazon.com, Inc. (AMAZON-4) organization
Address 54.70.104.236 has    Amazon Technologies Inc. (AT-88-Z) organization
Address 69.171.250.13 has    Facebook, Inc. (THEFA-3) organization
Address 69.171.250.35 has    Facebook, Inc. (THEFA-3) organization
Address 144.76.201.230 has    RIPE Network Coordination Centre (RIPE) organization
tcp        0      0 192.168.10.201:48208    37.17.118.18:443        ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:59504    54.239.192.118:443      ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:39072    54.239.192.41:443       ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:59220    15.237.136.106:443      ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:55944    34.236.11.154:443       ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:57932    142.250.186.42:443      ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:36598    144.76.201.230:80       ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:41252    178.154.131.216:443     ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:54250    52.31.32.198:443        ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:36604    144.76.201.230:80       ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:39054    104.244.42.136:443      ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:55488    23.218.209.37:443       ESTABLISHED 1700/firefox-esr
tcp        0      0 192.168.10.201:39354    104.81.119.237:443      ESTABLISHED 1700/firefox-esr
```

## Help
```bash
OPTION -- script for checking host connections

where:
    -h --help         show this help text
    -a --all          show all info from netstat util
    -p --program      show all info from netstat about PID or process (name)
    -d --details      show more information (WHOIS) about ip addresses (use only with -p or -i parameters)
    -i --ip           show information only about current ip address
    -s --state        show only one connection state info"
```
