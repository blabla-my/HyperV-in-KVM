QEMU=$1
ISO=$2

$QEMU -machine q35 -accel kvm,kernel-irqchip=split -m 16G \
  -cpu host,-pku,-xsaves,-kvmclock,-kvm-pv-unhalt,-hle,-rtm,-waitpkg \
  -smp 12 \
  -netdev user,id=u1,hostfwd=tcp::2222-:22,hostfwd=tcp::3333-:2222,hostfwd=tcp::5920-:5910,hostfwd=tcp::55555-:55555 \
  -device e1000e,netdev=u1 \
  -serial stdio \
  -device ich9-ahci,id=sata \
  -drive file=win_hdd.qcow2,format=qcow2,if=none,id=hd0 \
  -device ide-hd,drive=hd0,bus=sata.0 \
  -drive file=$ISO,media=cdrom,if=none,id=cd0 \
  -device ide-cd,drive=cd0,bus=sata.1 \
  -boot order=d \
  -monitor telnet:127.0.0.1:55556,server,nowait \
  -vnc :0
