[CmdletBinding()]
param(
    [switch]$Detached
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Copy-War {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$DestinationDirectory
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Missing WAR: $Source"
    }

    Copy-Item -LiteralPath $Source -Destination $DestinationDirectory -Force
}

$mvn = Get-Command mvn -ErrorAction SilentlyContinue
if ($mvn) {
    Write-Host "==> Building WARs..."
    Push-Location frontend
    try { & $mvn.Source clean package -q | Out-Null } finally { Pop-Location }
    Push-Location search-service
    try { & $mvn.Source clean package -q | Out-Null } finally { Pop-Location }
    Push-Location appointment-service
    try { & $mvn.Source clean package -q | Out-Null } finally { Pop-Location }
} else {
    Write-Host "==> Maven not found, using existing WAR files from target/ if present..."
}

Write-Host "==> Copying WARs to Docker folder..."
Copy-War "frontend\target\frontend.war" "Docker-Lab5Microservices"
Copy-War "search-service\target\search-service.war" "Docker-Lab5Microservices"
Copy-War "appointment-service\target\appointment-service.war" "Docker-Lab5Microservices"

Write-Host "==> Starting all containers..."
$composeArgs = @("compose", "up", "--build")
if ($Detached) {
    $composeArgs += "-d"
}
& docker @composeArgs
