BASEDIR=$(dirname $0)
ORIGDIR=${PWD}
cd $BASEDIR;

cd ../..

sqlite3 db/dstore.sqlite ".read sql/clean-records-no-delete.sql" && \
sqlite3 db/dstore.sqlite ".read sql/create-indexes.sql";

cd ../../ingest/assistance/iati/sqlite/create-scripts/ && \
for FILE in *; do sqlite3 ../../../../../D-Portal-Tracking/dstore/db/dstore.sqlite ".read $FILE"; done

cd $ORIGDIR;
