$dataDir = Join-Path $PSScriptRoot "src\data"
if (!(Test-Path $dataDir)) {
    New-Item -ItemType Directory -Force -Path $dataDir
}

$markets = @(
    @{ id = 'kalyan-chart'; name = 'Kalyan Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat') },
    @{ id = 'kalyan-night-chart'; name = 'Kalyan Night Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat') },
    @{ id = 'kalyan-jodi-chart'; name = 'Kalyan Jodi Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat') },
    @{ id = 'kalyan-morning-chart'; name = 'Kalyan Morning Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat') },
    @{ id = 'madhur-night-chart'; name = 'Madhur Night Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat') },
    @{ id = 'milan-night-chart'; name = 'Milan Night Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat') },
    @{ id = 'milan-day-chart'; name = 'Milan Day Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat') },
    @{ id = 'sridevi-chart'; name = 'Sridevi Chart'; days = @('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun') }
)

# Helper to generate random Jodi or 'XX'
function Get-RandomJodi($isActive) {
    if (!$isActive) { return 'XX' }
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 5) { return 'XX' }
    $num = Get-Random -Minimum 0 -Maximum 100
    return $num.ToString("00")
}

# Generate list of weeks from Jan 5, 2026 to Jun 15, 2026 (24 weeks)
$weeks = @()
$currentDate = [datetime]"2026-01-05"
$endDate = [datetime]"2026-06-17"

while ($currentDate -le $endDate) {
    $weeks += $currentDate.ToString("dd-MM-yyyy")
    $currentDate = $currentDate.AddDays(7)
}

# Clean old JSON files from data directory
Remove-Item -Path (Join-Path $dataDir "*.json") -Force -ErrorAction SilentlyContinue

foreach ($market in $markets) {
    $fileName = $market.id + ".json"
    $filePath = Join-Path $dataDir $fileName
    $records = @()
    
    foreach ($week in $weeks) {
        $record = [ordered]@{
            weekStart = $week
            mon = Get-RandomJodi ($market.days -contains 'mon')
            tue = Get-RandomJodi ($market.days -contains 'tue')
            wed = Get-RandomJodi ($market.days -contains 'wed')
            thu = Get-RandomJodi ($market.days -contains 'thu')
            fri = Get-RandomJodi ($market.days -contains 'fri')
            sat = Get-RandomJodi ($market.days -contains 'sat')
            sun = Get-RandomJodi ($market.days -contains 'sun')
        }
        $records += $record
    }
    
    $json = ConvertTo-Json -InputObject $records -Depth 5
    Set-Content -Path $filePath -Value $json -Encoding utf8
    Write-Host "Generated $filePath with $($records.Count) records."
}

Write-Host "All JSON data generated successfully!"
