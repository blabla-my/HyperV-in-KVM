# HyperV-in-KVM
Run a HyperV hypervisor inside Qemu/KVM. This repo contains scripts for setting up such an environment.

## VM admin passwd
admin@123win

## Setup SSH server
```
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

## HyperV Installation
```
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
Get-WindowsFeature Hyper-V 
```

## Set up a ubuntu guest
https://ubuntu.com/server/docs/how-to/virtualisation/ubuntu-on-hyper-v

