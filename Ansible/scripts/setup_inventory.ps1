# setup_inventory.ps1
$tfStatePath = "..\Terraform\Environments\dev\terraform.tfstate"
$inventoryPath = ".\inventory.ini"
$templatePath = ".\files\inventory.ini"

# Check if Terraform state exists
if (!(Test-Path $tfStatePath)) {
    Write-Error "Terraform state file not found at $tfStatePath"
    exit 1
}

# Read Terraform Output (assuming we can read the json file directly or use terraform output)
# Using direct JSON parsing to avoid terraform binary dependency if not in path
$json = Get-Content $tfStatePath | ConvertFrom-Json
$outputs = $json.outputs

if (!$outputs.instance_ips) {
    Write-Host "No instance_ips output found. Make sure Terraform has run."
    exit
}

$ips = $outputs.instance_ips.value
$masterIp = $ips.master
$worker1Ip = $ips."worker-1"
$worker2Ip = $ips."worker-2"

Write-Host "Found IPs - Master: $masterIp, Worker1: $worker1Ip, Worker2: $worker2Ip"

# Read Template
$content = Get-Content $templatePath

# Replace Placeholders (Simple logic for now, can be improved)
$newContent = @()
$masterSet = $false
$workerSet = $false

foreach ($line in $content) {
    if ($line -match "\[master\]") {
        $newContent += $line
        if ($masterIp) {
            $newContent += "$masterIp ansible_user=ubuntu ansible_ssh_private_key_file=..\..\secrets\ec2_key"
        }
        $masterSet = $true
        continue
    }
    
    if ($line -match "\[worker\]") {
        $newContent += $line
        if ($worker1Ip) {
            $newContent += "$worker1Ip ansible_user=ubuntu ansible_ssh_private_key_file=..\..\secrets\ec2_key node_role=general"
        }
        if ($worker2Ip) {
             $newContent += "$worker2Ip ansible_user=ubuntu ansible_ssh_private_key_file=..\..\secrets\ec2_key node_role=monitoring"
        }
        $workerSet = $true
        continue
    }
    
    # Skip template comments
    if ($line -match "^#") { continue }
    
    $newContent += $line
}

$newContent | Set-Content $inventoryPath
Write-Host "Inventory updated at $inventoryPath"
