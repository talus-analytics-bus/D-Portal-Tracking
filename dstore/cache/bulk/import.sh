#!/bin/bash
# Fetch data ZIP from https://iati-data-dump.codeforiati.org/
echo Starting import
BASEDIR=$(dirname "$0")
ORIGDIR=${PWD}
cd "$BASEDIR" || exit

d=$(date +%Y%m%d)
iatifnbase='iati_'"$d"
iatifn="$iatifnbase"'.zip'

set +e
echo Checking for ZIP file named "$iatifn"
if [ ! -s "$iatifnbase" ]; then
  echo IATI data directory not found
  if [ ! -s "$iatifn" ]; then
    echo Getting IATI ZIP
    curl -X GET "https://gitlab.com/codeforIATI/iati-data/-/archive/main/iati-data-main.zip" -L -o "$iatifn"
  fi
  # Unzip or exit with error if invalid
  echo Unzipping IATI data
  unzip "$iatifn" -d "$iatifnbase" || exit
fi

cd ../..

bash ../bin/dstore-reset

for directory in cache/bulk/"$iatifnbase"/iati-data-main/data/*; do
  echo ''
  echo Directory:
  echo "$directory"
  for filename in "$directory"/*; do
    echo "$filename"
    if [ -s "$filename" ]; then
      node js/cmd import "$filename"
    fi
  done
done

cd "$ORIGDIR" || exit
echo Ending import
