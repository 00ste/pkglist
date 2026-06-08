#!/bin/bash


echo "=========================="
echo "Installing dnf packages..."
echo "=========================="

dnf_list="~/pkglist/dnf-list.txt"
dnf_lock="~/pkglist/dnf-lock.txt"

pkgs_to_install=$(diff "$dnf_list" "$dnf_lock" | grep '^< [^#]' | sed 's/^<\ //')
pkgs_to_remove=$(diff "$dnf_list" "$dnf_lock" | grep '^> [^#]' | sed 's/^>\ //')

if [[ -n "$pkgs_to_install" ]]; then
	echo -n "Installing "
	echo $pkgs_to_install
else
	echo "Nothing to install"
fi

if [[ -n "$pkgs_to_remove" ]]; then
	echo -n "Removing "
	echo $pkgs_to_remove
else
	echo "Nothing to remove"
fi

if [[ -z "$pkgs_to_install" ]]; then
	if [[ -z "$pkgs_to_remove" ]]; then
		exit
	fi
fi

echo -n "Is this fine? [Y/n] "
read yn

if [ "$yn" = "n" ] || [ "$yn" = "N" ]; then
	exit
fi

if [[ -n "$pkgs_to_install" ]]; then
	#echo "sudo dnf install $pkgs_to_install"
	sudo dnf install $pkgs_to_install
fi

if [[ -n "$pkgs_to_remove" ]]; then
	#echo "sudo dnf remove $pkgs_to_remove"
	sudo dnf remove $pkgs_to_remove
fi

#echo "cp $dnf_list $dnf_lock"
cp "$dnf_list" "$dnf_lock"
