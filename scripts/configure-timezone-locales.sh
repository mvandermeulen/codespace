#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

export TZ=${TZ:-"Australia/Sydney"}
export LANG=${LANG:-"en_AU.UTF-8"}

# Set timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Configure Locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i -e 's/# en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_AU.UTF-8

exit 0