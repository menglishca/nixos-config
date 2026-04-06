#!/usr/bin/env bash
# 🚀 NixOS VM Disk Resize Script: Grow root + 8GB swap (live/safe w/ snapshot)
# Usage: nix-shell -p gptfdisk e2fsprogs util-linux bc parted --run "sudo bash resize-disk.sh"
# Backup: Creates pre-swap.gpt (sgdisk --load pre-swap.gpt /dev/sda to revert PT)

set -euo pipefail  # Exit on error, strict vars

DISK="${1:-/dev/sda}"
ROOT_PART=1
SWAP_PART=2
SWAP_LABEL="swap"
SWAP_GB=8
SECTOR_SIZE=512
SWAP_SECTORS=$((SWAP_GB * 1024 * 1024 * 1024 / SECTOR_SIZE))  # 16777216

echo "=== NixOS Disk Resizer: $DISK (root+$SWAP_GB GB swap) ==="
echo "Snapshot VM first! Ctrl+C to abort."

read -p "Confirm? (y/N): " -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] || exit 1

# 1. Backup GPT + swapoff
sudo sgdisk --backup=pre-swap.gpt "$DISK"
sudo swapoff -a || true
echo "✅ Swap off + GPT backup: pre-swap.gpt"

# 2. Del old swap
sudo sgdisk --delete "$SWAP_PART" "$DISK"
sudo sgdisk --resize-table "$DISK"
echo "✅ Deleted $DISK$SWAP_PART"

# 3. Compute sizes
DISK_SECT=$(sgdisk --print "$DISK" | grep "^Disk $DISK:" | sed -E 's/.*: ([0-9]+) sectors.*/\1/')
ROOT_END_SECT=$((DISK_SECT - SWAP_SECTORS))
ROOT_START_SECT=$(sgdisk --print "$DISK" | awk "/^ +$ROOT_PART +/ {print \$2; exit}")

GB_DISK=$(echo "scale=1; $DISK_SECT * $SECTOR_SIZE / 1024 / 1024 / 1024" | bc)
GB_ROOT=$(echo "scale=1; $ROOT_END_SECT * $SECTOR_SIZE / 1024 / 1024 / 1024" | bc)

echo "📏 Disk: ${GB_DISK}GB ($DISK_SECT sects)"
echo "📏 Root: start $ROOT_START_SECT → end $ROOT_END_SECT (~${GB_ROOT}GB)"
echo "📏 Swap: ${SWAP_GB}GB ($SWAP_SECTORS sects)"

# 4. Grow root: del → recreate larger (data-safe: start unchanged)
sudo sgdisk --delete "$ROOT_PART" "$DISK"
sudo sgdisk --new="$ROOT_PART":"$ROOT_START_SECT":"$ROOT_END_SECT" \
            --typecode="$ROOT_PART":8300 \
            --change-name="$ROOT_PART":"Linux filesystem" "$DISK"
echo "✅ Root partition grown"

echo "ROOT_END_SECT=$ROOT_END_SECT DISK_SECT=$DISK_SECT SWAP_START=$((ROOT_END_SECT+1))"

# Align start (MiB: +2047/2048*2048)
SWAP_START_SECT=$(((ROOT_END_SECT + 2048) / 2048 * 2048 + 2048))  # Next MiB


# 5. New swap
sudo sgdisk --new="$SWAP_PART":$((ROOT_END_SECT + 1)):$((DISK_SECT - 2048)) \
            --typecode="$SWAP_PART":8200 \
            --change-name="$SWAP_PART":"Linux swap" "$DISK"
echo "✅ New swap partition"

# 6. Refresh GPT/PT
sudo sgdisk --resize-table "$DISK"
sudo sgdisk --move-second-header "$DISK"
sudo partprobe "$DISK" || true
echo "✅ Partition table updated"

# 7. Setup swap
sudo mkswap -L "$SWAP_LABEL" "${DISK}${SWAP_PART}"
sudo swapon "/dev/disk/by-label/$SWAP_LABEL"
echo "✅ Swap: $SWAP_LABEL on"

# 8. Grow filesystem
sudo resize2fs "${DISK}${ROOT_PART}"
echo "✅ Filesystem resized"

# Verify
df -h / "${DISK}${ROOT_PART}"
free -h | grep Swap
lsblk -f "$DISK"
blkid "${DISK}${SWAP_PART}"
echo "\n🎉 DONE! Reboot + nixos-rebuild switch (regen fstab)."
echo "Revert PT: sudo sgdisk --load pre-swap.gpt $DISK && partprobe $DISK"