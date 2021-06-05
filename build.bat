@echo off
rem Compiles HackMan application
rem and arranges files into dist folder

echo [95mHackMan builder by Jamie Lievesley[0m
echo.


where fpc >nul 2>nul
if %errorlevel% neq 0 (
  echo [91mERROR: Must install Freepascal and ensure `fpc` command exists[0m  1>&2
  pause
  exit 1
)

rem Alias compiler command
set _fpc=fpc -Mobjfpc -Sg -Sc -Un -FcCP437 -dDisableUTF8RTL -Fu"%FPCDIR%\units\*\rtl-console" -Fu"C:\tools\freepascal\units\*\rtl-console" $*


echo.
echo [36m# Compiling prototype...[0m

cd src\prototype
@echo on
%_fpc% pacman.pas
@echo off
if %errorlevel% neq 0 (
  echo [91mERROR: Build failed[0m  1>&2
  pause
  exit 1
)
cd ../..


echo.
echo [36m# Compiling hackman...[0m

cd src\hackman
@echo on
%_fpc% hackman.pas
@echo off
if %errorlevel% neq 0 (
  echo [91mERROR: Build failed[0m  1>&2
  pause
  exit 1
)
cd ../..


echo.
echo [36m# Compiling highscores...[0m

cd src\create-highscores-file
@echo on
%_fpc% createHighscoresFile.pas
@echo off
if %errorlevel% neq 0 (
  echo [91mERROR: Build failed[0m  1>&2
  pause
  exit 1
)
cd ../..


echo.
echo [92mCOMPILED[0m
echo.
echo [36m# Running postbuild...[0m

@echo on
call postbuild.bat
