#!/usr/bin/env bash
#set -eo pipefail

set -e
export DEBIAN_FRONTEND=noninteractive

###################
# Versions
###################
NVM_VERSION=v0.39.1
FD_VERSION="8.7.0"
RIPGREP_VERSION="13.0.0"
GO_VERSION="1.21.1"


###################
# DYNAMIC VARIABLES
###################
HOSTNAME=$(/bin/hostname)
YEAR=$(/bin/date +"%Y")
MONTH=$(/bin/date +"%m")
SETUP_RUN_DATE=$(/bin/date +"%Y-%m-%d")


###################
# LOCAL PATHS
###################
MY_LOCAL="${HOME}/.local"
LOCAL_LOG_DIR="${MY_LOCAL}/log/${YEAR}/${MONTH}"
LOCAL_BIN_DIR="${MY_LOCAL}/bin"
MY_SRC="${MY_LOCAL}/src"
MY_FZF="${HOME}/.fzf"
MY_LUNAR_VIM="${MY_SRC}/LunarVim"
MY_PROFILE="${HOME}/.profile"
GOPATH="${HOME}/.go"


declare -a __local_directories=(
  "src"
  "bin"
  "share"
  "docs"
  "include"
  "log"
  "lib"
  "tmp"
)



###################
# SYSTEM PATHS
###################
SYSTEM_LOCAL="/usr/local"
SYSTEM_LOCAL_BINS="${SYSTEM_LOCAL}/bin"

###################
# INSTALLER VARS
###################

# NEOVIM
NVIM_CONFIG_PATH="${HOME}/.config/nvim"
NVIM_BACKUP_CONFIG_PATH="${HOME}/.config/nvim.old"
NVIM_CACHE_PATH="${HOME}/.cache/nvim"
NVIM_SHARE_PATH="${MY_LOCAL}/share/nvim"
PACKER_GIT_URL="https://github.com/wbthomason/packer.nvim"
PACKER_BASE_PATH="${MY_LOCAL}/share/nvim/site/pack/packer/start"
PACKER_DST_PATH="${PACKER_BASE_PATH}/packer.nvim"
# LVIM
LVIM_CONFIG_PATH="${HOME}/.config/lvim"
LVIM_GIT_URL="https://github.com/lvim-tech/lvim.git"
# LUNARVIM
LUNARVIM_INSTALLER_URL="https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh"
LUNARVIM_GITHUB_URL="https://github.com/LunarVim/LunarVim.git"
# RIPGREP
RG_INSTALLER_NAME="ripgrep_${RIPGREP_VERSION}_amd64.deb"
RG_DL_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${RG_INSTALLER_NAME}"
# FD
FD_INSTALLER_NAME="fd_${FD_VERSION}_amd64.deb"
FD_DL_URL="https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/${FD_INSTALLER_NAME}"
# GOLANG
GOLANG_ARCHIVE_NAME="go$GO_VERSION.linux-amd64.tar.gz"
GOLANG_DL_URL="https://go.dev/dl/${GOLANG_ARCHIVE_NAME}"
GOLANG_INSTALL_PATH="${SYSTEM_LOCAL}/go"
# FZF
FZF_GITHUB_URL="https://github.com/junegunn/fzf.git"
# NVM
NVM_INSTALLER_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"
NVM_INSTALL_PATH="${HOME}/.nvm"

# pip3 install howdoi
# pip3 install --upgrade pynvim
# pip3 install --upgrade neovim-remote

declare -a __python_installs=(
  "hererocks"
  "howdoi"
  "pynvim"
  "neovim-remote"
  "ansible"
  "virtualenvwrapper"
  "redis"
  "attrs"
  "hvac"
  "PyJWT"
  "speedtest-cli"
  "appdirs"
  "lxml"
  "black"
  "tldextract"
  "lz4"
  "rich"
  "PyYAML"
  "arrow"
  "cookiecutter"
  "cryptography"
  "cffi"
  "pydantic"
  "Jinja2"
  "dnspython"
)

declare -a __golang_installs=(
  "golang.org/x/tools/cmd/goimports@latest"
  "github.com/jesseduffield/lazygit@latest"
  "golang.org/x/tools/gopls@latest"
)

declare -a __node_installs=(
  "npm@latest"
  "http-server"
  "yarn"
  "neovim"
)


###################
# LOGGING
###################
LOG_LEVEL="${LOG_LEVEL:-6}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected
LOGFILE_NAME="setup_${HOSTNAME}_${SETUP_RUN_DATE}.log"
SETUP_LOGFILE="${LOCAL_LOG_DIR}/${LOGFILE_NAME}"


function __mylog () {
  local log_level="${1}"
  shift

  # shellcheck disable=SC2034
  local color_debug="\x1b[35m"
  # shellcheck disable=SC2034
  local color_info="\x1b[32m"
  # shellcheck disable=SC2034
  local color_notice="\x1b[34m"
  # shellcheck disable=SC2034
  local color_warning="\x1b[33m"
  # shellcheck disable=SC2034
  local color_error="\x1b[31m"
  # shellcheck disable=SC2034
  local color_critical="\x1b[1;31m"
  # shellcheck disable=SC2034
  local color_alert="\x1b[1;33;41m"
  # shellcheck disable=SC2034
  local color_emergency="\x1b[1;4;5;33;41m"

  local colorvar="color_${log_level}"

  local color="${!colorvar:-${color_error}}"
  local color_reset="\x1b[0m"

  if [[ "${NO_COLOR:-}" = "true" ]] || [[ "${TERM:-}" != "xterm"* ]] || [[ ! -t 2 ]]; then
    if [[ "${NO_COLOR:-}" != "false" ]]; then
      # Don't use colors on pipes or non-recognized terminals
      color=""; color_reset=""
    fi
  fi

  # all remaining arguments are to be printed
 #local log_line=""

  while IFS=$'\n' read -r log_line; do
		echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" "${log_level}")${color_reset} ${log_line}" 1>&2
		echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${log_line}" >> $SETUP_LOGFILE
  done <<< "${@:-}"
}

function emergency () {                                __mylog emergency "${@}"; exit 1; }
function alert ()     { [[ "${LOG_LEVEL:-0}" -ge 1 ]] && __mylog alert "${@}"; true; }
function critical ()  { [[ "${LOG_LEVEL:-0}" -ge 2 ]] && __mylog critical "${@}"; true; }
function error ()     { [[ "${LOG_LEVEL:-0}" -ge 3 ]] && __mylog error "${@}"; true; }
function warning ()   { [[ "${LOG_LEVEL:-0}" -ge 4 ]] && __mylog warning "${@}"; true; }
function notice ()    { [[ "${LOG_LEVEL:-0}" -ge 5 ]] && __mylog notice "${@}"; true; }
function info ()      { [[ "${LOG_LEVEL:-0}" -ge 6 ]] && __mylog info "${@}"; true; }
function debug ()     { [[ "${LOG_LEVEL:-0}" -ge 7 ]] && __mylog debug "${@}"; true; }


function setup_logging() {
  local log_path="${1:-LOCAL_LOG_DIR}"
  if [[ -z "$log_path" ]]; then
    echo "Error: Log directory is not defined"
    exit 1
  fi
  if [[ ! -d "${log_path}" ]]; then
    mkdir -p "${log_path}"
    echo "+ Created log directory: ${log_path}"
  fi
}

check_path_exists() {
    [[ -e $1 ]]
}

check_file_exists() {
    [[ -f $1 ]]
}

check_file_is_symlink() {
    [[ -L $1 ]]
}


function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function confirm() {
  local question="$1"
  while true; do
    msg "$question"
    read -p "[y]es or [n]o (default: no) : " -r answer
    case "$answer" in
      y | Y | yes | YES | Yes)
        return 0
        ;;
      n | N | no | NO | No | *[[:blank:]]* | "")
        return 1
        ;;
      *)
        msg "Please answer [y]es or [n]o."
        ;;
    esac
  done
}

function create_local_directories() {
  for item in "${__local_directories[@]}"; do
    mkdir -p "${MY_LOCAL}/${item}"
  done
  mkdir -p "${GOPATH}"
  echo "Created local directories."
}

function install_system_packages() {
  echo "+ Installing system packages"
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install -y unzip git build-essential gcc make autoconf
  echo "+ Installed system packages"
}

function download_dependencies() {
  echo "+ Downloading dependencies..."
  cd "$MY_SRC" && curl -LO "${RG_DL_URL}"
  cd "$MY_SRC" && curl -LO "${FD_DL_URL}"
  cd "$MY_SRC" && curl -LO "${GOLANG_DL_URL}"
  if [[ ! -d "${MY_FZF}" ]]; then
    git clone --depth 1 "${FZF_GITHUB_URL}" "$MY_FZF"
  fi
  cd "$MY_SRC" && chmod +x *.deb
  echo "+ Download complete"
}

function install_ripgrep() {
  echo "+ Installing: ripgrep"
  cd "$MY_SRC" && sudo dpkg -i "${RG_INSTALLER_NAME}" &>/dev/null
  if [ $? -eq 0 ]
  then
    echo "+ Installed: ripgrep"
  else
    echo "+ Install failed: ripgrep"
  fi
}

function install_fd() {
  echo "+ Installing: fd"
  # sudo apt update && sudo apt install fd-find
  sudo apt remove fd-find &>/dev/null
  cd "$MY_SRC" && sudo dpkg -i "${FD_INSTALLER_NAME}" &>/dev/null
  if [ $? -eq 0 ]
  then
    echo "+ Installed: fd"
  else
    echo "+ Install failed: fd"
  fi
}

function install_fzf() {
  echo "Installing fzf..."
  # Debian >=Stretch or Ubuntu >= 19.10
  # sudo apt-get install fzf
  ~/.fzf/install
}

function golang_install() {
  echo "+ Installing: Golang ${GO_VERSION}"
  # Remove existing install
  [[ -d "${GOLANG_INSTALL_PATH}" ]] && echo "+ Removing Golang from: ${GOLANG_INSTALL_PATH}" && sleep 1 && sudo rm -vrf "${GOLANG_INSTALL_PATH}"
  # Remove existing link
  [[ -e "${SYSTEM_LOCAL_BINS}/go" ]] && echo "+ Removing from: ${SYSTEM_LOCAL_BINS}/go" && sleep 1 && sudo rm -vf "${SYSTEM_LOCAL_BINS}/go"
  
  # Confirm Golang has been downloaded.
  if [[ ! -f "${MY_SRC}/${GOLANG_ARCHIVE_NAME}" ]]; then
    echo "+ Error: Failed to located Golang archive in ${MY_SRC}"
    exit 1
  else
    echo "+ Located archive at ${MY_SRC}/${GOLANG_ARCHIVE_NAME}"
    echo "+ Extracting..."
  fi
  
  # Extract current installer
  cd "$MY_SRC" && tar -xzf "${GOLANG_ARCHIVE_NAME}" &>/dev/null
  if [ $? -eq 0 ]
  then
    echo "+ Extracted Golang"
    if [[ -d "${MY_SRC}/go" ]]; then
      echo "+ Extracted path: ${MY_SRC}/go"
      cd "${MY_SRC}" && sudo mv -v go "$SYSTEM_LOCAL"
    fi
  else
    echo "+ Error: Failed to extract Golang, something is wrong."
    exit 1
  fi
  echo "+ Verifying install"
  if [[ -d "${GOLANG_INSTALL_PATH}" ]]
  then
    echo "+ Installed to: ${GOLANG_INSTALL_PATH}"
    if [[ -e "${GOLANG_INSTALL_PATH}/bin/go" ]]; then
      echo "+ Located Golang executable: ${GOLANG_INSTALL_PATH}/bin/go"
      sudo ln "${GOLANG_INSTALL_PATH}/bin/go" "${SYSTEM_LOCAL_BINS}/go"
      echo "+ Installed link to ${SYSTEM_LOCAL_BINS}/go"
      echo "+ Installed version: $(go version)"
    else
      echo "+ Error: Failed to locate Golang executable"
      echo "+ Error: Install failed"
      exit 1
    fi
    # export PATH="${PATH}:${GOLANG_INSTALL_PATH}/bin"
    export GOPATH="${HOME}/.go"
    # export GOROOT="$(go env GOROOT)/bin"
    # export PATH="${PATH}:${GOROOT}"
    # echo "+ Updated PATH to: ${PATH}"
    # echo "Golang version check..."
    # go version
  else
    echo "+ Error: Install failed"
    exit 1
  fi
}

function update_path() {
  echo '' >> "${MY_PROFILE}"
  echo 'export GOPATH=/home/vandem/.go;' >> "${MY_PROFILE}"
  echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> "${MY_PROFILE}"
}

function golang_packages_install() {
  # go install golang.org/x/tools/gopls@latest
  # # sudo go install golang.org/x/tools/gopls@latest
  # go install "${LAZYGIT_INSTALL_NAME}"
  echo "+ Installing: Golang packages"
  for gopkg in "${__golang_installs[@]}"; do
    printf "installing %s .." "$gopkg"
    go install "${gopkg}"
    if [ $? -eq 0 ]
    then
      echo "+ Installed: ${gopkg}"
    else
      echo "+ Install Failed: ${gopkg}"
      sudo go install "${gopkg}"
    fi
  done
  echo "+ Completed Golang package installs"
}

function python_packages_install() {
    info "+ Installing: Python Packages"
    for item in "${__python_installs[@]}"; do
      printf "installing %s .." "$item"
      pip3 install --upgrade "${item}"
      if [ $? -eq 0 ]
      then
        info "+ Installed: ${item}"
      else
        error "+ Install Failed: ${item}"
      fi
    done
    info "+ Installed: Python Packages"
}

function remove_system_nvim() {
  echo "+ Removing: Neovim (system)"
  sudo apt remove -y neovim neovim-runtime python3-neovim && sudo apt autoremove
  echo "+ Removed: Neovim (system)"
}

function backup_neovim_config() {
  local nvim_config_path="${1:-NVIM_CONFIG_PATH}"
  if [[ -z "$nvim_config_path" ]]; then
    echo "Error: Neovim config path is not defined"
    exit 1
  fi
  local backup_date=$(/bin/date +"%Y-%m-%d")
  local backup_nvim_config_path="${nvim_config_path}${backup_date}"
  [[ -d "$nvim_config_path" ]] && echo "+ Moving existing Neovim config to backup directory: ${backup_nvim_config_path}" && mv -v "${nvim_config_path}" "${backup_nvim_config_path}"
}

function remove_neovim_files() {
  local nvim_share_path="${1:-NVIM_SHARE_PATH}"
  local nvim_cache_path="${2:-NVIM_CACHE_PATH}"
  if [[ -z "$nvim_share_path" ]]; then
    echo "Error: Neovim share path is not defined"
    exit 1
  fi
  if [[ -z "$nvim_cache_path" ]]; then
    echo "Error: Neovim cache path is not defined"
    exit 1
  fi
  if [[ -d "${nvim_cache_path}" ]]; then
    rm -rf "${nvim_cache_path}"
  fi
  if [[ -d "${nvim_share_path}" ]]; then
    rm -rf "${nvim_share_path}"
  fi
}

function remove_neovim_packer() {
  local packer_directory="${1:-PACKER_DST_PATH}"
  if [[ -z "$packer_directory" ]]; then
    error "Error: Packer for Neovim config path is not defined"
    exit 1
  fi
  [[ -d "$packer_directory" ]] && info "+ Removing: Packer for Neovim config" && rm -vrf "$packer_directory"
}


function install_neovim_packer() {
  local packer_base_directory="${1:-PACKER_BASE_PATH}"
  local packer_github_url="${2:-PACKER_GIT_URL}"
  if [[ -z "$packer_base_directory" ]]; then
    error "Error: Packer for Neovim install directory not defined."
    exit 1
  fi
  if [[ -z "$packer_github_url" ]]; then
    error "Error: Packer for Neovim repository URL not defined."
    exit 1
  fi
  local packer_dst_directory="${packer_base_directory}/packer.nvim"
  info "+ Installing: Packer for Neovim"
  mkdir -p "$packer_base_directory"
  info "+ Created directory: ${packer_base_directory}"
  info "+ Cloning from ${packer_github_url} to ${packer_dst_directory}"
  git clone --depth 1 "${packer_github_url}" "${packer_dst_directory}"
  if [[ ! -e "${packer_dst_directory}" ]]; then
    error "Error: Packer not installed to path"
    exit 1
  fi
  info "+ Installed: Packer for Neovim"
}


function install_neovim_lvim() {
  local lvim_install_directory="${1:-LVIM_CONFIG_PATH}"
  local lvim_github_url="${2:-LVIM_GIT_URL}"
  if [[ -z "$lvim_install_directory" ]]; then
    error "Error: LVIM install directory not defined."
    exit 1
  fi
  if [[ -z "$lvim_github_url" ]]; then
    error "Error: LVIM repository url not defined."
    exit 1
  fi
  info "+ Installing: LVIM"
  if [[ -d "${lvim_install_directory}" ]]; then
    rm -rf "${lvim_install_directory}"
    info "+ Removed existing LVIM configuration"
  fi
  git clone "${lvim_github_url}" "${lvim_install_directory}"
  if [[ ! -d "${lvim_install_directory}" ]]; then
    error "+ Failed to install LVIM"
    exit 1
  fi
  info "+ Installed: LVIM"
}


function install_lvim_as_nvim_default() {
  local lvim_install_directory="${1:-LVIM_CONFIG_PATH}"
  local nvim_config_directory="${2:-NVIM_CONFIG_PATH}"
  info "+ Configure: Neovim"
  if [[ -z "$lvim_install_directory" ]]; then
    error "Error: LVIM install directory not defined."
    exit 1
  fi
  if [[ -z "$nvim_config_directory" ]]; then
    error "Error: Neovim config directory not defined."
    exit 1
  fi
  if [[ ! -d "$lvim_install_directory" ]]; then
    error "Error: LVIM not installed to ${lvim_install_directory}"
    exit 1
  fi
  if [[ -d "$nvim_config_directory" ]]; then
    info "+ Removing existing Neovim config"
    backup_neovim_config "${nvim_config_directory}"
  fi
  ln -s "${lvim_install_directory}" "${nvim_config_directory}"
  info "+ Configured: Neovim (using LVIM)"
}

function install_python() {
  echo "+ Installing: Python"
  local local_bins_path="${1:-LOCAL_BIN_DIR}"
#   local packer_github_url="${2:-PACKER_GIT_URL}"
  if [[ -z "$local_bins_path" ]]; then
    error "Error: Local bin directory not defined."
    exit 1
  fi
  if [[ ! -d "${local_bins_path}" ]]; then
    error "Error: Local bin directory does not exist."
    exit 1
  fi
#   if [[ -z "$packer_github_url" ]]; then
#     error "Error: Packer for Neovim repository URL not defined."
#     exit 1
#   fi
  if [[ ! -e "${LOCAL_BIN_DIR}/python" ]]; then
    info "+ Linking Python"
    ln /usr/bin/python3 ~/.local/bin/python
  fi
  echo "+ Installed: Python"
}





function clean_install_nvim() {
  info "+ Installing: Neovim"
  remove_system_nvim
  backup_neovim_config "${NVIM_CONFIG_PATH}"
  remove_neovim_files "${NVIM_SHARE_PATH}" "${NVIM_CACHE_PATH}"
  remove_neovim_packer "${PACKER_BASE_PATH}"
  install_neovim_packer "${PACKER_BASE_PATH}" "${PACKER_GIT_URL}"
  info "+ Installed: Neovim"
}

function install_lunarvim() {
  echo "Installing: Lunarvim"
  bash <(curl -s "$LUNARVIM_INSTALLER_URL")
  echo "+ Installed: Lunarvim"
}


function install_lua() {
  echo "+ Installing: Lua"
  sudo apt update && sudo apt install -y luarocks && sudo apt install -y lua-yaml
  echo "+ Installed: Lua"
}


function install_lua_packages() {
  echo "+ Installing: Lua (packages)"
  luarocks install dkjson --local
  luarocks install say --local
  luarocks install checks --local
  luarocks --server=http://rocks.moonscript.org install lyaml --local
  echo "+ Installed: Lua (packages)"
}



function install_nvm() {
  echo "+ Installing: NVM"
  local local_nvm_url="${1:-NVM_INSTALLER_URL}"
  local local_nvm_install_path="${2:-NVM_INSTALL_PATH}"
  if [[ -z "$local_nvm_url" ]]; then
    error "Error: NVM installer url not provided."
    exit 1
  fi
  if [[ -z "$local_nvm_install_path" ]]; then
    error "Error: NVM install path not provided."
    exit 1
  fi
  if [[ -d "${local_nvm_install_path}" ]]; then
    info "+ NVM already installed to ${local_nvm_install_path}"
  else
    curl -o- "${local_nvm_url}" | bash
  fi
  if [[ -d "${local_nvm_install_path}" ]]; then
    info "+ NVM already installed to ${local_nvm_install_path}"
  else
    error "Error: "
  fi
  info "+ Installed: NVM"
}


function install_node() {
  echo "+ Installing: NodeJS"
  local nvm_local_script="${HOME}/.nvm/nvm.sh"
  source ~/.nvm/nvm.sh
  nvm install --lts
  echo "+ Installed: NodeJS"
}


function install_node_global_packages() {
    info "+ Installing: Node Global Packages"
    for item in "${__node_installs[@]}"; do
      printf "installing %s .." "$item"
      npm install -g "${item}"
      if [ $? -eq 0 ]
      then
        info "+ Installed: ${item}"
      else
        error "+ Install Failed: ${item}"
      fi
    done
    info "+ Installed: Node Global Packages"
}




function install_tmux() {
  echo "+ Installing: Tmux"
  echo "+ Installed: Tmux"
}



function install_tpm() {
  echo "+ Installing: tpm"
  echo "+ Installed: tpm"
}


setup_logging
echo "+ Log File: ${SETUP_LOGFILE}"

if confirm "Create local directories?"; then
  create_local_directories
fi

if confirm "Install system packages?"; then
  install_system_packages
fi

if confirm "Download dependencies?"; then
  download_dependencies
fi


if confirm "Install ripgrep?"; then
  install_ripgrep
fi

if confirm "Install fd?"; then
  install_fd
fi

if confirm "Install fzf?"; then
  install_fzf
fi

if confirm "Install golang?"; then
  golang_install
  if confirm "Update PATH in profile?"; then
    update_path
  fi
  golang_packages_install
fi

if confirm "Install Neovim?"; then
  clean_install_nvim
fi

if confirm "Install Python packages?"; then
  python_packages_install
fi



if confirm "Install LVIM?"; then
  install_neovim_lvim "${LVIM_CONFIG_PATH}" "${LVIM_GIT_URL}"
  if confirm "LVIM as Neovim configuration?"; then
    install_lvim_as_nvim_default "${LVIM_CONFIG_PATH}" "${NVIM_CONFIG_PATH}"
  fi
fi


if confirm "Install Lunarvim?"; then
  install_lunarvim
fi


exit 0


# Changing Directory On Exit
# If you change repos in lazygit and want your shell to change directory into that repo
# on exiting lazygit, add this to your ~/.zshrc (or other rc file):

# lg()
# {
#     export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

#     lazygit "$@"

#     if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
#             cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
#             rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
#     fi
# }


# Then source ~/.zshrc and from now on when you call lg and exit you'll switch
# directories to whatever you were in inside lazygit. To override this behaviour
# you can exit using shift+Q rather than just q.

# Add GOROOT to PATH
# In this instance GOROOT = ~/go therefore we add ~/go/bin
# export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin"







# alias h='function hdi(){ howdoi $* -c -n 5; }; hdi'
# alias hless='function hdi(){ howdoi $* -c | less --raw-control-chars --quit-if-one-screen --no-init; }; hdi'


# CUSTOM_NVIM_PATH=/usr/local/bin/nvim.appimage
# Set the above with the correct path, then run the rest of the commands:
# set -u
# sudo update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
# sudo update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
# sudo update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
# sudo update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
# sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110


#sudo apt-get install python-neovim python3-neovim

#nvim --listen /tmp/nvimsocket




# nvr uses /tmp/nvimsocket by default, so we're good.

# Open two files:
# nvr --remote file1 file2

# Send keys to the current buffer:
# nvr --remote-send 'iabc<esc>'
# Enter insert mode, insert 'abc', and go back to normal mode again.

# Evaluate any VimL expression, e.g. get the current buffer:
# nvr --remote-expr 'bufname("")'
# README.md
