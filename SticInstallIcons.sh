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

cp -r suitepicon/* ../themes/SuiteP/css/suitep-base/
# docker cp suitepicon/. sw-php-fpm:/application/sinergiacrm/themes/SuiteP/css/suitep-base/

# Regenerate style.css from scss sources to activate new suitepicon classes
echo "Generating css for Stic subtheme"
../SticInclude/vendor/scssphp/bin/pscss -s compressed ../themes/SuiteP/css/Stic/style.scss > ../themes/SuiteP/css/Stic/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Stic/style.css ../cache/themes/SuiteP/css/Stic/style.css

exit
# docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Stic/style.scss > /application/sinergiacrm/themes/SuiteP/css/Stic/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Stic/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Stic/style.css"

echo "Generating css for SticCustom subtheme"
SticInclude/vendor/scssphp/bin/pscss -s compressed themes/SuiteP/css/SticCustom/style.scss > /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css && cp /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css /application/sinergiacrm/cache/themes/SuiteP/css/SticCustom/style.css
SticInclude/vendor/scssphp/bin/pscss -s compressed themes/SuiteP/css/Dawn/style.scss > /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css && cp /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css /application/sinergiacrm/cache/themes/SuiteP/css/SticCustom/style.css
SticInclude/vendor/scssphp/bin/pscss -s compressed themes/SuiteP/css/SticCustom/style.scss > /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css && cp /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css /application/sinergiacrm/cache/themes/SuiteP/css/SticCustom/style.css
SticInclude/vendor/scssphp/bin/pscss -s compressed themes/SuiteP/css/SticCustom/style.scss > /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css && cp /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css /application/sinergiacrm/cache/themes/SuiteP/css/SticCustom/style.css
SticInclude/vendor/scssphp/bin/pscss -s compressed themes/SuiteP/css/SticCustom/style.scss > /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css && cp /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css /application/sinergiacrm/cache/themes/SuiteP/css/SticCustom/style.css

# echo "Generating css for Dawn subtheme"
# SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Dawn/style.scss > /application/sinergiacrm/themes/SuiteP/css/Dawn/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Dawn/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Dawn/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Dawn/style.css"

# echo "Generating css for Dusk subtheme"
# docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Dusk/style.scss > /application/sinergiacrm/themes/SuiteP/css/Dusk/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Dusk/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Dusk/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Dusk/style.css"

# echo "Generating css for Day subtheme"
# docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Day/style.scss > /application/sinergiacrm/themes/SuiteP/css/Day/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Day/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Day/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Day/style.css"

# echo "Generating css for Night subtheme"
# docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Night/style.scss > /application/sinergiacrm/themes/SuiteP/css/Night/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Night/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Night/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Night/style.css"

# echo "Generating css for Noon subtheme"
# docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Noon/style.scss > /application/sinergiacrm/themes/SuiteP/css/Noon/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Noon/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Noon/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Noon/style.css"

# Delete tmpSrc directory and SuiteP-Icon-Font repository
rm -rf tmpSrc