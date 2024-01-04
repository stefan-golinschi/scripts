import re
import subprocess
import os
import argparse
import sys
import utils

# Defaults
default_output_location = "output.reg.temp"


def parse_registry_file() -> dict:
    ret_dict = {}

    with open(default_output_location, 'r') as file:
        lines = file.readlines()

    mac_pattern = re.compile(r'"([0-9a-fA-F]+)"=hex:([0-9a-fA-F,]+)')

    for line in lines:
        match = mac_pattern.search(line)
        if match:
            mac_address = match.group(1)
            mac_address = utils.hex_to_colon(mac_address)
            mac_address = mac_address.upper()
            hex_values = match.group(2)
            hex_values = hex_values.replace(",", "")
            hex_values = hex_values.upper()

            ret_dict[mac_address] = hex_values

    return ret_dict


def save_registry_keys(system_hive: str, bt_adapter_col: str):
    bt_adapter_col = bt_adapter_col.lower()
    bt_adapter_hex = bt_adapter_col.replace(":", "")
    registry_path = f"ControlSet001\\Services\\BTHPORT\\Parameters\\Keys\\{
        bt_adapter_hex}"

    # check if system_hive exists
    if not os.path.exists(system_hive):
        print("Error! Hivefile does not exist. Maybe you forgot to mount the Windows Filesystem.")
        print(system_hive)
        sys.exit(1)

    cmd = subprocess.run(["/usr/bin/reged",
                          "-x",
                          system_hive,
                          "HKEY_LOCAL_MACHINE\\SYSTEM",
                          registry_path, default_output_location])


def update_localkeys_info(keystore: dict, bt_adapter_col: str):
    bluetooth_path = "/var/lib/bluetooth"
    print("")
    for item in keystore:

        device_path = os.path.join(
            bluetooth_path, bt_adapter_col, item, 'info')

        if not os.path.exists(device_path):
            continue

        # Replace existing devices' key
        print(f"You need to update: {device_path} Key={keystore[item]}")


def main():
    parser = argparse.ArgumentParser(
        description="Get bluetooth keys from Windows registry")
    parser.add_argument(
        "hive_file", help="Hive filepath. Example: /mnt/windows_c_drive/Windows/System32/config/SYSTEM"
    )
    parser.add_argument(
        "mac_address", help="Input MAC address of the bluetooth adapter. Example: 00:01:02:03:04")

    args = parser.parse_args()

    save_registry_keys(
        system_hive=args.hive_file, bt_adapter_col=args.mac_address)
    results = parse_registry_file()
    utils.pretty_print(results)

    update_localkeys_info(results, args.mac_address)

    # Cleanup
    os.remove(default_output_location)


if __name__ == "__main__":
    main()
