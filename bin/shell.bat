@echo off

REM This is a batch file that initializes a shell with the correct environment variables
REM to compile C++ code. To use, create a shortcut, then set the target to:
REM     C:\Windows\System32\cmd.exe /K C:\Dev\dotfiles\bin\shell.bat

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
