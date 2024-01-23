#!/bin/bash

info() {
	echo -n "install Alacritty terminal"
}

# TODO: clone only the branch containing the specified tag
run() {
    linker $1 "$dotfiles_directory/alacritty" "$HOME/.config/alacritty"

    if ! command -v cargo > /dev/null 2>&1; then
        print_error $1 "cargo isn't installed"
        exit 1
    fi

    # install dependencies
    sudo dnf install -qy scdoc cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++

    local temp_dir=$(mktemp -d -t mytempdir.XXXXXX)
    local repository_url="https://github.com/alacritty/alacritty.git"
    local tag="v0.13.0-rc2"

    git clone $repository_url $temp_dir
    cd $temp_dir && git checkout $tag

    # building
    cargo build --release --no-default-features --features=wayland

    # place the binary into
    sudo cp target/release/alacritty /usr/local/bin

    # creating desktop entry
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    # installing the manual page
    sudo mkdir -p /usr/local/share/man/man1
    sudo mkdir -p /usr/local/share/man/man5
    scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
    scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
    scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
    scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null

    # keep it at the last line
    rm -rf "$temp_dir"
}
