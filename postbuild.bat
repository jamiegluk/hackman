@echo off
rem Arranges compiled HackMan files into dist folder

echo. Hackman postbuild by Jamie Lievesley
echo.

echo.
echo Checking compiled exe files

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
echo Clearing dist
@echo on

del /s /q /f dist
rmdir /s /q /f dist
if not exist dist mkdir dist
if not exist dist\prototype mkdir dist\prototype
if not exist dist\hackman mkdir dist\hackman
if not exist dist\create-highscores-file mkdir dist\create-highscores-file


@echo off
echo.
echo Moving exe files
@echo on

move /Y src\prototype\pacman.exe dist\prototype\pacman.exe
move /Y src\hackman\hackman.exe dist\hackman\hackman.exe
move /Y src\create-highscores-file\createHighscoresFile.exe dist\create-highscores-file\createHighscoresFile.exe


@echo off
echo.
echo Creating highscores file
@echo on

cd dist\create-highscores-file
call createHighscoresFile.exe
cd ../..
xcopy /s dist\create-highscores-file\highscores dist\hackman\


@echo off
echo.
echo Copying additional files
@echo on

xcopy /s doc\README.md dist\hackman\
xcopy /s LICENSE dist\hackman\


@echo off
echo.
echo [92mDONE[0m
echo[
echo [7mFind exe in dist/hackman folder.
echo If copying to other folder: copy both "hackman.exe" and "highscores" and "maze.txt".
echo[

@echo off
echo.
echo Running app...
@echo on

cd dist/hackman
start hackman.exe

pause
