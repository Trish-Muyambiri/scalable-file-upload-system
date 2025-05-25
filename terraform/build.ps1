param (
    [string]$LambdaDir,
    [string]$OutputFile
)

# Exit on error
$ErrorActionPreference = "Stop"

# Get absolute paths
$projectRoot = Get-Location
$buildDir = Join-Path $projectRoot "build"
$lambdaSource = Join-Path $projectRoot $LambdaDir
$outputZip = Join-Path $projectRoot $OutputFile

# Cleanup
if (Test-Path $outputZip) {
    Remove-Item $outputZip -Force
}
if (Test-Path $buildDir) {
    Remove-Item $buildDir -Recurse -Force
}

# Prepare build directory
New-Item -ItemType Directory -Path $buildDir | Out-Null
Copy-Item -Path "$lambdaSource\*" -Destination $buildDir -Recurse

# Install dependencies if requirements.txt exists
$requirements = Join-Path $lambdaSource "requirements.txt"
if (Test-Path $requirements) {
    pip install -r $requirements -t $buildDir
}

# Zip the contents
Compress-Archive -Path "$buildDir\*" -DestinationPath $outputZip -Force

# Cleanup
Remove-Item $buildDir -Recurse -Force

Write-Host "✅ Lambda package built: $OutputFile"
