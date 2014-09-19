#!/bin/bash
#------------------------------------------////
# Source oracle conf file
#------------------------------------------////
source /home/y/bin/oracle_env.sh

#------------------------------------------////
# Grep options - to exclude svn directories in search
#------------------------------------------////
export GREP_OPTIONS="--color"

#------------------------------------------////
# To display the output with colordiff for svn diff command
#------------------------------------------////
svndiff()
{
      svn diff "${@}" | colordiff
} 

#------------------------------------------////
# Colors:
#------------------------------------------////

black='\e[0;30m'
blue='\e[0;34m'
green='\e[0;32m'
cyan='\e[0;36m'
red='\e[0;31m'
purple='\e[0;35m'
brown='\e[0;33m'
lightgray='\e[0;37m'
darkgray='\e[1;30m'
lightblue='\e[1;34m'
lightgreen='\e[1;32m'
lightcyan='\e[1;36m'
lightred='\e[1;31m'
lightpurple='\e[1;35m'
yellow='\e[1;33m'
white='\e[1;37m'
nc='\e[0m'

#------------------------------------------////
# Proxy:
#------------------------------------------////

#http_proxy=http://127.0.0.1:8118/
#HTTP_PROXY=$http_proxy
#export http_proxy HTTP_PROXY

#------------------------------------------////
# Aliases:
#------------------------------------------////
alias yrootname='echo $YROOT_NAME'
alias screens='screen -list'
alias logs='cd /home/y/logs/yapache/'
alias conf='cd /home/y/conf/'
alias pub='ssh pub01.psi.corp.sp1.yahoo.com'
alias yphp='/home/y/bin/php'
alias errorlog='tail -f /home/y/logs/yapache/error'
alias colordiff '/home/y/bin/colordiff.pl'
alias openstack_vipng='ssh gettingletting.corp.ne1.yahoo.com'
alias colordiff='/home/y/bin/colordiff'
alias gitupdate='/home/ranjithk/git_update.sh'

#------------------------------------------////
# Functions and Scripts:
#------------------------------------------////

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

export JAVA_HOME=/home/y/libexec/java/jre/
export PATH=/home/y/libexec/java/jre/bin/:$PATH 

##WOOT!

localnet ()
{
/sbin/ifconfig | awk /'inet addr/ {print $2}' 
echo ""
/sbin/ifconfig | awk /'Bcast/ {print $3}' 
echo ""
}
myip ()
{
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | grep "Current IP Address" | cut -d":" -f2 | cut -d" " -f2
}
upinfo ()
{
echo -ne "${green}$HOSTNAME ${red}uptime is ${cyan} \t ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}
cd() 
{
  if [ -n "$1" ]; then
    builtin cd "$@" && ls -l
  else
    builtin cd ~ && ls -l
  fi
}
weather ()
{
declare -a WEATHERARRAY
WEATHERARRAY=( `lynx -dump "http://www.google.com/search?hl=en&lr=&client=firefox-a&rls=org.mozilla_en-US_official&q=weather+${1}&btnG=Search" | grep -A 5 -m 1 "Weather for" | sed 's;\[26\]Add to iGoogle\[27\]IMG;;g'`)
echo ${WEATHERARRAY[@]}
}

encrypt ()
{
gpg -ac --no-options "$1"
}

decrypt ()
{
gpg --no-options "$1"
}

extract()
{
if [ -f "$1" ] ; then
case "$1" in
*.tar.bz2) tar xjf "$1" ;;
*.tar.gz) tar xzf "$1" ;;
*.tar.Z) tar xzf "$1" ;;
*.bz2) bunzip2 "$1" ;;
*.rar) unrar x "$1" ;;
*.gz) gunzip "$1" ;;
*.jar) unzip "$1" ;;
*.tar) tar xf "$1" ;;
*.tbz2) tar xjf "$1" ;;
*.tgz) tar xzf "$1" ;;
*.zip) unzip "$1" ;;
*.Z) uncompress "$1" ;;
*) echo "'$1' cannot be extracted." ;;
esac
else
echo "'$1' is not a file."
fi
}

#------------------------------------------////
# Some default .bashrc contents:
#------------------------------------------////

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

#------------------------------------------////
# Prompt:
#------------------------------------------////

if [ "$YROOT_NAME" == "" ] ; then
    PS1='\[\033[01;32m\]\u\[\033[01;35m\]@\h\[\033[01;34m\]\[\033[00;34m\]{\[\033[01;34m\]\w\[\033[00;34m\]}\[\033[01;32m\]:\[\033[00m\]'
else
    OS_IN_YROOT=$(echo $YROOT_NAME | cut -c -6);
    APPLICATION=$(echo $YROOT_NAME | cut -c 7-9);
    VER_ENV=$(echo $YROOT_NAME | cut -c 10-);
    PS1='\[\033[01;32m\]\u\[\033[01;35m\]@\h\[\033[01;34m\]\[\033[01;36m\](${OS_IN_YROOT}\[\033[01;31m\]${APPLICATION}\[\033[01;36m\]${VER_ENV})(\[\033[00;34m\]{\[\033[01;34m\]\w\[\033[00;34m\]}\[\033[01;32m\]:\[\033[00m\]'
fi

#------------------------------------------////
# System Information:
#------------------------------------------////

clear
echo -ne "${cyan}";upinfo;echo ""
__hostAutoComplete()
{
local cur prev opts base
   COMPREPLY=()
   cur="${COMP_WORDS[COMP_CWORD]}"
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   opts="`cut -d " " -f 1  ~/.ssh/known_hosts | cut -d ',' -f 1`";
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
  return 0
}
__screenAutoComplete()
{
local cur prev opts base
   COMPREPLY=()
   cur="${COMP_WORDS[COMP_CWORD]}"
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   opts="`screen -list | sed 'N;$!P;$!D;$d' | tail -n +2 | cut -d"(" -f1 | awk -F"." '{print $2}' | tr '\n' ' '`";
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
  return 0
}

complete -F __hostAutoComplete ssh
complete -F __hostAutoComplete yssh
complete -F __screenAutoComplete screen
if [ -f /home/y/etc/yroot/yroot.bashrc ]; then
   . /home/y/etc/yroot/yroot.bashrc
fi
set -o ignoreeof
export PATH=$PATH:/home/y/bin/

#### SQL default settings
export SQLPATH=/home/ranjithk/sql/login.sql
export MAVEN_OPTS='-Xms256m -Xmx1024m -XX:MaxPermSize=512m'
export JAVA_OPTS='-Xms256m -Xmx1024m -XX:MaxPermSize=512m'
export LC_ALL="en_GB.utf8"
