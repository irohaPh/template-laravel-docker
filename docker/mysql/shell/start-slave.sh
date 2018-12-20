#!/bin/sh

# depends_onの設定しておけば気にならないけど念の為masterの起動を待つ
while ! mysqladmin ping -h mysql --silent; do
  sleep 1
done

# masterをロックする
mysql -u root --password=root -h mysql -e "RESET MASTER;"
mysql -u root --password=root -h mysql -e "FLUSH TABLES WITH READ LOCK;"

# masterのDB情報をDumpする
# ここでは --all-databases にしてるけど用途に応じて必要なDBだけにしていいと思う
mysqldump -uroot -proot -h mysql --all-databases --master-data --single-transaction --flush-logs --events > /tmp/master_dump.sql
# 特定のDBだけにする場合はこんな感じ(my.cnfのreplica-do-dbも忘れずに設定すること)
# mysqldump -uroot -h mysql データベース名 --master-data --single-transaction --flush-logs --events > /tmp/master_dump.sql

# dumpしたmasterのDBをslaveにimportする
mysql -u root --password=root -e "STOP SLAVE;";
mysql -u root --password=root < /tmp/master_dump.sql

# masterに繋いで bin-logのファイル名とポジションを取得する
log_file=`mysql -u root --password=root -h mysql -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'`
pos=`mysql -u root --password=root -h mysql -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}'`

# slaveの開始
mysql -u root --password=root -e "RESET SLAVE";
mysql -u root --password=root -e "CHANGE MASTER TO MASTER_HOST='mysql', MASTER_USER='root', MASTER_PASSWORD='root', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos};"
mysql -u root --password=root -e "START SLAVE"

# masterをunlockする
mysql -u root --password=root -h mysql -e "UNLOCK TABLES;"