@echo off
cd /d "%~dp0"
powershell -c iwr https://github.com/bfffggh/wpe-on-hdd/releases/download/gui_release/boot.wim -outfile "%~dp0boot.wim"
title Windows PE setup
choice /c IC /n /m "[(I)nstall,(C)ancel]"
if "%errorlevel%"=="2" exit
:install-pe
cls
set /p ds="size in GB> "
set /a dsm=%ds%*1024


echo cre vdis file="C:\WinPE.vhd" maximum=%dsm% type=expandable >"%~dp0wpe-vhd.txt"
echo attach vdis >>"%~dp0wpe-vhd.txt"
echo cre par pri >>"%~dp0wpe-vhd.txt"
echo form fs=ntfs quick label=WinPE >>"%~dp0wpe-vhd.txt"
echo ass letter=P: >>"%~dp0wpe-vhd.txt"
cls
echo Installing WinPE [Stage 1/3]...


:: make the diskpart script yourself or generate it using the dropper
diskpart /s "%~dp0wpe-vhd.txt"
del "%~dp0wpe-vhd.txt"
cls
echo Installing WinPE [Stage 2/3]...
DISM /Apply-Image /ImageFile:"%~dp0boot.wim" /Index:1 /ApplyDir:P:\
cls
echo Installing WinPE [Stage 3/3]...
DISM /Image:P:\ /Set-TargetPath:X:\
cls
echo Installing WinPE [Stage 3/3]...
bcdboot P:\Windows /d
cls
:: Reboot computer
shutdown /r /f /t 0
