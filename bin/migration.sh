#!/bin/bash

#
# This is a small script to automate the migration of the ownCloud content from sphinx-doc to Antora
# Written by Matthew Setter <matthew@matthewsetter.com>
# Copyright (c) 2018 ownCloud.
#

#
# Assuming that the required Antora file structure has already been created,
# the script will find all the manuals in it, and convert the reStructuredText files
# to AsciiDoc format, do some cleaning up, where possible, and generate a navigation
# file for each one.
#
converter_script=../../../converter.phar

#
# Migrate a manual, making as many changes to it as possible. 
#
function migrate_manual()
{
  dir_name=$1

  echo
  echo "> Migrating $dir_name."
  cd $dir_name || return

  # Convert files from reStructuredText to AsciiDoc
  echo
  echo "> Converting files from reStructuredText to AsciiDoc"
  find ./ -type f -name "*.rst" -exec pandoc -s -S {} -t asciidoc -o {}.adoc \;

  echo "> Removing original reStructuredText files"
  find ./ -type f -name "*.rst" -exec rm {} \;

  # Remove .rst file extension from the converted files
  echo
  echo "> Removing .rst file extension from the converted files"
  find ./ -type f -name "*.rst.adoc" -exec rename --force s/.rst//g {} \;

  echo
  echo "> Retrieving all AsciiDoc files"
  find ./pages/ -type f -name "*.adoc" > adoc_files.txt
  echo Found $( wc -l adoc_files.txt | wc -l | tr -d ' ' )

  # Converting Sphinx-Doc Backticks to AsciiDoc
  echo
  echo "> Converting Sphinx-Doc Backticks to AsciiDoc format"
  xargs -I {} rpl '' \` {} < adoc_files.txt

  # Correct asset paths
  echo
  echo "> Correcting asset paths"
  xargs -I {} rpl ..//owncloud-docs/admin_manual/_images /owncloud-docs/_images {} < adoc_files.txt
  xargs -I {} rpl /owncloud-docs/admin_manual/_images /owncloud-docs/_images {} < adoc_files.txt
  xargs -I {} rpl image:images image:/owncloud-docs/_images {} < adoc_files.txt

  # Generate navigation menu
  echo
  echo "> Generating a navigation menu"
  php ../../../converter.phar navigation:build-from-files < adoc_files.txt > nav.adoc

  rm adoc_files.txt

  # Fix up generated navigation menus
  sed -i '' 's/\*\*\([a-zA-Z ]*\)\*\*/\*\*\1\*\*/g' nav.adoc
  sed -i '' 's/\.\/pages\/\///g' nav.adoc
  sed -i '' '/^** $/d' nav.adoc
  sed -i '' "s/* Pages/* $( echo $dir_name | tr '_' ' ' )/g" nav.adoc

  cd - || exit
  echo "> Finished migrating $dir_name."
}

export -f migrate_manual

# find all manuals
ls | xargs -I {} bash -c 'migrate_manual $@' _ {}
