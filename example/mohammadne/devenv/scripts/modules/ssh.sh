#!/bin/bash

info() {
	echo -n "install ssh"
}

run() {
    sudo dnf install -qy openssh

    linker $1 "$dotfiles_directory/ssh" "$HOME/.ssh"
    _generate_ssh_keys $1
}

function _generate_ssh_keys() {
	# Use awk to extract and print unique IdentityFiles
	local identity_files=($(awk '$1 == "IdentityFile" {print $2}' "$HOME/.ssh/config" | sort -u))

	for i in "${!identity_files[@]}"; do
		local identity_file=$(eval "echo ${identity_files[$i]}")
		local algorithm="${identity_file##*_}"

		if [ ! -f "$identity_file" ]; then
			ssh-keygen -t $algorithm -f "$identity_file" -N "" -C "" > /dev/null
		fi
	done

	print_warning $1 "add your public ssh credentials to remote hosts"
}
