<#
.SYNOPSIS
    Enables TLS 1.1 and TLS 1.2 protocols on Windows VM for both client and server.

.DESCRIPTION
    Updates Windows Registry to enable TLS 1.1 and TLS 1.2 and sets them as default
    protocols for WinHTTP and .NET applications.

.NOTES
    Run this script as Administrator.
#>

Write-Host "🔧 Starting TLS configuration..."

# Registry paths for protocols
$basePath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
$tls11Path = "$basePath\TLS 1.1"
$tls12Path = "$basePath\TLS 1.2"

# Function to create client/server keys
function Enable-TLSProtocol {
    param (
        [string]$protocolPath
    )

    Write-Host "🔹 Enabling protocol at $protocolPath"

    # Client key
    if (-not (Test-Path "$protocolPath\Client")) {
        New-Item -Path "$protocolPath\Client" -Force | Out-Null
    }
    Set-ItemProperty -Path "$protocolPath\Client" -Name "Enabled" -Value 1 -Type DWord
    Set-ItemProperty -Path "$protocolPath\Client" -Name "DisabledByDefault" -Value 0 -Type DWord

    # Server key
    if (-not (Test-Path "$protocolPath\Server")) {
        New-Item -Path "$protocolPath\Server" -Force | Out-Null
    }
    Set-ItemProperty -Path "$protocolPath\Server" -Name "Enabled" -Value 1 -Type DWord
    Set-ItemProperty -Path "$protocolPath\Server" -Name "DisabledByDefault" -Value 0 -Type DWord

    Write-Host "✅ Enabled $protocolPath"
}

# Enable TLS 1.1 and 1.2
Enable-TLSProtocol -protocolPath $tls11Path
Enable-TLSProtocol -protocolPath $tls12Path

# Set .NET to use TLS 1.2 by default
$netRegPath = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"
$netRegWow64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319"

Write-Host "🔧 Configuring .NET to use TLS 1.2 by default..."

# For 64-bit .NET Framework
Set-ItemProperty -Path $netRegPath -Name "SystemDefaultTlsVersions" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $netRegPath -Name "SchUseStrongCrypto" -Value 1 -Type DWord -Force

# For 32-bit .NET Framework
Set-ItemProperty -Path $netRegWow64 -Name "SystemDefaultTlsVersions" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $netRegWow64 -Name "SchUseStrongCrypto" -Value 1 -Type DWord -Force

Write-Host "✅ .NET Framework TLS settings configured."

# Optional: restart required services or notify for reboot
Write-Host "⚠️ A reboot is recommended for all settings to take effect." -ForegroundColor Yellow

Write-Host "🎉 TLS 1.1 and TLS 1.2 are now enabled and configured!"
