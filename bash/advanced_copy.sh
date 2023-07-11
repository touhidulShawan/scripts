#!/usr/bin/env bash

# Author: Touhidul Shawan
# Date Created: 21-04-2023
# Date Modified: 21-04-2023

# Description
# Automation of advanced copy utility of coreutils of copy

# Usages
# run ./advanced_copy.sh shell script

echo "Available coreutils here https://ftp.gnu.org/gnu/coreutils/"
echo "Enter the version of coreutils(ex: 9.1.2): "
read -r coreutilVersion

# check if the coreutils.tar file is exist or not
if [[ -f ./coreutils-${coreutilVersion}.tar.xz ]]; then
	echo "File already exist"
else
	# download selected version of coreutils
	if command -v xh &>/dev/null; then
		xh --download "http://ftp.gnu.org/gnu/coreutils/coreutils-${coreutilVersion}.tar.xz"
	else
		wget "http://ftp.gnu.org/gnu/coreutils/coreutils-${coreutilVersion}.tar.xz"
	fi
fi

# extracting tar file of coreutils
if [[ -f ./coreutils-${coreutilVersion}.tar.xz ]]; then
	tar -xvf ./coreutils-"${coreutilVersion}".tar.xz
	# delete tar file
	rm ./coreutils-"${coreutilVersion}".tar.xz
else
	echo "No file found to extract"
fi

(
	# cd to extracted folder
	if [[ -d ./coreutils-${coreutilVersion} ]]; then
		cd ./coreutils-"${coreutilVersion}"/ || exit

		# download latest patch of advcpmv (https://github.com/jarun/advcpmv)
		echo "Available patch here https://github.com/jarun/advcpmv"
		echo "Enter the version of patch of advcpmv (ex: 9.2): "
		read -r patchVersion
		if command -v xh &>/dev/null; then
			xh --download https://raw.githubusercontent.com/jarun/advcpmv/master/advcpmv-0.9-"${patchVersion}".patch
		else
			wget https://raw.githubusercontent.com/jarun/advcpmv/master/advcpmv-0.9-"${patchVersion}".patch
		fi
		# patch
		patch -p1 -i advcpmv-0.9-"${patchVersion}".patch
		./configure
		make
		sudo cp src/cp /usr/local/bin/cp
		sudo cp src/mv /usr/local/bin/mv
	else
		echo "Please extract tar file first"
	fi
)
rm -rf coreutils-"${coreutilVersion}"
