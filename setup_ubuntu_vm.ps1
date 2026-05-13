$env:Path += ";C:\qemu"

cd C:\Users\Administrator\Hyper-V-Automation-master

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
    -IPAddress 192.168.100.20/24 `
    -Gateway 192.168.100.1 `
    -DnsAddresses '8.8.8.8','8.8.4.4' `
    -Verbose

ssh ubuntu@192.168.100.20
