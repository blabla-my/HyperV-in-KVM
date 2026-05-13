#!/bin/bash
wget https://github.com/fdcastel/Hyper-V-Automation/archive/refs/heads/master.zip -O Hyper-V-Automation.zip
scp -P2222 Hyper-V-Automation.zip Administrator@localhost:/C:/Users/Administrator/
wget https://github.com/fdcastel/qemu-img-windows-x64/releases/download/v10.0.0/qemu-img-windows-x64-v10.0.0.zip -O qemu-img.zip
scp -P2222 qemu-img.zip Administrator@localhost:/C:/Users/Administrator/
ssh -p 2222 Administrator@localhost "powershell -NoProfile -Command \"Expand-Archive -Path .\Hyper-V-Automation.zip -DestinationPath . -Force\""

scp -P2222 setup_debian_vm.ps1 setup_ubuntu_vm.ps1 Administrator@localhost:/C:/Users/Administrator/
