# Getting Started with AWS Infrastructure

This guide covers the complete workflow: installing tools, setting up AWS credentials, provisioning infrastructure with Terraform, and configuring servers with Ansible.

## 1. Installation

### 1.1 Install Terraform
Terraform is used to provision the infrastructure (VPC, EC2, etc.).

**Windows (PowerShell)**:
1. Download from [terraform.io/downloads](https://www.terraform.io/downloads).
2. Extract `terraform.exe` to a folder (e.g., `C:\Apps\Terraform`).
3. Add that folder to your System PATH environment variable.
4. Verify: `terraform version`

**Linux (Ubuntu/Debian)**:
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**macOS**:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### 1.2 Install Ansible
Ansible is used to configure the servers (install Jenkins, Nginx, etc.). Note: Ansible **does not run natively on Windows**. Windows users should use WSL2 (Windows Subsystem for Linux).

**Linux / WSL2 (Ubuntu)**:
```bash
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
```

### 1.3 Install AWS CLI
Required for Terraform to authenticate with AWS.
- **Windows**: Download [AWS CLI Installer](https://aws.amazon.com/cli/).
- **Linux**: `sudo apt install awscli`

Configure your credentials:
```bash
aws configure
# Enter Access Key, Secret Key, Region (e.g., us-east-1), and Output format (json)
```

---

## 2. Usage Guide

### 2.1 Provisioning (Terraform)

1.  **Navigate** to the environment directory:
    ```bash
    cd Terraform/Environments/dev
    ```

2.  **Initialize** the project (downloads providers):
    ```bash
    terraform init
    ```

3.  **Plan** the deployment (preview changes):
    ```bash
    terraform plan
    ```

4.  **Apply** the changes (create resources):
    ```bash
    terraform apply
    # Type 'yes' to confirm
    ```
    *Output*: Note the `instance_public_ips` displayed at the end.

### 2.2 Configuration (Ansible)

Once the instances are running, we need to update the Ansible inventory with the new IP addresses.

1.  **Update Inventory**:
    *   **Windows**: Run the helper script:
        ```powershell
        ./Ansible/scripts/setup_inventory.ps1
        ```
    *   **Linux/Mac**: Run the bash script:
        ```bash
        chmod +x ./Ansible/scripts/setup_inventory.sh
        ./Ansible/scripts/setup_inventory.sh
        ```
    *   *Manual Method*: Edit `Ansible/inventory/hosts.ini` and paste the IPs from the Terraform output.

2.  **Run Playbook**:
    ```bash
    cd Ansible
    ansible-playbook -i inventory/hosts.ini playbook.yml
    ```

This will connect to your new EC2 instances and configure them based on the defined roles.

---

## 3. Directory Structure

-   `Terraform/Modules`: Reusable infrastructure blocks (Networking, Compute, Security).
-   `Terraform/Environments/dev`: Your active Development environment.
-   `Ansible/roles`: Configuration logic (Master, Worker, Common).

## 4. Cleaning Up

To destroy the infrastructure and stop paying for resources:
```bash
cd Terraform/Environments/dev
terraform destroy
```
