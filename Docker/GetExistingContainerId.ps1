<#
.SYNOPSIS
    Checks whether a Docker container with a specific name exists (running or not).

.DESCRIPTION
    This script checks for an existing Docker container with the specified name and returns the container ID if found.

.PARAMETER ContainerName
    Name of the Docker container to check.

.EXAMPLE
    .\GetExistingContainerId.ps1 -ContainerName "myapp"

.NOTES
    - Requires Docker to be installed on the VM.
    - Must be run with Docker privileges.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ContainerName
)

# Check if Docker is installed
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Docker is not installed or not in PATH."
    exit 1
}

Write-Host "🔍 Checking for container with name: $ContainerName..."

# Try to find a container with that name (running or exited)
$containerId = docker ps -a --filter "name=^/${ContainerName}$" --format "{{.ID}}"

if ($containerId) {
    Write-Host "✅ Container '$ContainerName' exists. ID: $containerId" -ForegroundColor Green
    return $containerId
} else {
    Write-Host "⚠️ No container found with name: $ContainerName" -ForegroundColor Yellow
    return $null
}
