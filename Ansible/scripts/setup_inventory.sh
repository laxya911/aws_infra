#!/bin/bash
# setup_inventory.sh
# Updates inventory.ini with IPs from Terraform state

TF_STATE_PATH="../../Terraform/Environments/dev/terraform.tfstate"
INVENTORY_PATH="../inventory/hosts.ini"
TEMPLATE_PATH="../inventory/hosts.ini" # In this setup, we might edit in place or use a template. 
# However, to match the powershell logic which reads a template, let's assume we want to preserve the structure.
# But wait, I see the previous step moved inventory.ini to hosts.ini.
# Use a temporary file approach to be safe or sed in place if simple.
# The PowerShell script read a clean template 'files/inventory.ini'. 
# I should probably ensure a template exists or just use a sed replacement on the active file if it has placeholders.
# Let's assume we stick to the PowerShell logic: Read State -> Update Inventory file.

# Check dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq (e.g., sudo apt install jq)"
    exit 1
fi

if [ ! -f "$TF_STATE_PATH" ]; then
    echo "Error: Terraform state file not found at $TF_STATE_PATH"
    exit 1
fi

# Extract IPs using jq
# The structure is outputs.instance_public_ips.value which is a map
MASTER_IP=$(jq -r '.outputs.instance_public_ips.value.master // empty' "$TF_STATE_PATH")
WORKER1_IP=$(jq -r '.outputs.instance_public_ips.value["worker-1"] // empty' "$TF_STATE_PATH")
WORKER2_IP=$(jq -r '.outputs.instance_public_ips.value["worker-2"] // empty' "$TF_STATE_PATH")

if [ -z "$MASTER_IP" ] && [ -z "$WORKER1_IP" ]; then
    echo "No IPs found in Terraform state. Has terraform apply been run?"
    exit 1
fi

echo "Found IPs - Master: $MASTER_IP, Worker1: $WORKER1_IP, Worker2: $WORKER2_IP"

# We will use a sed-based approach to replace placeholders or regex matches in the hosts.ini file.
# Assuming the hosts.ini has sections [master] and [worker]

# Create a backup
cp "$INVENTORY_PATH" "${INVENTORY_PATH}.bak"

# Function to update or append host
# Since the format dictates explicit lines, we might just rewrite the file based on known structure
# OR simplified: Just clear the file and write it fresh? 
# The PowerShell script logic was: Read template -> Replace placeholders -> Write.
# I don't have the template "files/inventory.ini" anymore (I deleted it in step 74).
# But wait, looking at my history, I deleted 'Ansible/files/inventory.ini'.
# The user's PowerShell script referred to '.\files\inventory.ini'.
# I should probably recreate a template or just write the content from scratch since I know the structure.
# Writing from scratch is safer than complex sed if we know the target structure.

KEY_FILE="../../Terraform/Environments/dev/ec2_key"

cat > "$INVENTORY_PATH" <<EOF
[master]
$MASTER_IP ansible_user=ubuntu ansible_ssh_private_key_file=$KEY_FILE

[worker]
$WORKER1_IP ansible_user=ubuntu ansible_ssh_private_key_file=$KEY_FILE node_role=general
$WORKER2_IP ansible_user=ubuntu ansible_ssh_private_key_file=$KEY_FILE node_role=monitoring

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3
EOF

echo "Inventory updated at $INVENTORY_PATH"
