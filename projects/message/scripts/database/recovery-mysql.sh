#/bin/bash
#host
host=db.zhangyongqiao.com
#用户名
username=root
#密码
password=root_password
#将要备份的数据库
database_name=test


 
#保存备份文件最多个数
count=20
#备份保存路径
backup_path=~/backup/mysql


#备份最新的数据文件
backup_filename=latest.txt
if [ -z "$1" ];
then
  backup_filename=$backup_path/latest.txt
else
    backup_filename=$1
fi

#日期
date_time=`date +%Y-%m-%d-%H-%M`

#如果文件夹不存在则创建
if [ ! -d $backup_path ]; 
then 
 echo "backup path found" $backup_path  $date_time; 
fi

if [ ! -f $backup_filename ]; 
then 
 echo "backup file not found" $backup_filename
fi

#开始恢复数据从latest.txt
#mysqlimport -h$host -u$username -p$password $database_name  $backup_filename
