#!/bin/bash

# findout scripts directory path
scripts_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")"/. && pwd)"
program=$(basename $0)

# source required files (core files are needed inside library files)
for core_file in "$scripts_directory/core"/*; do source "$core_file"; done
for library_file in "$scripts_directory/library"/*; do source "$library_file"; done

source_values "$scripts_directory/values.env"

# handle sigterm traps and display handy message
trap "echo see you in a better tomorrow [you signal $program execuation]; exit" INT

# ensure we are using Fedora distribution
ensure_fedora $program

function _usage() {
    echo ""
    echo "usage: $program MODULES [OPTIONS]"
    echo ""
    echo "options:"
    echo "  --usage   show usage menu again"
    echo "  --set     set environment variables specified in values.env"
    echo ""
    echo "modules:"
    echo "$(
        find "$scripts_directory/modules" -type f -name "*.sh" \
        -exec sh -c 'echo "  $(dirname "{}")/$(basename "{}" .sh)"' \; \
        | sed "s|$scripts_directory/modules/||"
    )"
}

while [ $# -gt 0 ]; do
    case $1 in
        --usage) _usage; exit 0 ;;
        
        --set)
            if [ $# -lt 2 ]; then
                print_error "--set" "exactly one argument should be passed"
                _usage && exit 1
            fi
            source_values $2
            shift 2
        ;;
        
        *) modules_list+=("$1"); shift ;;
    esac
done

print_message "dotfiles" "ensure dotfiles repository is present with latest changes"
# full_clone "dotfiles" $dotfiles_directory $dotfiles_remote_https $dotfiles_remote_ssh

# add necessary modules to be installed before user-passed modules
modules_list=("packages/requirements" "${modules_list[@]}")

for module in "${modules_list[@]}"; do
    echo $module
    
    source "$scripts_directory/modules/$module.sh" 2>/dev/null || {
        print_error $module "404 module not found -(("
        return
    }
    
    if declare -f run &> /dev/null; then
        if declare -f info &> /dev/null; then
            print_message $module $(info)
        fi
        
        if ! run $module; then
            print_error $module "exited with an error, exiting the installer ..."
            exit 1
        fi
    else
        print_warning $module "run function not found, there is nothing to do"
    fi
done

echo && print_success "devenv" "all of the modules have been installed sucessfully"
