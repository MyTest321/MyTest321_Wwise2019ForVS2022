@REM #change current directory to this file
%~d0
cd %~dp0

@REM set WWISEROOT=D:\Wwise 2019.2.15.7667
set MyTestPlatform=Windows_vc170
python "%WWISEROOT%/Scripts/Build/Plugins/wp.py" premake %MyTestPlatform%
python "%WWISEROOT%/Scripts/Build/Plugins/wp.py" build -c Release -x x64_vc170 %MyTestPlatform%

@pause