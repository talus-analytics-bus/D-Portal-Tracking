BASEDIR=$(dirname $0)
ORIGDIR=${PWD}
cd $BASEDIR;


set +e

echo Getting IATI ZIP
if [ ! -s data ]
then
  if [ ! -s iati.zip ]
  then
    curl -X GET "https://www.dropbox.com/s/kkm80yjihyalwes/iati_dump.zip?dl=1" -L -o iati.zip
  fi
  unzip iati.zip
fi

cd ../..

bash ../bin/dstore-reset

for directory in cache/bulk/data/*; do
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
