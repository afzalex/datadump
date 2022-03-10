## Setting up my data dump


### Start docker mysql
```sh
# to add here
```

### Install mysql client
```sh
brew install mysql-client
echo 'export PATH="/usr/local/opt/mysql-client/bin:$PATH"' >> ~/.bash_profile
```

### Setup local auto login 
```sh
cat <<EOF > ~/.my.cnf
[client]
host=127.0.0.1
port=3306
user=root
password="password#123"
EOF

```




---
### scratch
```sh
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
pip install mysqlclient
```

```
mysql -u admin --password='somepassword01' --host www.somehost.com -A
```


```
echo 'show databases' | mysql -u admin --password='somepassword01' --host www.somehost.com -A | while read db; do echo hola $db; done;
```

```
start=`date`; mysqldump -u admin --password='somepassword01' --host www.somehost.com elab; end=`date`
```