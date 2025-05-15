@REM @Author: Kristinita
@REM @Date: 2023-12-07 10:38:45
@REM @Last Modified by: Kristinita
@REM @Last Modified time: 2025-03-14 22:20:09

@REM ##########
@REM # pathed #
@REM ##########
@REM [OVERVIEW] pathed — setx PATH environment variable without loss data:
@REM http://www.p-nand-q.com/download/gtools/pathed.html
@REM
@REM [INFO] Use “/ADD” command-line argument instead of “/APPEND”.
@REM Variables added to the head of “PATH” variable
@REM have the better priority than variables from the tail of “PATH”
@REM
@REM [INFO] Use “/MACHINE” command-line argument instead of “/USER”
@REM System environment variables has the better priority than user environment variables:
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49064979
@REM
@REM
@REM [REQUIRED] 3 “refreshenv” commands in pipeline required, compare:
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/24724183
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/24723651
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/24723848
@REM
@REM [REQUIRED] “pathed /ADD” duplicates required;
@REM The syntax “pathed /ADD firstpath secondpath thirdpath” doesn’t work:
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/24721706#L32
@REM
@REM [REQUIRED] Keys “/USER” or “/MACHINE” required for pathed, compare:
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/24763128
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/24763463
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/24763626
@REM
@REM
@REM [NOTE] I can’t find a simply built-in Windows method for adding directories to “%PATH%” without pathed:
@REM https://stackoverflow.com/q/9546324/5951529
@REM
@REM [NOTE] “SETX” truncate values of the “PATH” environment variable on AppVeyor,
@REM because AppVeyor has “PATH” with more characters than 1024.
@REM Don’t use “SETX” for “PATH” on AppVeyor:
@REM https://stackoverflow.com/a/28778358/5951529
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49001982#L5
@REM
@REM [NOTE] If user set environment variables via “SET”, “refreshenv” delete this environment variables:
@REM https://github.com/appveyor/ci/issues/1755
@REM [COMPARE]
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/22187235
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/22187272
@REM [INFO] I need “refreshenv”, because some Chocolatey/Scoop tools adds directories to “PATH”
@REM and AppVeyor doesn’t automatically update the values of the PATH environment variable
@REM for the next CLI commands:
@REM https://github.com/appveyor/ci/issues/1333#issuecomment-1916957586
@REM
@REM [NOTE] If user set environment variables via “environment” section in “appveyor.yml”,
@REM refreshenv remove these variables:
@REM https://github.com/appveyor/ci/issues/1333#issuecomment-1916957586
@REM For example, refreshenv remove “%PYTHON%;%PYTHON%\\Scripts” from “PATH” in example below:
@REM
@REM ```yaml
@REM environment:
@REM 	PATH: "%PYTHON%;%PYTHON%\\Scripts;$(PATH)"
@REM 	PYTHON: C:\Python312-x64
@REM ```
@REM
@REM [NOTE] I can’t find, how I can modify “PATH” environment variable in reqistry without third-party tools:
@REM https://github.com/appveyor/ci/issues/1333#issuecomment-1917179493
@REM [INFO] Command below offer to overwrite “PATH”, but not add a new folder to it:
@REM
@REM ```text
@REM reg add HKEY_CURRENT_USER\Environment /v PATH /d "c:\KiraDirectory;%PATH%"
@REM ```
@REM
@REM
@REM [NOTE] Needs set Python 3, because Python 2 by default on AppVeyor at February 2019:
@REM https://github.com/ogrisel/python-appveyor-demo/blob/master/appveyor.yml
@REM https://www.appveyor.com/docs/windows-images-software/#python
@REM
@REM [INFO] Set latest Ruby version at the time:
@REM https://www.appveyor.com/docs/lang/ruby/
@REM https://www.appveyor.com/docs/build-environment/#ruby
@REM https://www.appveyor.com/docs/lang/ruby/#installation
@REM
@REM [INFO] Set LocalAppVeyor Windows path:
@REM DotNet user profile is “USERPROFILE” on Windows and “HOME” on Linux:
@REM https://github.com/dotnet/cli/issues/7569#issuecomment-329280924
START /B CMD /C "choco install --yes gtools & refreshenv & pathed /MACHINE /ADD %PYTHON% & pathed /MACHINE /ADD %PYTHON%\Scripts & pathed /MACHINE /ADD C:\Ruby30-x64\bin"
