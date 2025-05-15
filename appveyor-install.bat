@REM @Author: Kristinita
@REM @Date: 2018-02-28 19:42:16
@REM @Last Modified by: Kristinita
@REM @Last Modified time: 2025-03-19 09:54:00
@REM
@REM [PURPOSE] Install all AppVeyor dependencies for building and validation.
@REM
@REM
@REM #########
@REM # Batch #
@REM #########
@REM [LEARN][BATCH] REM single-line comments:
@REM https://stackoverflow.com/a/12407934/5951529
@REM
@REM [LEARN][BATCH] Hide REM lines from showing, use @ symbol:
@REM https://www.computerhope.com/issues/ch001313.htm
@REM https://jpsoft.com/help/rem.htm
@REM
@REM [LEARN][BATCH] Multiline @GOTO comments:
@REM https://stackoverflow.com/a/8527001/5951529
@REM
@REM [NOTE] Sublime Text don’t highlight multiline @GOTO comments,
@REM use single-line REM comments:
@REM https://github.com/sublimehq/Packages/issues/3905
@REM https://i.imgur.com/O6TC1sZ.png
@REM
@REM [LEARN][BATCH] CMD command /C option run another console; without /C option command doesn't work:
@REM https://ss64.com/nt/cmd.html
@REM
@REM [LEARN][BATCH] START command /B option, that output from another consoles move to head console:
@REM https://ss64.com/nt/start.html


@REM ##########
@REM # Python #
@REM ##########
@REM [REQUIRED] Use “python -m pip install --upgrade pip”, not “pip install --upgrade pip” for upgrading pip in 2024:
@REM https://stackoverflow.com/a/15223296/5951529
@REM https://pip.pypa.io/en/stable/installation/#upgrading-pip
@REM https://pythonhosted.org/CodeChat/appveyor.yml.html
@REM [COMPARE]
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49093731#L195
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49093742#L195
@REM
@REM
@REM [FIXED] For Python 3.12 on AppVeyor Visual Studio 2022 image:
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49085963#L218
@REM [FIXME] Disable pip upgrade. It used to work in 2018—2021, but doesn’t work in 2022:
@REM “%PYTHON%\\python -m pip install --upgrade pip &”
@REM https://ci.appveyor.com/project/Kristinita/kristinitapelican/build/job/7wwcotq9d18skwm4#L281
@REM [COMPARE] https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/42637066#L76
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/42637089#L74
@REM
@REM [FIXED] After Unicode supporting:
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49085963#L218
@REM [FIXME][BUG] I replace the native pygments-csv-lever to my patch
@REM without “citation marks” in “README.md” due to persistent issues for AppVeyor encodings:
@REM https://ci.appveyor.com/project/Kristinita/kristinitapelican/builds/44897793#L189
@REM [COMPARE] https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/44899708
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/44900052
START /B CMD /C "pip install pipenv & pipenv install --dev & pipenv run peru sync & python installation_scripts/gh_release_install.py"


@REM ###########
@REM # Node.js #
@REM ###########
@REM [INFO] By default, AppVeyor uses the latest Node.js version:
@REM https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/51702153#L5
@REM
@REM [REQUIRED] Activation “simple-git-hooks” after installation:
@REM https://github.com/toplenboren/simple-git-hooks#add-simple-git-hooks-to-the-project
START /B CMD /C "npm install --global grunt-cli & npm ci --loglevel=error & npx simple-git-hooks"


@REM ########
@REM # Ruby #
@REM ########
@REM [NOTE] Old Ruby 1.9.3 default by September 2020:
@REM https://www.appveyor.com/docs/windows-images-software/#ruby
START /B CMD /C "gem install travis"


@REM ##########
@REM # DotNet #
@REM ##########
@REM [NOTE] For local machine you need dotnetcore installation for localappveyor installation required:
@REM https://chocolatey.org/packages/dotnetcore
START /B CMD /C "dotnet tool install -g localappveyor"
