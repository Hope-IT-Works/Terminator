# How to build
What you need:
- [ps2exe.ps1](https://github.com/MScholtes/Win-PS2EXE/blob/master/ps2exe.ps1)
- [Terminator.ps1](https://github.com/Hope-IT-Works/Terminator/blob/main/src/Terminator.ps1)
- [Terminator.ico](https://github.com/Hope-IT-Works/Terminator/blob/main/resources/logo/Terminator.ico)

Start PowerShell, navigate to a folder with the files from above and execute the following command:
```powershell
.\ps2exe.ps1 -inputFile "..\src\Terminator.ps1" -outputFile "..\bin\Terminator.exe" -STA -noConsole -iconFile "..\resources\logo\terminator.ico" -title "Terminator" -description "simple tool to kill processes" -company "Hope-IT-Works" -product "Terminator" -copyright "Copyright © 2022 Tobias Meyer" -trademark "Terminator™; Hope-IT-Works™" -version "1.2.0.0" -noOutput -noError -UNICODEEncoding
```
