#!/bin/bash

source configurations.sh

for argument;
do #syntactic sugar for: for argument in "$@"; do
    key=${argument%%=*}
    value=${argument#*=}
    case "$key" in
        -h) 
cat <<EOT
-l=<label string>       Label for output directory
-f=<db list file>       File containing list of databses
-a                      Execute dump for all databases
-q                      Don't open db list in editor before execution
EOT
            ;;
        -l) arg_label="${value}_";;
        -f) arg_dblistfile="$value";;
        -a) arg_do_all=true;;
        -q) arg_isquite=true;;
    esac
done

#read -r -d '' dblist <<- EOM
#elab
#
#Tenant845242_elab
#EOM

dblistfile="./dblist.dat"


if ! [[ -z "$arg_dblistfile" ]]
then
    dblistfile="$arg_dblistfile"
    echo "Database List File : ${dblistfile}"
    dblist=`cat "$dblistfile"`
elif ! [[ $arg_do_all == true ]]
then 
    cp "$dblistfile" "/tmp/$dblistfile"
    temp_dblistfile_time=`date -r /tmp/dblist.dat +%s`
    vim "/tmp/$dblistfile"
    if [[ $temp_dblistfile_time == `date -r /tmp/dblist.dat +%s` ]]
    then
        exit
    fi
    dblist=`cat /tmp/$dblistfile`
    echo "Database List From Input"
else
    echo "Database List File : ${dblistfile}"
    dblist=`cat "$dblistfile"`
fi
