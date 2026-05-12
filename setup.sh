#!/bin/bash
# wget -O virtio-win.iso 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.215-1/virtio-win-0.1.215.iso'
qemu-img create -f qcow2 win_hdd.qcow2 128G

