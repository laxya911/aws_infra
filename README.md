# AWS Infrastructure Provisioning Project

This project provides a modular Infrastructure-as-Code (IaC) solution using **Terraform** for provisioning AWS resources and **Ansible** for configuration management.

## Project Structure

The project is organized into `Terraform` (Infrastructure) and `Ansible` (Configuration).

```
d:/aws_infra/
├── Terraform/
│   ├── Modules/              # Reusable Terraform Modules
│   │   ├── networking/       # VPC, Subnets, Internet Gateways
│   │   ├── security/         # Security Groups, Key Pairs
│   │   └── compute/          # EC2 Instances
│   ├── Environments/         # Enironment-specific configurations
│   │   └── dev/              # Development Environment
│   │       ├── main.tf       # Entry point
│   │       ├── variables.tf  # Variable definitions
│   │       ├── terraform.tfvars # Variable values (customizations)
│   │       ├── backend.tf    # State management configuration
│   │       └── user_data.sh  # EC2 Bootstrap script
│   └── docs/                 # Additional documentation
└── Ansible/
    ├── inventory/            # Host inventories
    │   └── hosts.ini
    ├── roles/                # Ansible Roles (common, master, worker)
    ├── scripts/              # Helper scripts
    └── playbook.yml          # Main Playbook
```

## Getting Started

### Prerequisites
- [Terraform](https://www.terraform.io/downloads) installed.
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed.
- AWS Credentials configured (`aws configure`).

> **Check [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md) for detailed installation and setup instructions.**

### 1. Provision Infrastructure (Terraform)

1.  Navigate to the environment directory:
    ```bash
    cd Terraform/Environments/dev
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Review the execution plan:
    ```bash
    terraform plan
    ```
4.  Apply the changes:
    ```bash
    terraform apply
    ```
    *This will create the VPC, Security Groups, and EC2 instances. It will also generate an SSH key pair (default: `dev-key`) if configured.*

### 2. Configure Instances (Ansible)

1.  Update the Inventory:
    - Get the Public IPs from the Terraform output (`terraform output instance_public_ips`).
    - Edit `Ansible/inventory/hosts.ini` and replace the placeholder IPs.
    - Ensure the `ansible_ssh_private_key_file` path points to your created key (e.g., `../../Terraform/Environments/dev/ec2_key`).

2.  Run the Playbook:
    ```bash
    cd Ansible
    ansible-playbook -i inventory/hosts.ini playbook.yml
    ```

## Modules Overview

- **Networking**: Handles VPC creation or adoption of default VPC.
- **Security**: Manages Security Groups (SSH/HTTP access) and Key Pairs.
- **Compute**: Provisions EC2 instances with specified storage and tags.

## Best Practices Implemented
- **Modularity**: Resources are grouped by logical function (Networking, Security, Compute).
- **Environment Isolation**: Environments (dev, prod) are separated in the directory structure.
- **Separation of Concerns**: Infrastructure (Terraform) is distinct from Configuration (Ansible).
