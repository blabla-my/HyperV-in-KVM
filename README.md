# HyperV-in-KVM
Run a HyperV hypervisor inside Qemu/KVM. This repo contains scripts for setting up such an environment.

(This has been verified on a ubuntu20.04 bare metal host but fails on a ubuntu20.04 ESXI host.)

Firstly, obtain a windows server 2025 ISO from microsoft, and creates Qemu disk image. 
```
./setup.sh
```

Second, launch Qemu/KVM
```
./start.sh <path to qemu-system-x86_64>
```

Then, connect the guest using VNC (at port 5900) and install windows server 2025 following the best practice. It is recommended to use RealVNC viewer because it can send ctrl+alt+del via a button. 
https://pve.proxmox.com/wiki/Windows_2025_guest_best_practices

(Note: "load driver" needs to load both virtio-scsi and virtio-net drivers, perform "load driver" twice.)

## VM admin passwd
admin@123win

## HyperV Installation
```
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
Get-WindowsFeature Hyper-V 
```

## Setup SSH server
```
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName "Allow SSH" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
ssh-keygen.exe -t rsa
```
In host, set up the key
```
cat ~/.ssh/id_rsa.pub | ssh -p 2222 Administrator@localhost "powershell -NoProfile -Command \"New-Item -ItemType Directory -Force C:\ProgramData\ssh | Out-Null; Add-Content -Path C:\ProgramData\ssh\administrators_authorized_keys -Value ([Console]::In.ReadToEnd())\""
```

Then, we can connect the windows guest via ssh:
```
ssh -p2222 Administrator@localhost
```
The default shell is cmd, run `powershell` before executing any commands.

## HyperV Network Setup
setup_hyperV_network.ps1
```
New-VMSwitch -Name "SWITCH" -SwitchType Internal
New-NetIPAddress `
  -InterfaceAlias "vEthernet (SWITCH)" `
  -IPAddress 192.168.100.1 `
  -PrefixLength 24
New-NetNat `
  -Name "HyperVNAT" `
  -InternalIPInterfaceAddressPrefix 192.168.100.0/24
```


## Get HyperV Management Scripts
setup_vm_scripts.sh (on Host)
```
wget https://github.com/fdcastel/Hyper-V-Automation/archive/refs/heads/master.zip -O Hyper-V-Automation.zip
scp -P2222 Hyper-V-Automation.zip Administrator@localhost:/C:/Users/Administrator/
wget https://github.com/fdcastel/qemu-img-windows-x64/releases/download/v10.0.0/qemu-img-windows-x64-v10.0.0.zip -O qemu-img.zip
scp -P2222 qemu-img.zip Administrator@localhost:/C:/Users/Administrator/
ssh -p 2222 Administrator@localhost "powershell -NoProfile -Command \"Expand-Archive -Path .\Hyper-V-Automation.zip -DestinationPath . -Force\""
```

## Create VM (ubuntu or debian)
In windows guest, run one of the following scritps:
```
./setup_debian_vm.ps1
```

Re-configure the CPU number:
```
Stop-VM -Name "TstDebian" -Force
Set-VMProcessor -VMName "TstDebian" -Count 1
```

Re-launch the VM
```
Start-VM -Name "TstDebian"
ssh debian@192.168.100.10
```

## Get HyperV symbols
install debug utils `setup_dbg.ps1`
restart the machine, then
```
$DbgPath = "${env:ProgramFiles(x86)}\Windows Kits\10\Debuggers\x64"
& "$DbgPath\kd.exe" -kl

lkd> .symfix C:\Symbols
lkd> .sympath srv*C:\Symbols*https://msdl.microsoft.com/download/symbols
lkd> !sym noisy
lkd> .reload /f 
```

## Enumerate HyperV VMBus devices in L2 guest
HyperV's virtual devices are not on pci bus, instead, they are on VMBus.
Download `lsvmbus` util from linux kernel in L2:
```
wget https://raw.githubusercontent.com/torvalds/linux/refs/heads/master/tools/hv/lsvmbus
```
Then
```
debian@test:~$ ./lsvmbus
VMBUS ID  1: [Dynamic Memory]
VMBUS ID  2: [Reserved system device]
VMBUS ID  3: Synthetic mouse
VMBUS ID  4: Synthetic keyboard
VMBUS ID  5: Synthetic framebuffer adapter
VMBUS ID  6: [Reserved system device]
VMBUS ID  7: [Guest services]
VMBUS ID  8: [Heartbeat]
VMBUS ID  9: [Data Exchange]
VMBUS ID 10: [Operating system shutdown]
VMBUS ID 11: [Time Synchronization]
VMBUS ID 12: [Backup (volume checkpoint)]
VMBUS ID 13: [Reserved system device]
VMBUS ID 14: Synthetic SCSI Controller
VMBUS ID 15: Synthetic network adapter
```
