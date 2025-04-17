<#
.SYNOPSIS
    Installs and configures Log Analytics (MMA) agent on a Windows VM.

.DESCRIPTION
    Downloads the agent installer, installs it silently, and connects the agent to a specified Azure Log Analytics workspace.

.NOTES
    - Must be run as Administrator.
    - Requires Internet access.
    - Replace WORKSPACE_ID and PRIMARY_KEY with your Log Analytics values.
#>

# ------------------------ VARIABLES ------------------------

$workspaceId = "<YOUR_WORKSPACE_ID>"
$workspaceKey = "<YOUR_PRIMARY_KEY>"  # Primary key from Log Analytics workspace
$agentDownloadUrl = "https://go.microsoft.com/fwlink/?LinkID=828603"  # Windows 64-bit MMA agent
$installerFile = "$env:TEMP\MMASetup.exe"

# ------------------------ STEP 1: DOWNLOAD AGENT ------------------------

Write-Host "🔄 Downloading Log Analytics Agent..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $agentDownloadUrl -OutFile $installerFile -UseBasicParsing

if (-not (Test-Path $installerFile)) {
    Write-Error "❌ Failed to download the MMA installer. Check internet connection or URL."
    exit 1
}
Write-Host "✅ Agent downloaded to $installerFile"

# ------------------------ STEP 2: INSTALL AGENT ------------------------

Write-Host "🛠 Installing agent silently..." -ForegroundColor Cyan
$installArgs = "/c:""setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=$workspaceId OPINSIGHTS_WORKSPACE_KEY=$workspaceKey AcceptEndUserLicenseAgreement=1"""

Start-Process -FilePath "cmd.exe" -ArgumentList $installArgs -Wait -NoNewWindow

# ------------------------ STEP 3: VERIFY INSTALLATION ------------------------

Start-Sleep -Seconds 10

$mmaAgentPath = "HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Setup"
if (Test-Path $mmaAgentPath) {
    Write-Host "✅ Log Analytics agent installed successfully!" -ForegroundColor Green
} else {
    Write-Error "❌ Agent installation failed. Registry key not found."
    exit 1
}

# ------------------------ STEP 4: VALIDATE CONNECTIVITY ------------------------

Write-Host "🔍 Checking if agent is connected to workspace..."

$healthService = Get-Service -Name HealthService -ErrorAction SilentlyContinue
if ($healthService -and $healthService.Status -eq "Running") {
    Write-Host "🎉 Agent is running and should be connected to Azure Log Analytics." -ForegroundColor Green
} else {
    Write-Warning "⚠️ HealthService is not running. Trying to start..."
    Start-Service -Name HealthService
}

# ------------------------ DONE ------------------------

Write-Host "🚀 Log Analytics setup completed!" -ForegroundColor Cyan
