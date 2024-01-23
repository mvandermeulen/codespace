#!/bin/bash

info() {
	echo -n "install fonts"
}

run() {
    sudo dnf install -qy fontconfig

    _fira_code
}

# TODO: use new release download from zip file
# https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip
# curl -> unzip -> delete original
function _fira_code() {
    font_family="FiraCode"
    font_weights="Bold Medium Regular Light"

    font_repository="https://github.com/ryanoasis/nerd-fonts"
    font_repository_release="v2.1.0"

    font_home="$HOME/.local/share/fonts/$font_family"

    if [ -d $font_home ]; then
        print_warning $1 "font directory for $font_family already exist."
        return
    fi

    mkdir -p $font_home && cd $font_home

    for weight in $font_weights; do
        echo "$font_repository/blob/$font_repository_release/patched-fonts/$font_family/$weight/complete/Fira%20Code%20$weight%20Nerd%20Font%20Complete.ttf"
        # curl -SLo "$weight.ttf" "$font_repository/blob/$font_repository_release/patched-fonts/$font_family/$weight/complete/Fira%20Code%20$weight%20Nerd%20Font%20Complete.ttf"
    done

    # reset font cache
    if (command -v fc-cache &> /dev/null) ; then
        fc-cache -f "$font_home"
    fi
}
