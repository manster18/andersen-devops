# Task number 3

## Unleash your creativity with GitHub
* write a script that checks if there are open pull requests for a repository. An url like `https://github.com/$user/$repo` will be passed to the script
* print the list of the most productive contributors (authors of more than 1 open PR)
* print the number of PRs each contributor has created with the labels
* implement your own feature that you find the most attractive: anything from sorting to comment count or even fancy output format
* ask your chat mate to review your code and create a meaningful pull request
* do the same for her xD
* merge your fellow PR! We will see the repo history

### Hints
* [Have a look here](https://github.com/trending) and `curl`
* Hey, why are you not telling us about the scoring?

## Dependencies

For this script to work correctly you need to install the jq package

```sh
apt update
apt install jq
```

## Usage script task3.sh:

```sh
$ ./task_3.sh [git_repo]
```

## Examples of usage script:

```sh
$ ./task_3.sh https://github.com/htop-dev/htop

The most productive contributors for the Git repo htop-dev/htop
Username  Pull_requests
cgzones   11
BenBE     4

Users and their PRs
BenBE:command_color_instr
BenBE:exe_del_option
BenBE:export-symbols-on-debug
BenBE:keep_bold
Ckath:vim_mode
cgzones:cpu_proc_stat
cgzones:cputemp
cgzones:darwin_threads
cgzones:freebsd
cgzones:harden
cgzones:header_fmt
cgzones:ip
cgzones:lockdown
cgzones:sharedMem
cgzones:test
cgzones:zram
eworm-de:graph-color-new-3
jb-boin:master
natoscott:pcp-platform
```

## Help
```sh
$ ./task_3.sh --help
This script checks the open prs in the repository and returns the list of the most productive contributors
Please use the script like this: ./task_3.sh <repo>
For example: ./task_3.sh https://github.com/htop-dev/htop
```

