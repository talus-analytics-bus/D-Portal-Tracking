# import_iati_raw.sh
# Same as import_iati.sh but does not run clean-records.sql after initial
# data import
# Disable exit on non 0
set +e

echo Getting IATI ZIP
if [ ! -s data ]
then
  wget -O iati.zip https://www.dropbox.com/s/kkm80yjihyalwes/iati_dump.zip?dl=1
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

# TODO clone current GHS Tracking database, copy sqlite db file to GHS-T repo,
# update config file, delete existing flows data, etc. all with code.
# sqlite3 db/dstore.sqlite ".read sql/create-indexes.sql" && \
# cd ../../../../ghs-tracking-api/ && \
# pipenv run python repair_sqlite_titles_descs.py;

echo 'Done!'
