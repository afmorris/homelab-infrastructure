#!/usr/bin/env bash
# Creates an Ubuntu 24.04 LTS cloud-init template on Proxmox.
# Run directly on the Proxmox host (metal).
#
# Usage: bash create-ubuntu-template.sh

set -euo pipefail

# ---------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------
TEMPLATE_ID=9000
TEMPLATE_NAME="ubuntu-2404-cloud-init"
STORAGE="proxmox"
IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMAGE_FILE="/tmp/noble-server-cloudimg-amd64.img"
MEMORY=2048
CORES=2
BRIDGE="vmbr0"
DISK_SIZE="20G"

# ---------------------------------------------------------------
# Download cloud image
# ---------------------------------------------------------------
if [[ ! -f "$IMAGE_FILE" ]]; then
  echo "Downloading Ubuntu 24.04 cloud image..."
  wget -O "$IMAGE_FILE" "$IMAGE_URL"
else
  echo "Image already present at $IMAGE_FILE, skipping download."
fi

# ---------------------------------------------------------------
# Create base VM
# ---------------------------------------------------------------
echo "Creating VM $TEMPLATE_ID ($TEMPLATE_NAME)..."
qm create "$TEMPLATE_ID" \
  --name "$TEMPLATE_NAME" \
  --memory "$MEMORY" \
  --cores "$CORES" \
  --net0 virtio,bridge="$BRIDGE" \
  --ostype l26 \
  --agent enabled=1

# ---------------------------------------------------------------
# Import and attach disk
# ---------------------------------------------------------------
echo "Importing disk to $STORAGE..."
IMPORT_OUT=$(qm importdisk "$TEMPLATE_ID" "$IMAGE_FILE" "$STORAGE" 2>&1)
echo "$IMPORT_OUT"
VOLUME=$(echo "$IMPORT_OUT" | grep -oP "(?<=')[^']+(?=')" | tail -1)

echo "Attaching disk ($VOLUME)..."
qm set "$TEMPLATE_ID" \
  --scsihw virtio-scsi-pci \
  --scsi0 "$VOLUME"

echo "Resizing disk to $DISK_SIZE..."
qm resize "$TEMPLATE_ID" scsi0 "$DISK_SIZE"

# ---------------------------------------------------------------
# Cloud-init drive and boot config
# ---------------------------------------------------------------
echo "Configuring cloud-init and boot..."
qm set "$TEMPLATE_ID" \
  --ide2 "$STORAGE:cloudinit" \
  --boot order=scsi0 \
  --serial0 socket \
  --vga serial0 \
  --ciuser ubuntu \
  --ipconfig0 ip=dhcp \
  --cicustom "vendor=proxmox:snippets/vendor.yaml"

# Install qemu-guest-agent on first boot via vendor cloud-init data
mkdir -p /mnt/pve/proxmox/snippets
cat > /mnt/pve/proxmox/snippets/vendor.yaml <<'EOF'
#cloud-config
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
EOF

# ---------------------------------------------------------------
# Convert to template
# ---------------------------------------------------------------
echo "Converting to template..."
qm template "$TEMPLATE_ID"

echo ""
echo "Template $TEMPLATE_ID ($TEMPLATE_NAME) created successfully."
echo "SSH keys and IP config will be set at clone time via Terraform."
