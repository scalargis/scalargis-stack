$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

git submodule update --init
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (Test-Path .env) {
    Write-Host '.env exists, no change.'
    exit 0
}

function New-Secret([int]$Length) {
    $chars = [char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    $bytes = New-Object byte[] $Length
    [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
    -join ($bytes | ForEach-Object { $chars[$_ % $chars.Length] })
}

$dbPass = New-Secret 24
$values = @{
    DB_PASS                  = $dbPass
    POSTGRES_PASSWORD        = $dbPass
    SECRET_KEY               = New-Secret 48
    SECURITY_PASSWORD_SALT   = New-Secret 32
    GEOSERVER_ADMIN_PASSWORD = New-Secret 20
}

$lines = Get-Content .env.example | ForEach-Object {
    $key = ($_ -split '=', 2)[0]
    if ($values.ContainsKey($key)) { "$key=$($values[$key])" } else { $_ }
}
[IO.File]::WriteAllText((Join-Path $PSScriptRoot '.env'), (($lines -join "`n") + "`n"))

Write-Host '.env written. Next: docker compose up -d --build'
