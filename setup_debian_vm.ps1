New-VMSwitch -Name "SWITCH" -SwitchType Internal
New-NetIPAddress `
  -InterfaceAlias "vEthernet (SWITCH)" `
  -IPAddress 192.168.100.1 `
  -PrefixLength 24
New-NetNat `
  -Name "HyperVNAT" `
  -InternalIPInterfaceAddressPrefix 192.168.100.0/24

ssh-keygen.exe -t rsa
$env:Path += ";C:\qemu"

cd C:\Users\Administrator\Hyper-V-Automation-master

$imgFile = .\Get-DebianImage.ps1 -Verbose
$vmName = 'TstDebian'
$fqdn = 'test.example.com'
$rootPublicKey = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"

.\New-VMFromDebianImage.ps1 `
    -SourcePath $imgFile `
    -VMName $vmName `
    -FQDN $fqdn `
    -RootPublicKey $rootPublicKey `
    -VHDXSizeBytes 20GB `
    -MemoryStartupBytes 2GB `
    -ProcessorCount 2 `
    -IPAddress 192.168.100.10/24 `
    -Gateway 192.168.100.1 `
    -DnsAddresses '8.8.8.8','8.8.4.4' `
    -Verbose
