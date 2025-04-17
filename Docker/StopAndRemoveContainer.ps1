<#
.SYNOPSIS
    Stops and removes a Docker container if its health check fails or if it's not running.

.PARAMETER ContainerName
    Name of the Docker container to evaluate and remove if unhealthy.

.NOTES
    - Docker must be installed and running.
    - The container must be configured with a HEALTHCHECK for this to work.
    - Must be run with appropriate permissions to control Docker.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ContainerName
)

Write-Host "🔍 Checking health status of container '$ContainerName'" -ForegroundColor Cyan

# Get container status and health (if defined)
$containerInfo = docker inspect $ContainerName 2>$null

if (-not $containerInfo) {
    Write-Error "❌ Container '$ContainerName' not found."
    exit 1
}

# Parse health status
$state = ($containerInfo | ConvertFrom-Json).State
$healthStatus = $state.Health.Status
$running = $state.Running

Write-Host "📦 Container Running: $running"
Write-Host "❤️ Health Status: $healthStatus"

# Check if healthcheck is defined
if (-not $healthStatus) {
    Write-Warning "⚠️ No health check defined. Evaluating only by container state..."
    if (-not $running) {
        Write-Host "❌ Container is not running. Proceeding to stop and remove." -ForegroundColor Yellow
        docker stop $ContainerName
        docker rm $ContainerName
        Write-Host "🗑 Container '$ContainerName' stopped and removed." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "✅ Container is running. No action needed." -ForegroundColor Green
        exit 0
    }
}

# Stop and remove if unhealthy
if ($healthStatus -eq "unhealthy" -or -not $running) {
    Write-Host "❌ Health check failed or container not running. Removing container..." -ForegroundColor Yellow
    docker stop $ContainerName
    docker rm $ContainerName
    Write-Host "🗑 Container '$ContainerName' stopped and removed." -ForegroundColor Green
} else {
    Write-Host "✅ Container is healthy and running. No action taken." -ForegroundColor Green
}
