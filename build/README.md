# How to build
What you need:
- [ps2exe.ps1](https://github.com/MScholtes/Win-PS2EXE/blob/master/ps2exe.ps1)

1. Clone this repository
2. Get the file from above into this directory
3. Start PowerShell
4. Navigate to this folder (build) and execute the following command:
```powershell
.\ps2exe.ps1 -inputFile "..\src\Terminator.ps1" -outputFile "..\bin\Terminator.exe" -STA -noConsole -iconFile "..\resources\logo\terminator.ico" -title "Terminator" -description "simple tool to kill processes" -company "Hope-IT-Works" -product "Terminator" -copyright "Copyright © 2022 Tobias Meyer" -trademark "Terminator™; Hope-IT-Works™" -version "1.3.0.0" -noOutput -noError -UNICODEEncoding
```
