# HyperV-in-KVM
Run a HyperV hypervisor inside Qemu/KVM. This repo contains scripts for setting up such an environment.

## VM admin passwd
admin@123win

## Setup SSH server
```
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName "Allow SSH" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

## HyperV Installation
```
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
Get-WindowsFeature Hyper-V 
```

## Get HyperV Management Scripts
(In host) 
```
wget https://github.com/fdcastel/Hyper-V-Automation/archive/refs/heads/master.zip
scp -P2222 master.zip Administrator@localhost:/C:/Users/Administrator/Downloads
wget https://qemu.weilnetz.de/w64/2025/qemu-w64-setup-20250422.exe 
scp -P2222 qemu-w64-setup-20250422.exe Administrator@localhost:/C:/Users/Administrator/Downloads
```
(In guest)
```
Expand-Archive -Path .\Downloads\master.zip -DestinationPath Hyper-V-Automation
# in vnc , install qemu-img
cd Downloads
.\qemu-w64-setup-20250422.exe

cd ..
cd .\Hyper-V-Automation\Hyper-V-Automation-master\
$env:Path += ";C:\Program Files\qemu"

$imgFile = .\Get-UbuntuImage.ps1 -Verbose
$vmName = 'TstUbuntu'
$fqdn = 'test.example.com'
$rootPublicKey = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"

.\New-VMFromUbuntuImage.ps1 `
    -SourcePath $imgFile `
    -VMName $vmName `
    -FQDN $fqdn `
    -RootPublicKey $rootPublicKey `
    -VHDXSizeBytes 20GB `
    -MemoryStartupBytes 2GB `
    -ProcessorCount 2 `
    -IPAddress 10.10.1.196/16 `
    -Gateway 10.10.1.250 `
    -DnsAddresses '8.8.8.8','8.8.4.4' `
    -Verbose

# Your public key is installed. This should not ask you for a password.
ssh ubuntu@10.10.1.196
```

可能需要的步骤：修改语言
```
DISM /Online /Add-Capability /CapabilityName:Language.Basic~~~en-US~0.0.1.0
Set-WinSystemLocale en-US
Set-Culture en-US
Set-WinUILanguageOverride en-US
Set-WinUserLanguageList en-US -Force
Set-WinHomeLocation -GeoId 244
```
可能需要的步骤：创建交换机
```
# 如果为空那么需要
Get-VMSwitch 
Get-NetAdapter

Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
----                      --------------------                    ------- ------       ----------             ---------
以太网                    Intel(R) 82574L Gigabit Network Conn...       4 Up           52-54-00-12-34-56         1 Gbps

New-VMSwitch -Name "SWITCH" -NetAdapterName "以太网" -AllowManagementOS $true
```

