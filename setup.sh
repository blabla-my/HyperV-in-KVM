#!/bin/bash
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.285-1/virtio-win-0.1.285.iso -O virtio-win.iso
wget https://go.microsoft.com/fwlink/\?linkid\=2345730\&clcid\=0x409\&culture\=en-us\&country\=us -O winserver2025.iso
qemu-img create -f qcow2 win_hdd.qcow2 128G

