@echo off
rem Arranges compiled HackMan files into dist folder

echo.
echo [95mHackman postbuild by Jamie Lievesley[0m
echo.

echo.
echo [36m# Checking compiled exe files...[0m

if not exist src\hackman\hackman.exe (
  echo [91mERROR: src\hackman\hackman.exe not found![0m  1>&2
  echo [91mMust build hackman.pas first[0m  1>&2
  pause
  exit 1
)
if not exist src\prototype\pacman.exe (
  echo [91mERROR: src\prototype\pacman.exe not found![0m  1>&2
  echo [91mMust build pacman.pas first[0m  1>&2
  pause
  exit 1
)
if not exist src\create-highscores-file\createHighscoresFile.exe (
  echo [91mERROR: src\create-highscores-file\createHighscoresFile.exe not found![0m  1>&2
  echo [91mMust build createHighscoresFile.pas first[0m  1>&2
  pause
  exit 1
)

echo.
echo All files exist


echo.
echo [36m# Clearing dist...[0m
@echo on

del /s /q /f dist
rmdir /s /q dist
if not exist dist mkdir dist
if not exist dist\prototype mkdir dist\prototype
if not exist dist\hackman mkdir dist\hackman
if not exist dist\create-highscores-file mkdir dist\create-highscores-file


@echo off
echo.
echo [36m# Moving exe files...[0m
@echo on

move /Y src\prototype\pacman.exe dist\prototype\pacman.exe
move /Y src\hackman\hackman.exe dist\hackman\hackman.exe
move /Y src\create-highscores-file\createHighscoresFile.exe dist\create-highscores-file\createHighscoresFile.exe


@echo off
echo.
echo [36m# Creating highscores file...[0m
@echo on

cd dist\create-highscores-file
echo | createHighscoresFile.exe
cd ../..
xcopy /s dist\create-highscores-file\highscores dist\hackman\


@echo off
echo.
echo [36m# Copying mazes...[0m
@echo on

xcopy /s src\prototype\map.txt dist\prototype\
xcopy /s src\hackman\maze.txt dist\hackman\
xcopy /s mazes dist\hackman\mazes\


@echo off
echo.
echo [36m# Copying additional files...[0m
@echo on

xcopy /s doc\README.md dist\hackman\
copy /y LICENSE dist\hackman\


@echo off
echo.
echo [92mDONE[0m
echo.
echo [7mFind exe in dist/hackman folder.
echo If copying to other folder: copy both "hackman.exe" and "highscores" and "maze.txt".[0m

echo.
echo [36m# Running app...[0m

cd dist/hackman
@echo on
start hackman.exe
echo.
@echo off

pause
