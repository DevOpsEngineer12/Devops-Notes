<#
.SYNOPSIS
    Checks if a Docker image exists based on a given container name.

.DESCRIPTION
    Finds the container by name, retrieves the associated image, and checks if that image exists locally.

.PARAMETER ContainerName
    Name of the Docker container to search for.

.NOTES
    - Requires Docker to be installed and running.
    - Must be run with permissions to access Docker.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ContainerName
)

Write-Host "🔍 Searching for Docker container: $ContainerName" -ForegroundColor Cyan

# Get container details
$container = docker ps -a --filter "name=$ContainerName" --format "{{.ID}} {{.Image}}"

if (-not $container) {
    Write-Error "❌ No container found with the name: $ContainerName"
    exit 1
}

# Parse container details
$parts = $container -split ' '
$containerId = $parts[0]
$imageName = $parts[1]

Write-Host "📦 Container found: ID=$containerId, Image=$imageName"

# Check if image exists locally
$imageExists = docker images --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -eq $imageName }

if ($imageExists) {
    Write-Host "✅ Image exists locally: $imageName" -ForegroundColor Green
} else {
    Write-Warning "⚠️ Image '$imageName' used by container '$ContainerName' is not available locally!"
}

# Optional output
return @{
    ContainerName = $ContainerName
    ImageName = $imageName
    ExistsLocally = [bool]$imageExists
}
