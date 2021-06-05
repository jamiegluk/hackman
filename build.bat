@echo off
rem Compiles HackMan application
rem and arranges files into dist folder

echo HackMan builder by Jamie Lievesley
echo.


where fpc >nul 2>nul
if %errorlevel% neq 0 (
  echo [91mERROR: Must install Freepascal and ensure `fpc` command exists[0m  1>&2
  pause
  exit 1
)


echo.
echo Compiling prototype
@echo on

cd src\prototype
fpc pacman.pas
cd ../..


@echo off
echo.
echo Compiling hackman
@echo on

cd src\hackman
fpc hackman.pas
cd ../..


@echo off
echo.
echo Compiling highscores
@echo on

cd src\create-highscores-file
fpc createHighscoresFile.pas
cd ../..


@echo off
echo.
echo [92mCOMPILED[0m
echo Running postbuild...
echo.
@echo on

call postbuild.bat
