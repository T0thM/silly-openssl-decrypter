#!/bin/bash

read -e -p "Please enter the encrypted file path: " enc_file
read -e -p "Please enter wordlist location: " wordvar
CIPHER="aes-256-cbc" 

# Openssl encrypted, base64 encoded files brute-forcer/decrypter
# Using aes-256-cbc cipher, but you are free to modify this"
# Silly solution, but working (tested on CTF machine)
# Needed to get rid of CRLF line endings with dos2unix

for i in $(cat $wordwar | dos2unix); do echo -e "\nTesting password: $i"; openssl $CIPHER -d -a -in $enc_file -pass pass:$i | grep -i -E '[A-Za-z0-9]{3,30}';done < $wordvar 2>/dev/null | grep -v -i -E 'testing|binary' | grep -v "^$"

exit 0
