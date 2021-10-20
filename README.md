### Assume you are activating Python 3 venv

```sh
brew install mysql-client
echo 'export PATH="/usr/local/opt/mysql-client/bin:$PATH"' >> ~/.bash_profile
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