$ErrorActionPreference = 'Stop'

$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $admin) {
    Start-Process powershell.exe -Verb RunAs -Wait -ArgumentList @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', ('"{0}"' -f $PSCommandPath)
    )
    exit $LASTEXITCODE
}

$der = [Convert]::FromBase64String((@'
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
'@) -replace '\s')
$certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new($der)
if ($certificate.Thumbprint -ne '1ECF5FF1ECB66B611F7ECADAB6EA979C02E224C6') {
    throw "Unexpected certificate fingerprint: $($certificate.Thumbprint)"
}

$store = [Security.Cryptography.X509Certificates.X509Store]::new('Root', 'LocalMachine')
try {
    $store.Open('ReadWrite')
    $store.Add($certificate)
} finally {
    $store.Close()
}

Write-Host 'Netspark certificate installed. Restart Chrome.' -ForegroundColor Green
Read-Host 'Press Enter to close'
