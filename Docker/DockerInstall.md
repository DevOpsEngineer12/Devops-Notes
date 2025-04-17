<#
.SYNOPSIS
    Installs Docker on Windows Server (2016/2019/2022) and validates installation.

.DESCRIPTION
    This script installs Docker using the DockerMsftProvider and ensures all prerequisites are met.
    It also validates the installation by running a test container.

.NOTES
    Run this script as Administrator.
#>

Write-Host "🔧 Starting Docker installation process..." -ForegroundColor Cyan

# ------------------------ STEP 1: Check OS Version ------------------------
Write-Host "🔹 Checking OS version compatibility..."
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
if ($osVersion -lt "10.0.14393") {
    Write-Error "❌ This script supports Windows Server 2016/2019/2022 or higher."
    exit 1
}
Write-Host "✅ OS version is compatible: $osVersion"

# ------------------------ STEP 2: Check and Enable Features ------------------------
Write-Host "🔹 Checking required Windows features..."

$features = @("Containers", "Hyper-V")
foreach ($feature in $features) {
    if (-not (Get-WindowsFeature -Name $feature).Installed) {
        Write-Host "📦 Enabling feature: $feature"
        Install-WindowsFeature -Name $feature -IncludeAllSubFeature -Restart:$false
    } else {
        Write-Host "✅ Feature already enabled: $feature"
    }
}

# ------------------------ STEP 3: Install Docker Provider ------------------------
Write-Host "🔹 Installing DockerMsftProvider..."
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force -ErrorAction Stop

# ------------------------ STEP 4: Install Docker ------------------------
Write-Host "🔹 Installing Docker..."
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -ErrorAction Stop

# ------------------------ STEP 5: Start Docker Service ------------------------
Write-Host "🔹 Starting Docker service..."
Start-Service docker
Set-Service docker -StartupType Automatic

# ------------------------ STEP 6: Validate Installation ------------------------
Write-Host "🔍 Validating Docker installation..."
docker version
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Docker did not install correctly."
    exit 1
}

Write-Host "✅ Docker installed successfully!" -ForegroundColor Green

# ------------------------ STEP 7: Run Test Container ------------------------
Write-Host "🐳 Running hello-world container for validation..."
docker run hello-world:nanoserver

if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 Docker is working correctly on your Windows VM!" -ForegroundColor Green
} else {
    Write-Error "❌ Docker test container failed. Please check Docker service logs."
}

# ------------------------ DONE ------------------------
Write-Host "🚀 Docker setup complete!" -ForegroundColor Cyan


# 🔍 What the Script Does
## Step	Description
- Checks if Windows Server version is supported
- Ensures Containers and Hyper-V features are enabled
- Installs DockerMsftProvider for Docker package installation
- Installs Docker and sets it to start automatically
- Verifies Docker by checking version and running a test container
