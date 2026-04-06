[CmdletBinding()]
param(
    [string]$BaseUrl = "http://localhost:8080/frontend",
    [string]$Username = "patient1",
    [string]$Password = "pass123",
    [string]$Service = "Checkup - `$50",
    [int]$TimeoutSeconds = 90,
    [int]$PollIntervalSeconds = 5
)

$ErrorActionPreference = "Stop"

function Invoke-Curl {
    param(
        [Parameter(Mandatory = $true)][string[]]$Arguments
    )

    $result = & curl.exe @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "curl.exe failed with exit code $LASTEXITCODE"
    }
    return ($result -join "`n")
}

function Get-MatchValue {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Pattern
    )

    $match = [regex]::Match($Text, $Pattern)
    if (-not $match.Success) {
        throw "Pattern not found: $Pattern"
    }
    return $match.Groups[1].Value
}

function Get-BillingCount {
    param(
        [Parameter(Mandatory = $true)][string]$CookieFile,
        [Parameter(Mandatory = $true)][string]$BillingUrl
    )

    $html = Invoke-Curl @("-sS", "-b", $CookieFile, $BillingUrl)
    $countText = Get-MatchValue -Text $html -Pattern 'Total Records</div>\s*<div class="s-value">(\d+)'
    return [int]$countText
}

$cookieFile = Join-Path ([System.IO.Path]::GetTempPath()) ("dentist-lab5-" + [guid]::NewGuid() + ".cookies")
$loginPageUrl = "$BaseUrl/login.jsp"
$loginUrl = "$BaseUrl/LoginServlet"
$dashboardUrl = "$BaseUrl/dashboard.jsp"
$scheduleUrl = "$BaseUrl/ScheduleServlet"
$billingUrl = "$BaseUrl/BillingServlet"
$searchUrl = "$BaseUrl/api/search/dentists?name=Dr"

try {
    Write-Host "Fetching login page ..."
    Invoke-Curl @("-sS", "-c", $cookieFile, $loginPageUrl) | Out-Null

    Write-Host "Logging in as $Username ..."
    Invoke-Curl @(
        "-sS", "-L",
        "-c", $cookieFile,
        "-b", $cookieFile,
        "--data-urlencode", "username=$Username",
        "--data-urlencode", "password=$Password",
        $loginUrl
    ) | Out-Null

    Write-Host "Loading dashboard and extracting JWT ..."
    $dashboardHtml = Invoke-Curl @("-sS", "-b", $cookieFile, $dashboardUrl)
    $jwtToken = Get-MatchValue -Text $dashboardHtml -Pattern 'const JWT_TOKEN = "([^"]+)"'

    Write-Host "Checking dentist search ..."
    $searchJson = Invoke-Curl @("-sS", "-b", $cookieFile, "-H", "Authorization: Bearer $jwtToken", $searchUrl)
    $searchResults = $searchJson | ConvertFrom-Json
    if ($null -eq $searchResults) {
        throw "Dentist search returned no JSON payload."
    }

    $beforeCount = Get-BillingCount -CookieFile $cookieFile -BillingUrl $billingUrl
    Write-Host "Initial billing count: $beforeCount"

    $date = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")
    Write-Host "Booking appointment on $date ..."
    Invoke-Curl @(
        "-sS", "-L",
        "-c", $cookieFile,
        "-b", $cookieFile,
        "--data-urlencode", "date=$date",
        "--data-urlencode", "service=$Service",
        $scheduleUrl
    ) | Out-Null

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        Start-Sleep -Seconds $PollIntervalSeconds
        $currentCount = Get-BillingCount -CookieFile $cookieFile -BillingUrl $billingUrl
        Write-Host "Current billing count: $currentCount"
        if ($currentCount -gt $beforeCount) {
            Write-Host "Async billing verification passed."
            exit 0
        }
    } while ((Get-Date) -lt $deadline)

    throw "Timed out waiting for billing count to increase."
}
finally {
    if (Test-Path -LiteralPath $cookieFile) {
        Remove-Item -LiteralPath $cookieFile -Force
    }
}
