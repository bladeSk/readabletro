@echo off
:: ensure the correct working directory is set when running as admin via the right click menu
pushd %~dp0

setlocal
set file=Balatro.exe
set expectedsize=55441144

call :setsize %file%

IF NOT EXIST %file% (
	echo Couldn't find %file%. Copy these files to Balatro's game directory and run apply_readabletro.cmd again.
	pause
	goto :eof
)

if %size% neq %expectedsize% (
    echo %file% has an unexpected size - only version 1.0.0n-FULL is supported.
    pause
    goto :eof
)

dd if=%file% of=b.exe bs=394752 count=1
dd if=%file% of=b.zip bs=394752 skip=1

7z a b.zip .\readabletro\* || goto :error

ren Balatro.exe Balatro.exe.bak
copy /y /b b.exe+b.zip Balatro.exe
del b.exe
del b.zip

echo Done!
pause

goto :eof

:error
echo Error.
pause
goto :eof

:setsize
set size=%~z1
goto :eof
