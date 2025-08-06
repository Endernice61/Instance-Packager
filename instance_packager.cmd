@if "%~2"=="" goto :drag_drop
@set imgname="%~1\%~2.vtf"
@set pkdir=%~2
@set itemname=%pkdir:_= %
@set input="%~1\%~2.vmf"
@goto :skip
:drag_drop
@set input=%1
@setlocal enabledelayedexpansion
@set imgname=%input:~0,-5%.vtf"
@set pkdir=!input:%CD%=!
@set pkdir=%pkdir:~2,-5%
@set itemname=%pkdir:_= %
:skip
@set scriptdir=%CD%
@for /F "delims=" %%i in (beedir.txt) do set beedir=%%i
@if NOT EXIST "%beedir%\BEE2.exe" (
	echo [91mDirectory of BEE is missing or incorrect! Please specify the path inside of beedir.txt![0m
	goto :end
)
@for /F "delims=" %%i in (p2dir.txt) do set p2dir=%%i
@if NOT EXIST "%p2dir%\portal2\gameinfo.txt" (
	echo [91mWARNING! Directory of Portal 2 is missing or incorrect! This script will not be able automatically export instance changes and will not be able to create palette icons from tgas! Specify the path of the Portal 2 folder in p2dir.txt. [0m
	set p2dir=
)
cd %beedir%
cd packages
mkdir _inst_%pkdir%
@set fullpkdir=%beedir%\packages\_inst_%pkdir%
@cd %scriptdir%
@(for /F "delims=" %%i in (info.txt) do @(
	set line=%%i
	CALL :replace
)) > "%fullpkdir%\info.txt"
@echo Created info.txt
cd %fullpkdir%
mkdir "resources/instances"
copy %input% "resources/instances"
@if "%p2dir%"=="" (
	echo [91mCould not automatically export instance changes![0m
) ELSE (
	copy %input% "%p2dir%\sdk_content\maps\instances\bee2"
	echo Instance changes automatically exported
)
mkdir "items/%pkdir%"
@cd %scriptdir%
@(for /F "delims=" %%i in (base_item.txt) do @(
	set line=%%i
	CALL :replace2 "%pkdir%" "%itemname%"
)) > "%fullpkdir%\items\%pkdir%\editoritems.txt"
@echo Created editoritems.txt
@(echo "Properties" {& echo 	"Authors" "Instance Packager (Hovering Harry), Unknown Author"& echo 	"Description" "Made with instance packager"& echo }) > "%fullpkdir%\items\%pkdir%\properties.txt"
@echo Created properties.txt
cd %fullpkdir%
@if EXIST %imgname% (
	mkdir "resources/materials/models/props_map_editor/palette"
	copy %imgname% "resources/materials/models/props_map_editor/palette"
	echo Palette icon set
) ELSE if EXIST %imgname:~0,-5%.tga" (
	if "%p2dir%"=="" (echo [91mPalette icon could not be created![0m) ELSE (
		mkdir "resources/materials/models/props_map_editor/palette"
		"%p2dir%\bin\vtex" -outdir "%CD%/resources/materials/models/props_map_editor/palette" -game "%p2dir%\portal2" %imgname:~0,-5%.tga"
		echo Palette icon created
	)
)
@endlocal
@goto end
:replace2
@setlocal enabledelayedexpansion
@set line=!line:#1=%~1!
@echo !line:#2=%~2!
@endlocal
@exit /b 0
:replace
@setlocal enabledelayedexpansion
@echo !line:#1=%pkdir%!
@endlocal
@exit /b 0
:end
pause