#!/bin/bash

echo "=============================="
echo "Installing Flatpak packages..."
echo "=============================="

dnf_list="~/pkglist/flatpak-list.txt"
dnf_lock="~/pkglist/flatpak-lock.txt"

if [[ ! -f "$dnf_lock" ]]; then
	touch "$dnf_lock"
fi

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
	#echo "flatpak install $pkgs_to_install"
	flatpak install $pkgs_to_install
fi

if [[ -n "$pkgs_to_remove" ]]; then
	#echo "flatpak remove $pkgs_to_remove"
	flatpak remove $pkgs_to_remove
fi

#echo "cp $dnf_list $dnf_lock"
cp "$dnf_list" "$dnf_lock"
