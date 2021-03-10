#!/bin/bash
#This script checks the open prs in the repository and returns the list of the most productive contributors

help_func() {
  echo "This script checks the open prs in the repository and returns the list of the most productive contributors"
  echo "Please use the script like this: $0 <repo>"
  echo "For example: $0 https://github.com/htop-dev/htop"
}

error_func() { 
  cat <<< "$*" 1>&2; 
}

if [ "$1" = "--help" ] ; then
  help_func
  exit 0
fi

if [ $# -ne 1 ]; then
  error_func"Attention! Argument is not valid"
  help_func
  exit 1
fi

link='(github.com/)(.+)/(.+)'
if [[ $1 =~ $link ]]; then
  user_link="${BASH_REMATCH[2]}"
  repo_link="${BASH_REMATCH[3]}"
else
  error_func"Incorrect argument! See example in help."
  help_func
  exit 1
fi

get_data=$(curl -sf "https://api.github.com/repos/${user_link}/${repo_link}/pulls")
if [ $? -ne 0 ]; then
  error_func"Connection error to the "$1""
  exit 1
fi

pull_requests=$(echo "$get_data" | jq -r '.[]| [.state, .user.login ] |@tsv')
pull_requests=$(echo "$pull_requests" | awk '$1=="open" {print $1,$2}') 

if [ -z "${pull_requests##*( )}" ]; then
  echo "No data to display"
  exit 0
fi

pull_requests=$(echo "$pull_requests" | sort -k1,2 | uniq -c | sort -r | awk '$1>2 {print $3,$1}' )

echo "The most productive contributors for the Git repo ${user_link}/${repo_link}"
echo "$(echo "$pull_requests" | awk 'BEGIN { print "Username", "Pull_requests"} { print $1, $2 }' | column -t)"

echo
echo "Users and their PRs"
labels=$(echo "$get_data" | jq -r '.[]| [ .head.label ] |@tsv')
echo "$(echo "$labels" | sort -u)"