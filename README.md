# MyTest321_Wwise2019ForVS2022
- Wwise 2019.2.15 Using the Development Tools to build Wwise Plug-ins for Visual Studio 2022
- Ref: https://www.audiokinetic.com/en/library/edge/?source=SDK&id=effectplugin_tools.html

## How to Setup
- replace all the folders `Wwise2019.2.15` to the local `%WWISEROOT%`

### Dependency
- Please make sure installed `C++ MFC for latest v143 build tools (x86 & x64)` and `MSVC v143 - VS 2022 C++ x64/x86 build tools`

## Sample Test
This sample project is base on Template taken from audiokinetic "wuoa-plugin"
https://github.com/audiokinetic/wuoa-plugin
```
cd MySample

gen_Authoring_Windows.bat
gen_Authoring.bat
gen_Windows_vc170.bat
```