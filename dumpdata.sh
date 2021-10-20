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
            exit
            ;;
        -l) arg_label="${value}_";;
        -f) arg_dblistfile="$value";;
        -a) arg_do_all=true;;
        -q) arg_isquite=true;;
    esac
done

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


export PATH="/usr/local/opt/mysql-client/bin:$PATH"
filedate="`date +%d%m%Y%H%M%S`"
filedir="./data/${arg_label}${filedate}"
#filenameprefix="data_dump_${arg_label}_${filedate}"
alldumpfile="${filedir}/all.sql"

mkdir -p "$filedir"

hostname=${remotehostname}
password=${remotepassword}

while read db
do
    if [ -z "$db" ] ||  [[ "${db}" == \#* ]]
    then
        continue
    fi   
    echo "Taking backup of \"$db\" ..."
#    PROMPT_COMMAND='echo -en "\033]0; Backup of $("db") \a"'
    dbdumpfile="${filedir}/${db}.sql"

#   mysqldump --no-create-info -u admin --password="$password" --host "$hostname" elab | 
    mysqldump -u admin --password="$password" --host "$hostname" "${db}" | 
	tee "$alldumpfile" "$dbdumpfile"

    status=$?
    if [[ "$status" != 0 ]]
    then
	echo -e "\033[1;31m Failed to make backup of $db \033[0m"
    else
        echo "Backup of $db done"
    fi
#        if [[ "$arg_isquite" == "true" ]]
#        then 
#            cat > "$filepath"; 
#        else 
#            tee "$filepath"; 
#        fi
done <<< "$dblist"

pwd
rm -f ./data/latest
echo  ln -fs "./`basename ${filedir}`" ./data/latest
ln -fs "./`basename ${filedir}`" ./data/latest
echo "Dump Directory : ${filedir}"
