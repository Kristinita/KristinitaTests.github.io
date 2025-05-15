# @Author: Kristinita
# @Date: 2019-03-12 07:49:38
# @Last Modified by: Kristinita
# @Last Modified time: 2025-04-21 11:13:48
"""[OVERVIEW] The loader of settings from YAML files to use them in Pelican.

[PURPOSES]
1. “.py” isn’t configuration files. In Amazing Grace I use same variables for Pelican and Grunt.
By using Grunt, I can’t get variables from Python files, but I can get simply get them from YAML files.
2. I use many variables in Amazing Grace. For readability, it would be nice to store them in multiple
files, not in the one big file.

[REALIZATION] Serge Ballesta’s loader:
https://stackoverflow.com/a/55099893/5951529
"""

from pathlib import Path

# [YAML][RUAMEL_YAML][INFO] I use ruamel.yaml for parsing YAML files in Python.
# It supports YAML 1.2:
# https://yaml.dev/doc/ruamel-yaml/
#
# [YAML][PYYAML][NOTE] PyYAML doesn’t support YAML 1.2 at April 2025:
# https://github.com/yaml/pyyaml/issues/116
# https://stackoverflow.com/a/38922434/5951529
from ruamel.yaml import YAML

from pelican_configuration.python_required_settings import CURRENTYEAR, JINJA_FILTERS

# [INFO] Files with settings for both pelicanconf.py and publishconf.py.
#
# [FIXME] Pelican generates feeds for both: dev and production.
# My templates contain variables as “{{ CATEGORY_FEED_ATOM.format(slug=category.slug) }}”
# and “{{ TRANSLATION_FEED_RSS.format(lang=kira_object.lang) }}”.
# I don’t know, how I can disable these variables for dev settings and enable for production settings.
DEV_AND_PRODUCTION_SETTINGS = (
    "feeds",
    "generation",
    "markdown_plugins_settings",
    "other",
    "paths",
    "pelican_plugins_settings"
)

# [AMAZING_GRACE][PELICAN][INFO] Files with settings specifically for pelicanconf.py
#
# [LEARN][PYTHON] Trailing comma required for tuples with one element in Python.
# Otherwise, Python recognizes a tuple as a string:
# https://www.w3schools.com/python/gloss_python_tuple_one_item.asp
DEV_SPECIFIC_SETTINGS = ("development",)
# [AMAZING_GRACE][PELICAN][INFO] Files with settings specifically for publishconf.py
PRODUCTION_SPECIFIC_SETTINGS = ("production",)

# [AMAZING_GRACE][PELICAN][INFO] All settings for pelicanconf.py
DEV_SETTINGS = DEV_AND_PRODUCTION_SETTINGS + DEV_SPECIFIC_SETTINGS
# [AMAZING_GRACE][PELICAN][INFO] All settings for publishconf.py
PRODUCTION_SETTINGS = DEV_AND_PRODUCTION_SETTINGS + PRODUCTION_SPECIFIC_SETTINGS


def kira_load_settings(kira_set_of_settings: tuple) -> dict:
    """[FUNCTION_DESCRIPTION] Load settings from YAML files for Pelican.

    Arguments:
        kira_set_of_settings (tuple): specific set of settings like “DEV_SETTINGS” or “PRODUCTION_SETTINGS”

    Returns:
        dict: dictionary with Pelican settings that get settings from YAML configuration files

    Variables:
        kira_folder_with_yaml_configuration_files (str): the folder with configuration files
        kira_pelican_settings (dict): all settings from a specific set of settings
        kira_all_filenames_of_yaml_config_files (list): all filenames with settings for Pelican
    """
    # [AMAZING_GRACE][INFO] The folder with configuration files for Amazing Grace.
    #
    # [LEARN][PYTHON][PERFORMANCE] Loading global variables is slower than loading local variables.
    # Using local variables in loops can bring a noticeable speed improvement:
    # https://github.com/tonybaloney/perflint#w8202-global-name-usage-in-a-loop-loop-global-usage
    kira_folder_with_yaml_configuration_files = "pelican_configuration"

    # [AMAZING_GRACE][INFO] The dictionary with Python-specific variables.
    # The function “kira_load_settings” adds to this dictionary variables from YAML configuration files.
    #
    # [REQUIRED] Repetitions of “CURRENTYEAR” and “JINJA_FILTERS”
    kira_pelican_settings = {
        "CURRENTYEAR": CURRENTYEAR,
        "JINJA_FILTERS": JINJA_FILTERS
    }

    # [YAML][RUAMEL_YAML][INFO] ruamel.yaml safe loading:
    # https://yaml.dev/doc/ruamel.yaml/basicuse/#Load_and_dump
    kira_yaml_safe_loading = YAML(typ="safe")

    # [AMAZING_GRACE][INFO] All filenames of configuration files for Pelican.
    # 1. “amazing_grace_your_variables.yaml”, where a user need to change values of variables.
    # 2. Files from the configuration folder, which users shouldn’t change without the need.
    kira_all_filenames_of_yaml_config_files = [
        "amazing_grace_your_variables.yaml"
    ] + [
        f"{kira_folder_with_yaml_configuration_files}/{kira_yaml_config_file_in_config_folder}.yaml"
        for kira_yaml_config_file_in_config_folder in kira_set_of_settings
    ]

    for kira_filename_of_yaml_file in kira_all_filenames_of_yaml_config_files:

        # [LEARN][PYTHON] Open files in Python with the “with” statement:
        # https://pylint.pycqa.org/en/latest/user_guide/messages/refactor/consider-using-with.html
        #
        # [LEARN][PYTHON][PATHLIB] Opening a file with the “pathlib” module:
        # https://therenegadecoder.com/code/how-to-open-a-file-in-python/#open-a-file-with-the-pathlib-module
        #
        # [PATHLIB][INFO] PL123 rule of the flake8-use-pathlib package:
        # “open("foo") should be replaced by Path("foo").open()”
        # https://gitlab.com/RoPP/flake8-use-pathlib#rules
        #
        # [PATHLIB][INFO] “pathlib offers a high-level API for path manipulation.”
        # When possible, using “Path” object methods such as “Path.open()”
        # can improve readability over the “open” builtin:
        # https://docs.astral.sh/ruff/rules/builtin-open/#why-is-this-bad
        with Path(kira_filename_of_yaml_file).open(encoding="utf-8") as kira_file_with_yaml_configuration:
            kira_content_of_yaml_file = kira_yaml_safe_loading.load(kira_file_with_yaml_configuration)
            kira_pelican_settings.update(kira_content_of_yaml_file)

    return kira_pelican_settings
