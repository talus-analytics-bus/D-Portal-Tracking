# Fetch data ZIP from https://iati-data-dump.codeforiati.org/

echo Starting import
BASEDIR=$(dirname $0)
ORIGDIR=${PWD}
cd $BASEDIR;

d=`date +%Y%m%d`
iatifnbase='iati_'$d'.zip'
iatifn=$iatifnbase'.zip'

set +e

if [ ! -s $iatifnbase]
then
  echo IATI data directory not found
  if [ ! -s $iatifn ]
  then
    echo Getting IATI ZIP
    curl -X GET "https://gitlab.com/codeforIATI/iati-data/-/archive/main/iati-data-main.zip" -L -o $iatifn
  fi
  echo Unzipping IATI data
  unzip $iatifn -d $iatifnbase
fi

cd ../..

bash ../bin/dstore-reset

for directory in cache/bulk/$iatifnbase/iati-data-main/data/*; do
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