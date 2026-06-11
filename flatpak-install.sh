#!/bin/bash


echo "=============================="
echo "Installing flatpak packages..."
echo "=============================="

conf_path=~/.config/pkglist
list_path="$conf_path/flatpak-list.txt"
lock_path="$conf_path/flatpak-lock.txt"

if [[ ! -f "$list_path" ]]; then
    mkdir -p "$conf_path"
	touch "$list_path"
fi

if [[ ! -f "$lock_path" ]]; then
    mkdir -p "$conf_path"
	touch "$lock_path"
fi

pkgs_to_install=$(comm -23 <(sort "$list_path") <(sort "$lock_path") | grep '^[^#]')
pkgs_to_remove=$(comm -13 <(sort "$list_path") <(sort "$lock_path") | grep '^[^#]')

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
	flatpak install $pkgs_to_install
fi

if [[ -n "$pkgs_to_remove" ]]; then
	flatpak remove $pkgs_to_remove
fi

cp "$list_path" "$lock_path"
