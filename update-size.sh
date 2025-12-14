#!/usr/bin/env bash

DISK="${1:-/dev/sda}"
SWAP_PART=2
ROOT_PART=1
SWAP_LABEL="swap"
SWAP_GB=8
SWAP_MiB=$((SWAP_GB * 1024))
DISK_BYTES=$(blockdev --getsize64 "${DISK}")
DISK_MiB=$(echo "scale=0; ${DISK_BYTES} / 1024 / 1024" | bc)
DISK_GB=$(echo "scale=1; ${DISK_MiB} / 1024" | bc)
ROOT_END_MiB=$((DISK_MiB - SWAP_MiB))
ROOT_END_GB=$(echo "scale=1; ${ROOT_END_MiB} / 1024" | bc)
SWAP_START_GB=$(echo "${ROOT_END_GB} + 0.01" | bc)

echo "Probed: Disk (${DISK}) ~${DISK_GB}GB (${DISK_MiB}MiB) (${DISK_BYTES}bytes)"
echo "Root end: ${ROOT_END_GB}GB (${ROOT_END_MiB}MiB)"
echo "Swap start: ${SWAP_START_GB}GB"

#swapoff -a || true
#parted -s ${DISK} -f print || true
#parted -s ${DISK} rm ${SWAP_PART}

rm /tmp/resizepart.exp
cat > /tmp/resizepart.exp << EOF
#!/usr/bin/expect -f
set timeout 10
spawn parted ${DISK} resizepart ${ROOT_PART} ${ROOT_END_MiB}MiB

expect {
  "Fix/Ignore?" { send "Fix\r"; exp_continue }
  "Partition number?" { send "${ROOT_PART}\r"; exp_continue }
  "OK/Cancel?" { send "OK\r"; exp_continue }
  -re "Yes/No\\?" { send "Yes\r"; exp_continue }
  -re "End\\?.*\\?" {
    send "${ROOT_END_MiB}MiB\r"
    expect eof
  }
  timeout { exit 1 }
}
EOF

chmod +x /tmp/resizepart.exp
#expect /tmp/resizepart.exp
rm /tmp/resizepart.exp



parted -s ${DISK} mkpart primary linux-swap "${SWAP_START_GB}GB" 100%
#mkswap -L "${SWAP_LABEL}" "${DISK}${SWAP_PART}"
#swapon "/dev/disk/by-label/${SWAP_LABEL}"
#resize2fs "${DISK}${ROOT_PART}"
