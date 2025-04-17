<#
.SYNOPSIS
    Creates a Docker bridge network if it doesn't exist, and validates the result.

.DESCRIPTION
    This script checks for the existence of a Docker bridge network with a specific name.
    If not found, it creates the network and verifies successful creation.

.PARAMETER NetworkName
    The name of the Docker bridge network to create.

.NOTES
    - Requires Docker to be installed and running.
    - Must be run with elevated privileges (if required by Docker Desktop or Docker Engine).
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$NetworkName
)

Write-Host "🔍 Checking if Docker network '$NetworkName' exists..." -ForegroundColor Cyan

# Check if network exists
$networkExists = docker network ls --filter "name=^$NetworkName$" --filter "driver=bridge" --format "{{.Name}}"

if ($networkExists -eq $NetworkName) {
    Write-Host "✅ Docker bridge network '$NetworkName' already exists." -ForegroundColor Green
    return
}

Write-Host "⚙️ Creating Docker bridge network: $NetworkName..." -ForegroundColor Yellow

# Attempt to create the network
$createResult = docker network create --driver bridge $NetworkName

# Validate creation
if ($createResult) {
    $verify = docker network ls --filter "name=^$NetworkName$" --format "{{.Name}}"
    if ($verify -eq $NetworkName) {
        Write-Host "🎉 Successfully created Docker bridge network: $NetworkName" -ForegroundColor Green
    } else {
        Write-Error "❌ Docker network creation failed. Network not found after creation attempt."
    }
} else {
    Write-Error "❌ Failed to create Docker network. Docker engine may not be running or network name is invalid."
}
