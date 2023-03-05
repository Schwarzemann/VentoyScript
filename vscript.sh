#!/bin/bash

# Prompt the user for a directory to install Ventoy to
echo "Please enter the directory to install Ventoy to (default: /opt):"
read ventoy_dir

# Use the default directory if the user didn't specify one
if [ -z "$ventoy_dir" ]; then
  ventoy_dir="/opt"
fi

# Create the directory if it doesn't exist
sudo mkdir -p "$ventoy_dir"

# Get the latest Ventoy version number from the website
latest_version=$(curl -sL https://github.com/ventoy/Ventoy/releases/latest | grep -oE 'tag\/v[0-9]+\.[0-9]+\.[0-9]+' | cut -d'/' -f2)

# Download the latest Ventoy version from GitHub
wget "https://github.com/ventoy/Ventoy/releases/download/$latest_version/Ventoy-$latest_version-linux.tar.gz" -P "$ventoy_dir"

# Extract the Ventoy files from the downloaded archive
tar -xzf "$ventoy_dir/Ventoy-$latest_version-linux.tar.gz" -C "$ventoy_dir"

# Prompt the user for the USB device to install Ventoy on
echo "Please select a USB device to install Ventoy on:"
read usb_device

# Check if the specified device is a valid block device
if [ ! -b "/dev/$usb_device" ]; then
  echo "Invalid device: $usb_device is not a block device"
  exit 1
fi

# Install Ventoy on the selected USB device
sudo sh "$ventoy_dir/Ventoy2Disk.sh" -I "/dev/$usb_device"

# Remove the downloaded files to clean up after the installation is complete
sudo rm "$ventoy_dir/Ventoy-$latest_version-linux.tar.gz" "$ventoy_dir/Ventoy2Disk.sh"
