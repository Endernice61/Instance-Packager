if "%~2"=="" goto :drag_drop
set imgname="%~1\%~2.vtf"
set pkdir=%~2
set itemname=%pkdir:_= %
set input="%~1\%~2.vmf"
goto :skip
:drag_drop
set input=%1
setlocal enabledelayedexpansion
set imgname=%input:~0,-5%.vtf"
set pkdir=!input:%CD%=!
set pkdir=%pkdir:~2,-5%
set itemname=%pkdir:_= %
:skip
set scriptdir=%CD%
for /F "delims=" %%i in (beedir.txt) do set beedir=%%i
for /F "delims=" %%i in (p2dir.txt) do set p2dir=%%i
cd %beedir%
cd packages
mkdir %pkdir%
set fullpkdir=%beedir%\packages\%pkdir%
cd %scriptdir%
(for /F "delims=" %%i in (info.txt) do @(
	set line=%%i
	CALL :replace
)) > "%fullpkdir%\info.txt"
cd %fullpkdir%
mkdir "resources/instances"
copy %input% "resources/instances"
mkdir "items/%pkdir%"
cd %scriptdir%
(for /F "delims=" %%i in (base_item.txt) do @CALL :replace2 "%%i" "%pkdir%" "%itemname%") > "%fullpkdir%\items\%pkdir%\editoritems.txt"
(echo "Properties" {& echo 	"Authors" "Instance Packager (Hovering Harry), Unknown Author"& echo 	"Description" "Made with instance packager"& echo }) > "%fullpkdir%\items\%pkdir%\properties.txt"
cd %fullpkdir%
if EXIST %imgname% (
	mkdir "resources/materials/models/props_map_editor/palette"
	copy %imgname% "resources/materials/models/props_map_editor/palette"
) ELSE if EXIST %imgname:~0,-5%.tga" (
	mkdir "resources/materials/models/props_map_editor/palette"
	"%p2dir%\bin\vtex" -outdir "%CD%/resources/materials/models/props_map_editor/palette" -game "%p2dir%\portal2" %imgname:~0,-5%.tga"
)
endlocal
goto end
:replace2
@setlocal enabledelayedexpansion
@set line=%~1
@set line=!line:#1=%~2!
@echo !line:#2=%~3!
@endlocal
@exit /b 0
:replace
@setlocal enabledelayedexpansion
@set line=%~1
@echo !line:#1=%pkdir%!
@endlocal
@exit /b 0
:end
pause