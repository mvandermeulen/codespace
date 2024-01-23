#!/bin/bash

F_WHITE="\033[38;2;255;255;255m"
F_BLACK="\033[38;2;0;0;0"
F_CYAN="\033[38;2;0;255;255m"
F_GREEN="\033[38;2;127;230;127m"
F_RED="\033[38;2;255;127;127m"
F_YELLOW="\033[38;2;255;255;25m"
F_RESET="\033[39m"

function _printer() {
	if [ $# -lt 2 ]; then
		return # exit if no argument provided to the print functions
	fi

	local color=$1
	local module=$2

	echo -e "${color}[$module] ${F_WHITE}⇒ ${@:3} $F_RESET"
}

function print_message() { _printer ${F_CYAN} $@; }

function print_success() { _printer ${F_GREEN} $@; }

function print_warning() { _printer ${F_YELLOW} $@; }

function print_error() { _printer ${F_RED} $@; }
