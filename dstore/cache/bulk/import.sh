# Fetch data ZIP from https://iati-data-dump.codeforiati.org/

echo Starting import
BASEDIR=$(dirname $0)
ORIGDIR=${PWD}
cd $BASEDIR;


set +e

echo Getting IATI ZIP
if [ ! -s iati-data-main]
then
  if [ ! -s iati.zip ]
  then
    curl -X GET "https://gitlab.com/codeforIATI/iati-data/-/archive/main/iati-data-main.zip" -L -o iati.zip
  fi
  unzip iati.zip
fi

cd ../..

bash ../bin/dstore-reset

for directory in cache/bulk/iati-data-main/data/*; do
  echo ''
  echo Directory:
  echo $directory
  for filename in $directory/*; do
    echo $filename
    if [ -s $filename ]
    then
      node js/cmd import $filename
    fi
  done
done

cd $ORIGDIR;
echo Ending import