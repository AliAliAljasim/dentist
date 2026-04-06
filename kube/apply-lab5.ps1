[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DockerHubUsername,

    [string]$Namespace = "default",

    [switch]$RenderOnly
)

$ErrorActionPreference = "Stop"

$templateDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputDir = Join-Path $templateDir "rendered"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$files = @(
    @{ Name = "lab5deployment.yaml"; Template = Join-Path $templateDir "lab5deployment.yaml" },
    @{ Name = "lab5service.yaml"; Template = Join-Path $templateDir "lab5service.yaml" }
)

foreach ($file in $files) {
    $content = Get-Content -Raw -LiteralPath $file.Template
    $content = $content.Replace("YOUR_DOCKERHUB_USERNAME", $DockerHubUsername)
    $renderedPath = Join-Path $outputDir $file.Name
    Set-Content -LiteralPath $renderedPath -Value $content -NoNewline
    Write-Host "Rendered $renderedPath"
}

if ($RenderOnly) {
    Write-Host "Render only complete."
    exit 0
}

if ($Namespace -ne "default") {
    & kubectl create namespace $Namespace --dry-run=client -o yaml | & kubectl apply -f -
}

foreach ($file in $files) {
    $renderedPath = Join-Path $outputDir $file.Name
    if ($Namespace -eq "default") {
        & kubectl apply -f $renderedPath
    } else {
        & kubectl apply -n $Namespace -f $renderedPath
    }
}

Write-Host "Lab 5 manifests applied successfully."
