#!/bin/bash
# @Author: Kristinita
# @Date: 2023-12-07 10:38:45
# @Last Modified by: Kristinita
# @Last Modified time: 2025-03-19 10:35:08

# [OVERVIEW] Install all Travis CI dependencies via GNU Parallel

###########
# WARNING #
###########
# [BUG][WARNING][APPVEYOR] Don’t use NON-ASCII symbols in this file!
# AppVeyor doesn’t support them.
# https://ci.appveyor.com/project/Kristinita/kristinitapelican/build/job/ha70um51grbxo8e4#L2032
# https://github.com/appveyor/ci/issues/2226
# https://github.com/appveyor/ci/issues/2129
# https://github.com/appveyor/ci/issues/2107


############
# Parallel #
############
# [LEARN][PARALLEL] Run commands parallel:
# https://www.gnu.org/software/parallel/
#
# [WARNING] On Windows it works in Cygwin, not in default console:
# https://savannah.gnu.org/forum/forum.php?forum_id=7581
#
# [INFO] Parallel npm and pip tasks:
# https://unix.stackexchange.com/a/427419/237999
#
# [NOTE] Default UNIX parallel commands doesn’t work for Travis CI:
# https://unix.stackexchange.com/questions/427410#comment771128_427415
#
# [NOTE] Don’t paste any comments after “parallel :::”, parallel will not work!
# https://travis-ci.org/Kristinita/SashaScrutinizer/builds/363772800
#
# [LEARN][BASH] Behavior for single and double quotes are different in shell scripts.
# Single quotes won’t interpolate anything, but double quotes will.
# Single, not double quotes required for Parallel:
# https://stackoverflow.com/a/6697781/5951529
#
# [LEARN][BASH] Shebang required in the beginning of the file:
# https://github.com/koalaman/shellcheck/wiki/SC2148


########
# Node #
########
# [INFO] Use “npm ci” instead of “npm install” for installation of all dependencies
# on continuous integration services:
# 1. This command performs a clean installation of dependencies:
# https://stackoverflow.com/a/53325242/5951529
# https://docs.npmjs.com/cli/v10/commands/npm-ci
# 2. The cache size can be several times smaller.
# “npm ci” allows to meet the cache limit in CIs such as AppVeyor:
# https://stackoverflow.com/q/65490464/5951529
# https://stackoverflow.com/q/68729612/5951529
# 3. “npm ci” can reduce the time of dependencies installation:
# https://stackoverflow.com/a/68730056/5951529
#
# [REQUIRED] “package-lock.json” or “npm-shrinkwrap.json” for “npm ci”.
# Not ignore these files in “.gitignore”.
# I can’t find, how I can use “npm ci” with ignored “package-lock.json”
# https://docs.npmjs.com/cli/v10/commands/npm-ci#description
# https://docs.travis-ci.com/user/languages/javascript-with-nodejs/#npm-ci-support
#
# [INFO] “--loglevel=error” — handle “npm WARN deprecated” warnings of third-party packages:
# https://sebhastian.com/npm-warn-deprecated/
# [COMPARE]
# https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49098311#L47
# https://ci.appveyor.com/project/Kristinita/sashaappveyordebugging/builds/49098373#L53
#
#
# [NOTE] Grunt tasks needs grunt-cli globally:
# https://stackoverflow.com/a/21133609/5951529
#
# [REQUIRED] Activation “simple-git-hooks” after installation::
# https://github.com/toplenboren/simple-git-hooks#add-simple-git-hooks-to-the-project


##########
# Python #
##########
# [NOTE] Use “--upgrade” flag for install Pipenv,
# as of November 2020 Travis CI has outdated Pipenv version:
# https://github.com/pypa/pipenv/issues/4141#issuecomment-728808409


##########
# DotNet #
##########
# [NOTE] Big .NET dependency required for LocalAppVeyor:
# https://github.com/joaope/LocalAppVeyor#install
#
# [INFO] Install the .NET SDK or the .NET Runtime on Ubuntu 22.04:
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2204
#
# [INFO] Use “.NET Runtime”, not “.NET SDK”;
# SDK required for developing apps; for using apps install the Runtime:
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-snap#sdk-or-runtime
#
# [FIXME] LocalAppVeyor doesn’t work on .NET 6:
# https://github.com/joaope/LocalAppVeyor/issues/445
#
# [BUG] DotNet not installed to Ubuntu 22 via Snap:
# https://stackoverflow.com/a/68519735/5951529
# https://app.travis-ci.com/github/Kristinita/SashaTravis/builds/254922526#L202
# https://github.com/dotnet/installer/issues/491
# https://github.com/dotnet/sdk/issues/11639
# https://forum.snapcraft.io/t/rpath-in-elf-that-can-be-moved-across-system/10118
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-snap
#
#
# [INFO] Install the .NET SDK or the .NET Runtime on Ubuntu:
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
#
# [INFO] Installation for Ubuntu 20.10:
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2010-
#
# [NOTE] Matrix key “dotnet” for C#, F# or Visual Basic projects.
# If no, you need install .NET Core manually:
# https://docs.travis-ci.com/user/languages/csharp/
#
# [REQUIRED] Specific DotNet and Ubuntu versions for DotNet installation on Travis;
# “https://packages.microsoft.com/config/ubuntu/packages-microsoft-prod.deb” and
# “sudo apt-get install dotnet-sdk” not work.
parallel ::: 'pip install --upgrade pip pipenv && pipenv install --dev && pipenv run peru sync && python installation_scripts/gh_release_install.py' \
	'npm install --global grunt-cli && npm ci --loglevel=error && npx simple-git-hooks' \
	'gem install travis' \
	'wget -q https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && sudo apt-get update && sudo apt-get install -y dotnet-sdk-5.0 && dotnet tool install -g localappveyor'
