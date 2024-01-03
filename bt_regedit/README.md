# Bluetooth Registry Key Extractor

This Python script extracts Bluetooth keys from the Windows registry based on the specified MAC address of the Bluetooth adapter.

## Usage

### Prerequisites

- Python 3.x
- Windows SYSTEM hive file (e.g., `/mnt/windows_c_drive/Windows/System32/config/SYSTEM`)

### Example Usage

```bash
python get_keys.py /mnt/windows_c_drive/Windows/System32/config/SYSTEM 01:02:03:04:05:06

[11:22:33:44:55]: Key= aabbccddeeff00112233445566778899
[aa:bb:cc:dd:ee]: Key= 112233445566778899aabbccddeeff00
[77:88:99:aa:bb]: Key= 00112233445566778899aabbccddeeff
[aa:11:bb:22:cc]: Key= 2233445566778899aabbccddeeff0011
[12:34:56:78:90]: Key= 8899aabbccddeeff0011223344556677
```