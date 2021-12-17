echo Starting post-db-create
BASEDIR=$(dirname $0)
ORIGDIR=${PWD}

# add tables/cols (assumes `ghs-tracking-api` repository cloned)
cd $BASEDIR;
cd ../../../../ingest/assistance/iati/sqlite/create-scripts/ && \
for FILE in *; do echo Running $FILE && sqlite3 ../../../../../D-Portal-Tracking/dstore/db/dstore.sqlite ".read $FILE"; done
cd $ORIGDIR;
echo Ending post-db-create