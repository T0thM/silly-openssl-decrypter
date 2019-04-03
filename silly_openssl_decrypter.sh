#!/bin/bash

# Openssl encrypted, base64 encoded files brute-forcer/decrypter
# Using aes-256-cbc cipher, but you are free to modify the code
# Silly solution, but working (tested on CTF machine, inspired by HackTheBox machine: Hawk)
# Needed to get rid of CRLF line endings with dos2unix.


#read -e -p "Please enter the encrypted file path: " encfile
#read -e -p "Please enter wordlist location: " wordvar

wordvar=$1
encfile=$2

RED='\033[0;31m'
NC='\033[0m'

usage() {
	    echo
	    echo "Usage: $0 wordlist encrypted_file"
	    echo
	    }


if [ -z $wordvar ] 
then
	echo -e "Missing wordlist!"
	usage
elif [ -z $encfile ]
then
	echo -e "Missing encrypted_file!"
	usage
else
	echo -e "\nStarting bruteforce\n"	
	array=($(for i in $(cat $wordvar | dos2unix);do openssl aes-256-cbc -d -a -in $encfile -pass pass:$i 2>&1 | grep -q 'error' || echo -e $i;done))



# Store the possible passwords in an array

for passwords in ${!array[*]}
do
	# Check the possible passwords and discard those which give us binary output or "bad decrypt" error.
	openssl enc -aes-256-cbc -a -d -in $encfile -k ${array[passwords]} 2>&1 | grep -P "[\x21-\x7e]" | grep -v '\*\*\*|using' | grep -v "^$" | grep -q 'Binary' || echo -e "Password is: ${RED}${array[passwords]}${NC}"
done 

echo -e "\nFinished"

echo -e "\nTo decrypt the encrypted openssl file (base64 encoded) use the following command: \n
	openssl enc -aes-256-cbc -a -d -in file.txt.enc -out file.txt -k PASS"

fi
exit 0
