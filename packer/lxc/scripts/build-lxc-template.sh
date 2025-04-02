#!/bin/bash
set -e

DISTRO="bullseye"
ARCH="amd64"
TEMPLATE_NAME="debian-${DISTRO}-custom-with-service-tools.tar.gz"
ROOTFS_DIR="/tmp/debian-lxc-rootfs"
TEMPLATE_PATH="/var/lib/vz/template/cache/${TEMPLATE_NAME}"

echo "📦 Installing build tools"
apt-get update
apt-get install -y debootstrap tar xz-utils

echo "Installing service tools"
apt update && apt install -y \
  openssh-server sudo curl wget gnupg ca-certificates \
  iproute2 locales systemd cron

echo "Enabling ssh"
systemctl enable ssh

echo "🧹 Cleaning previous builds"
rm -rf "$ROOTFS_DIR"
mkdir -p "$ROOTFS_DIR"

echo "🔨 Bootstrapping Debian rootfs"
debootstrap --arch="$ARCH" "$DISTRO" "$ROOTFS_DIR" http://deb.debian.org/debian

echo "🧾 Configuring base system"
echo "debian" > "$ROOTFS_DIR/etc/hostname"
echo "127.0.0.1 localhost" > "$ROOTFS_DIR/etc/hosts"

echo "🧼 Cleaning cache"
rm -rf "$ROOTFS_DIR/var/cache/apt/archives/*.deb"

echo "📦 Creating LXC template: $TEMPLATE_PATH"
tar --numeric-owner --xattrs -czf "$TEMPLATE_PATH" -C "$ROOTFS_DIR" .

echo "✅ Done. Template created at: $TEMPLATE_PATH"
