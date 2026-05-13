QEMU=$1
ISO=$2

$QEMU -machine q35 -accel kvm,kernel-irqchip=split -m 4G \
  -cpu host,-pku,-xsaves,-kvmclock,-kvm-pv-unhalt,-hle,-rtm,-waitpkg \
  -smp 4 \
  -netdev user,id=u1,hostfwd=tcp::2222-:22,hostfwd=tcp::3333-:2222,hostfwd=tcp::5920-:5910,hostfwd=tcp::55555-:55555 \
  -device virtio-net-pci,netdev=u1 \
  -serial stdio \
  -device virtio-scsi-pci,id=scsi0 \
  -drive file=win_hdd.qcow2,format=qcow2,if=none,id=hd0 \
  -device scsi-hd,drive=hd0,bus=scsi0.0 \
  -device ich9-ahci,id=sata \
  -drive file=winserver2025.iso,media=cdrom,if=none,id=cd0 \
  -device ide-cd,drive=cd0,bus=sata.0,bootindex=1 \
  -drive file=virtio-win.iso,media=cdrom,if=none,id=virtiocd \
  -device ide-cd,drive=virtiocd,bus=sata.1 \
  -boot order=d \
  -monitor telnet:127.0.0.1:55556,server,nowait \
  -vnc :0
