BASEDIR=$(dirname $0)
ORIGDIR=${PWD}
cd $BASEDIR;


set +e

echo Getting IATI ZIP
if [ ! -s data ]
then
  if [ ! -s iati.zip ]
  then
    wget -O iati.zip https://www.dropbox.com/s/kkm80yjihyalwes/iati_dump.zip?dl=1
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

sqlite3 db/dstore.sqlite ".read sql/clean-records-no-delete.sql" && \
sqlite3 db/dstore.sqlite ".read sql/create-indexes.sql";


cd ../../ingest/assistance/iati/sqlite/create-scripts/ && \
for FILE in *; do sqlite3 ../../../../../D-Portal-Tracking/dstore/db/dstore.sqlite ".read $FILE"; done

cd $ORIGDIR;
