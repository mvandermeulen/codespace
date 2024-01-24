#!/usr/bin/env bash

set -eux -o pipefail

# Required arguments
readonly LOCALE="${1:-}"
readonly USER_NAME="${2:-}"
readonly USER_ID="${3:-}"
readonly USER_PWD="${4:-}"

declare -A args
args=(
	["1st argument (locale)"]="${LOCALE}"
	["2nd argument (user name)"]="${USER_NAME}"
	["3rd argument (user ID)"]="${USER_ID}"
	["4th argument (user password)"]="${USER_PWD}"
)

for arg in "${!args[@]}"; do
	if [ -z "${args[$arg]}" ]; then
		echo "${arg} must be passed and cannot be empty"
		exit 1
	fi
done

# Update OS
apt-get update -y
apt-get upgrade -y

# Configure locale
apt-get install -y locales
locale-gen ${LOCALE}

# Configure local time
apt-get install -y tzdata
ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# Make sure to install sudo
apt-get install -y sudo

# Create the user account
useradd --create-home --user-group --uid "${USER_ID}" -G sudo "${USER_NAME}"
echo "${USER_NAME}":"${USER_PWD}" | chpasswd

# Allow the user to get root privileges
echo "${USER_NAME}    ALL=(ALL:ALL) ALL" >>"/etc/sudoers.d/99-user-${USER_NAME}"
