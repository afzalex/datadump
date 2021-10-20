#!/bin/bash 

source configurations.sh

datadir=$1

if [ -z "$datadir" ]
then
  echo Data directory not provided
  exit
fi
if [ ! -d "$datadir" ] 
then
  echo Data directory \"$datadir\" does not exist
  exit
fi 
pushd .  > /dev/null 2>&1

cd $datadir
retval=$?
if [ $retval -ne 0 ]; then
    echo "Return code was not zero but $retval"
fi

ls |
grep -Ev 'all\.sql' | 
grep -oE '^[a-zA-Z0-9_-]+' | 
while read db
do 
  echo $db - PROCESSING 
  mysql -e "drop database if exists \`$db\`"
  sleep 1
  [ -d "${MYSQL_DATA_DIRECTORY}/$db" ] && rm -rf "${MYSQL_DATA_DIRECTORY}/$db"
  mysql -e "create database \`$db\`"
  mysql "$db" -e "source ./$db.sql"
  retval=$?
  if [ $retval -ne 0 ]
  then
    echo $db - FAILED
  else
    echo $db - SUCCESS
  fi
done

popd > /dev/null 2>&1
