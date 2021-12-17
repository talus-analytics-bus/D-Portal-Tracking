echo Starting post-import
BASEDIR=$(dirname $0)
ORIGDIR=${PWD}

# update/delete some table data, create indexes
cd $BASEDIR;
cd ../..
sqlite3 db/dstore.sqlite ".read sql/clean-records-no-delete.sql";
sqlite3 db/dstore.sqlite ".read sql/create-indexes.sql";
cd $ORIGDIR;
echo Ending post-import
