# Define a list of partial titles you want to monitor
$targetTitles = @("Powerful tools", "paypal", "digital wallets")

# Define a list of popular browser process names
$browserProcesses = @("chrome", "firefox", "msedge", "opera")

# Define the interval to check (in seconds)
$checkInterval = 15

# Outer loop to run continuously
while ($true) {
    # Loop until any condition is met
    $conditionMet = $false

    while (-not $conditionMet) {
        foreach ($browserName in $browserProcesses) {
            $currentBrowserProcesses = Get-Process -name $browserName -ErrorAction SilentlyContinue
            if ($currentBrowserProcesses) {
                foreach ($process in $currentBrowserProcesses) {
                    try {
                        $processTitle = $process.MainWindowTitle
                        Write-Host "$browserName - Window Title: $processTitle"
                        if ($targetTitles | ForEach-Object { $processTitle -like "*$_*" }) {
                            Write-Host "Detected one of the specified titles in $browserName. Closing..."
                            Stop-Process -Id $process.Id -Force
                            $conditionMet = $true  # Set the flag to true when any condition is met
                            break 2  # Exit both inner and outer loops when any condition is met
                        }
                    } catch {
                        # Handle any exceptions that might occur (e.g., due to missing access permissions)
                    }
                }
            }
        }

        if ($conditionMet) {
            break  # Exit the outer loop when any condition is met
        }

        # Sleep for the specified interval (in seconds) before checking again
        Start-Sleep -Seconds $checkInterval
    }
}

# Continue with the rest of your script here
Write-Host "A condition is met. Continue with the rest of your code here."

