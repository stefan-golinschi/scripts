#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "You must run this script as root."
    exit 1
fi

INSTALL_DIR="/usr/bin"
INSTALL_FILE="nextboot.windows"
install -m 0755 nextboot.windows "${INSTALL_DIR}/${INSTALL_FILE}"

REFIND_SCRIPT="${PWD}/linux.refind-next-boot.py"

sed -i "s+YOUR_SCRIPT_HERE+${REFIND_SCRIPT}+" "${INSTALL_DIR}/${INSTALL_FILE}"

# Test if command is available
which "${INSTALL_FILE}" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Successfully installed the script."
else
    echo "Script installation failed."
fi

# TODO: add sudoers file for this.
#
# Allow $SUDO_USER to run this command as sudo, without needing a password
# SUDOERS_FILE="/etc/sudoers.d/${INSTALL_FILE}"
# echo "$SUDO_USER ALL=(ALL) NOPASSWD: ${INSTALL_DIR}/${INSTALL_FILE}" > "${SUDOERS_FILE}"
# chmod 0440 "${SUDOERS_FILE}"
# echo "Logout and login again for sudoers update to take effect."