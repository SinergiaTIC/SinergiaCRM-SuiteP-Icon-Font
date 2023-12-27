#!/bin/bash

# Script for rebuilding SinergiaCRM icon fonts and stylesheets

# This script is used to rebuild the SinergiaCRM icon fonts and stylesheets. 
# It is adapted from a script found at https://github.com/salesagility/SuiteP-Icon-Font. 
# This script should be run without parameters from the SticUtils/Icons folder.

# Dependencies:
# - git for cloning the SuiteP-Icon-Font repository
# - svgo for compressing and copying SticIcons to the tmp folder
# - icon-font-generator for creating the icon font from the SVG files
# - scssphp for compiling the SCSS sources into CSS

# Instructions:
# 1. Ensure that all dependencies are installed and available in the PATH.
# 2. Navigate to the SticUtils/Icons folder and run bash InstallNewIcons.sh

# Usage of SuiteP-Icon-Font repository:
# The SuiteP-Icon-Font repository (https://github.com/salesagility/SuiteP-Icon-Font) is used 
# to obtain the icon files required for the SinergiaCRM icon fonts and stylesheets.
# The repository is cloned to the SuiteP-Icon-Font which is deleted at the end of the script

# Adding a new icon:
# To add a new icon to SinergiaCRM, copy it to the SticUtils/Icons/SticIcons folder. 
# It is a good idea to start with a copy of one of the existing icons, rename it, modify it with Inkscape, 
# and save it as a plain SVG file.

# Remove any existing tmpSrc directory and create a new one
rm -rf tmpSrc
mkdir -p tmpSrc

# Update repository
git pull

# Compress and copy SuiteP Icons to tmp folder
svgo -f src/ tmpSrc

# Compress and copy SticSrc to tmp folder
svgo -f SticSrc/ -o tmpSrc

# Create font from ./src folder
# icon-font-generator tmpSrc/*svg -o /application/sinergiacrm/themes/SuiteP/css/suitep-base/ --mono --center -p suitepicon --csspath /application/sinergiacrm/themes/SuiteP/css/suitep-base/suitepicon-glyphs.scss --name suitepicon

icon-font-generator tmpSrc/*svg -o suitepicon --mono --center -p suitepicon --csspath suitepicon/suitepicon-glyphs.scss --name suitepicon 

# cp -r suitepicon/* /application/sinergiacrm/themes/SuiteP/css/suitep-base/
docker cp suitepicon/. sw-php-fpm:/application/sinergiacrm/themes/SuiteP/css/suitep-base/

# Regenerate style.css from scss sources to activate new suitepicon classes
echo "Generating css for Stic subtheme"
# /application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Stic/style.scss > /application/sinergiacrm/themes/SuiteP/css/Stic/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Stic/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Stic/style.css
docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Stic/style.scss > /application/sinergiacrm/themes/SuiteP/css/Stic/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Stic/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Stic/style.css"

echo "Generating css for SticCustom subtheme"
docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.scss > /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css && cp /application/sinergiacrm/themes/SuiteP/css/SticCustom/style.css /application/sinergiacrm/cache/themes/SuiteP/css/SticCustom/style.css"

echo "Generating css for Dawn subtheme"
docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Dawn/style.scss > /application/sinergiacrm/themes/SuiteP/css/Dawn/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Dawn/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Dawn/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Dawn/style.css"

echo "Generating css for Dusk subtheme"
docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Dusk/style.scss > /application/sinergiacrm/themes/SuiteP/css/Dusk/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Dusk/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Dusk/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Dusk/style.css"

echo "Generating css for Day subtheme"
docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Day/style.scss > /application/sinergiacrm/themes/SuiteP/css/Day/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Day/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Day/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Day/style.css"

echo "Generating css for Night subtheme"
docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Night/style.scss > /application/sinergiacrm/themes/SuiteP/css/Night/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Night/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Night/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Night/style.css"

echo "Generating css for Noon subtheme"
docker exec -it sw-php-fpm  /bin/bash -c  "/application/sinergiacrm/SticInclude/vendor/scssphp/bin/pscss -s compressed /application/sinergiacrm/themes/SuiteP/css/Noon/style.scss > /application/sinergiacrm/themes/SuiteP/css/Noon/style.css && mkdir -p /application/sinergiacrm/cache/themes/SuiteP/css/Noon/style.css && cp /application/sinergiacrm/themes/SuiteP/css/Noon/style.css /application/sinergiacrm/cache/themes/SuiteP/css/Noon/style.css"

# Delete tmpSrc directory and SuiteP-Icon-Font repository
rm -rf tmpSrc