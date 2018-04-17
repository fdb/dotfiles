@echo off

REM This script launches a Windows command prompt that can access the Visual Studio tools.

REM To set up:
REM Make sure this script is in C:\Projects\dotfiles\shell.bat.
REM On the desktop, right click and choose New > Shortcut.
REM For the location of the item, type "cmd".
REM For the name of the shortcut, type "Command Prompt".
REM Right-click the shortcut and choose Properties.
REM For "Target", type "C:\Windows\System32\cmd.exe /k C:\Projects\dotfiles\shell.bat".
REM For "Start In", type "C:\Projects".

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64