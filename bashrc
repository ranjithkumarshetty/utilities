#!/bin/bash
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
# Functions and Scripts:
#------------------------------------------////

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

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
# Prompt:
#------------------------------------------////
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function _ps1_prompt () {
	if [[ -n $(git_branch) ]] ; then
    		PS1='\[\033[01;32m\]\u\[\033[01;35m\]@\h\[\033[01;34m\]\[\033[00;34m\]{\[\033[01;34m\]\w\[\033[00;34m\]}\[\033[01;32m\]\033[00;32m\]($(git_branch))\[\033[00m\]:'
	else
    		PS1='\[\033[01;32m\]\u\[\033[01;35m\]@\h\[\033[01;34m\]\[\033[00;34m\]{\[\033[01;34m\]\w\[\033[00;34m\]}\[\033[01;32m\]:\[\033[00m\]'
	fi
}

PROMPT_COMMAND=_ps1_prompt
#------------------------------------------////
# System Information:
#------------------------------------------////

clear
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

#### SQL default settings
export MAVEN_OPTS='-Xms256m -Xmx1024m -XX:MaxPermSize=512m'
export JAVA_OPTS='-Xms256m -Xmx1024m -XX:MaxPermSize=512m'
export LC_ALL="en_GB.utf8"


#### Aliases
alias st="cd /Users/rshetty/Projects/stash"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
