#/bin/bash
#host
host=db.zhangyongqiao.com
#用户名
username=root
#密码
password=root_password
#将要备份的数据库
database_name=test
#备份保存路径
backup_path=~/backup/mysql
backup_filename=$backup_path/latest.sql;
backup_text_filename=$backup_path/latest.txt;
 
#保存备份文件最多个数
count=20

#日期
date_time=`date +%Y-%m-%d-%H-%M`
 
#如果文件夹不存在则创建
if [ ! -d $backup_path ]; 
then 
 mkdir -p $backup_path; 
fi
#开始备份
if [ -z "$1" ];
then
  database_name=--all-databases;
  backup_filename=$backup_path/all-$date_time;
  
else
  database_name=$1;
  backup_filename=$backup_path/$database_name-$date_time;
fi
#mysqldump -u $username -p$password --master-data=2 --default-character-set=utf8 --single-transaction --all-databases  > $backup_path/$database_name-$date_time.sql
echo $backup_filename $database_name
mysqldump -h$host -u $username -p$password --single-transaction $database_name > $backup_filename.sql
#开始压缩
cd $backup_path
tar -zcvf $backup_filename.tar.gz $backup_filename.sql
#删除源文件
rm -rf $backup_filename.sql
#更新备份日志
echo "create $backup_filename.sql.tar.gz" >> $backup_path/dump.log
 
#找出需要删除的备份
delfile=`ls -l -crt $backup_path/*.tar.gz | awk '{print $9 }' | head -1`
                                                                                    
#判断现在的备份数量是否大于阈值
number=`ls -l -crt $backup_path/*.tar.gz | awk '{print $9 }' | wc -l`
 
if [ $number -gt $count ]
then
 #删除最早生成的备份，只保留count数量的备份
 rm $delfile
 #更新删除文件日志
 echo "delete $delfile" >> $backup_path/dump.log
fi
