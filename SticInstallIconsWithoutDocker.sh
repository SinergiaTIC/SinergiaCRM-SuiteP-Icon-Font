#!/bin/bash

# This file is part of SinergiaCRM.
# SinergiaCRM is a work developed by SinergiaTIC Association, based on SuiteCRM.
# Copyright (C) 2013 - 2023 SinergiaTIC Association

# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License version 3 as published by the
# Free Software Foundation.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.

# You should have received a copy of the GNU Affero General Public License along with
# this program; if not, see http://www.gnu.org/licenses or write to the Free
# Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 USA.

# You can contact SinergiaTIC Association at email address info@sinergiacrm.org.


# Script for rebuilding SinergiaCRM icon fonts and stylesheets

# This script is used to rebuild the SinergiaCRM icon fonts and stylesheets. 
# It is adapted from a script found at https://github.com/salesagility/SuiteP-Icon-Font. 
# This script should be run without parameters from the SticUtils/Icons folder.

# Dependencies:
# - git for updating the repository
# - svgo for compressing and copying SticIcons to the tmp folder
# - icon-font-generator for creating the icon font from the SVG files
# - scssphp for compiling the SCSS sources into CSS
# - if svgo or icon-font-generator aren't available, please install the using node version > 14.0.0. See ./HOWTO.md

# Instructions:
# 1. Ensure that all dependencies are installed and available in the PATH.
# 2. Run bash SticInstallIcons.sh

# Adding a new icon:
# To add a new icon to SinergiaCRM, copy it to the SticSrc folder. 
# It is a good idea to start with a copy of one of the existing icons, rename it, modify it with Inkscape, 
# and save it as a plain SVG file.

# Remove any existing tmpSrc directory if exists
rm -rf tmpSrc

# Update repository
git pull

# Compress and copy SuiteP Icons to tmp folder
cp -r src/ tmpSrc

# Compress and copy SticSrc to tmp folder
svgo -q -f SticSrc/ -o tmpSrc

# Create font from ./tmpSrc folder
icon-font-generator tmpSrc/*svg -o suitepicon --mono --center -p suitepicon --csspath suitepicon/suitepicon-glyphs.scss --name suitepicon 

cp -r suitepicon/* ../sinergiacrm/themes/SuiteP/css/suitep-base/
# docker cp suitepicon/. sw-php-fpm:/application/sinergiacrm/themes/SuiteP/css/suitep-base/

# Regenerate style.css from scss sources to activate new suitepicon classes
echo "Generating css for Stic subtheme"
../sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed ../sinergiacrm/themes/SuiteP/css/Stic/style.scss > ../sinergiacrm/themes/SuiteP/css/Stic/style.css && cp -p ../sinergiacrm/themes/SuiteP/css/Stic/style.css ../sinergiacrm/cache/themes/SuiteP/css/Stic/style.css
../sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed ../sinergiacrm/themes/SuiteP/css/SticCustom/style.scss > ../sinergiacrm/themes/SuiteP/css/SticCustom/style.css && cp -p ../sinergiacrm/themes/SuiteP/css/SticCustom/style.css ../sinergiacrm/cache/themes/SuiteP/css/SticCustom/style.css
../sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed ../sinergiacrm/themes/SuiteP/css/Dawn/style.scss > ../sinergiacrm/themes/SuiteP/css/Dawn/style.css && cp -p ../sinergiacrm/themes/SuiteP/css/Dawn/style.css ../sinergiacrm/cache/themes/SuiteP/css/Dawn/style.css
../sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed ../sinergiacrm/themes/SuiteP/css/Dusk/style.scss > ../sinergiacrm/themes/SuiteP/css/Dusk/style.css && cp -p ../sinergiacrm/themes/SuiteP/css/Dusk/style.css ../sinergiacrm/cache/themes/SuiteP/css/Dusk/style.css
../sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed ../sinergiacrm/themes/SuiteP/css/Day/style.scss > ../sinergiacrm/themes/SuiteP/css/Day/style.css && cp -p ../sinergiacrm/themes/SuiteP/css/Day/style.css ../sinergiacrm/cache/themes/SuiteP/css/Day/style.css
../sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed ../sinergiacrm/themes/SuiteP/css/Night/style.scss > ../sinergiacrm/themes/SuiteP/css/Night/style.css && cp -p ../sinergiacrm/themes/SuiteP/css/Night/style.css ../sinergiacrm/cache/themes/SuiteP/css/Night/style.css
../sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed ../sinergiacrm/themes/SuiteP/css/noon/style.scss > ../sinergiacrm/themes/SuiteP/css/noon/style.css && cp -p ../sinergiacrm/themes/SuiteP/css/noon/style.css ../sinergiacrm/cache/themes/SuiteP/css/noon/style.css


# Delete tmpSrc directory and SuiteP-Icon-Font repository
rm -rf tmpSrc