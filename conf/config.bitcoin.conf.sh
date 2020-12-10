#!/bin/sh
export LC_CTYPE=C

NORMAL="\033[1;0m"
STRONG="\033[1;1m"
GREEN="\033[1;32m"

config=$(find ~/stats.bitcoincore.dev/conf -maxdepth 2 -type f -name bitcoin.conf)

randgen() {
	output=$(cat /dev/urandom | tr -dc '0-9a-zA-Z!@#$%^&*_+-' | head -c${1:-$1}) 2>/dev/null
	echo $output
}

findRandomTcpPort(){
    port=$(( 3000 ))
	while netstat -atn | grep -q :$port; do port=$(expr $port); done; echo $port
}

GenPasswd(){
	sed -i "/rpcuser=/ c \rpcuser=USER-"$(randgen 32)"" $1
	sed -i "/rpcpassword=/ c \rpcpassword=PW-"$(randgen 64)"" $1
	sed -i "/rpcport=/ c \rpcport="$(findRandomTcpPort)"" $1
	print_green "Generated random user / password / port in:" " $1\n"
}

print_green() {
	local prompt="${STRONG}$1${GREEN}$2${NORMAL}"
	printf "${prompt}%s"
}

for file in $config; do
	if grep -F "changeme" $file 1>/dev/null; then
		GenPasswd $file
	fi
done

install -v $config ~/.bitcoin/

exit 0
