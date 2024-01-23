#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")/../..")
. "$SETUP_ROOT/config.txt" || exit 1

PYCHARM_EXE=~/".local/share/JetBrains/Toolbox/scripts/pycharm"
if [ -x "$PYCHARM_EXE" ] || [ -x "$(which pycharm)" ]; then
  # nothing to do, pycharm is installed
  exit 0
fi

# check if we need to download jetbrains toolbox
if [ ! -x "$JETBRAINS_TOOLBOX_EXE" ]; then
  echo "downloading JetBrains toolbox"
  wget -qO- "$JETBRAINS_TOOLBOX_URL" | sudo tar -xz -C "$JETBRAINS_TOOLBOX_INSTALL_DIR"
fi

while [ ! -x "$PYCHARM_EXE" ]
do
  echo "JetBrains Toolbox will now be launched, please select PyCharm community for install."
  echo ""
  echo "Press enter to continue..."
  read -r _
  "$JETBRAINS_TOOLBOX_EXE"
done

exit 0
