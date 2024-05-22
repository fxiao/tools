#!/usr/bin/env bash

#Funciont: Backup website and mysql database
#Author: licess
#Website: https://lnmp.org

#IMPORTANT!!!Please Setting the following Values!

#0 * * * * /bin/bash /root/.mysql_backup.sh > /dev/null

Backup_Home="/data/backup/"
DayBackupHome="/data/day_backup/"
MyCnfFile="/root/.my.cnf"

MySQL_Dump="/usr/local/mysql/bin/mysqldump"
######~Set Directory you want to backup~######
#Backup_Dir=("/home/wwwroot/vpser.net" "/home/wwwroot/lnmp.org")

######~Set MySQL Database you want to backup~######
Backup_Database=("y8")

######~Set MySQL UserName and password~######
MYSQL_UserName='root'
MYSQL_PassWord=''

####### ~/.my.cnf MyCnfFile
#[client]
#user=root
#password='password'
########

######~Enable Ftp Backup~######
Enable_FTP=1
# 0: enable; 1: disable
######~Set FTP Information~######
FTP_Host='1.2.3.4'
FTP_Username='vpser.net'
FTP_Password='yourftppassword'
FTP_Dir="backup"

#Values Setting END!

TodayWWWBackup=www-*-$(date +"%Y%m%d").tar.gz
TodayDBBackup=db-*-$(date +"%Y%m%d%H%M%S").sql.gz
OldWWWBackup=www-*-$(date -d -3day +"%Y%m%d").tar.gz
OldDBBackup=db-*-$(date -d -3day +"%Y%m%d%H%M%S").sql.gz

CuTime=$(date +"%Y%m%d%H%M%S")

#Backup_Dir()
#{
    #Backup_Path=$1
    #Dir_Name=`echo ${Backup_Path##*/}`
    #Pre_Dir=`echo ${Backup_Path}|sed 's/'${Dir_Name}'//g'`
    #tar zcf ${Backup_Home}www-${Dir_Name}-$(date +"%Y%m%d").tar.gz -C ${Pre_Dir} ${Dir_Name}
#}
Backup_Sql()
{
    #${MySQL_Dump} -u$MYSQL_UserName -p$MYSQL_PassWord $1 | gzip > ${Backup_Home}db-$1-${CuTime}.sql.gz
    ${MySQL_Dump} --defaults-extra-file=${MyCnfFile} $1 | gzip > ${Backup_Home}db-$1-${CuTime}.sql.gz



    if [ $(date +"%H") = "00" ]; then
        echo "永久备份..."
        cp ${Backup_Home}db-$1-${CuTime}.sql.gz ${DayBackupHome}db-$1-${CuTime}.sql.gz
    fi

}

if [ ! -f ${MySQL_Dump} ]; then  
    echo "mysqldump command not found.please check your setting."
    exit 1
fi

if [ ! -d ${Backup_Home} ]; then  
    mkdir -p ${Backup_Home}
fi

if [ ! -d ${DayBackupHome} ]; then  
    mkdir -p ${DayBackupHome}
fi

if [ ${Enable_FTP} = 0 ]; then
    type lftp >/dev/null 2>&1 || { echo >&2 "lftp command not found. Install: centos:yum install lftp,debian/ubuntu:apt-get install lftp."; }
fi

#echo "Backup website files..."
#for dd in ${Backup_Dir[@]};do
    #Backup_Dir ${dd}
#done

echo "备份数据库..."
for db in ${Backup_Database[@]};do
    Backup_Sql ${db}
done

echo "删除旧的备份文件..."
#rm -f ${Backup_Home}${OldWWWBackup}
rm -f ${Backup_Home}${OldDBBackup}

if [ ${Enable_FTP} = 0 ]; then
    echo "Uploading backup files to ftp..."
    cd ${Backup_Home}
    lftp ${FTP_Host} -u ${FTP_Username},${FTP_Password} << EOF
cd ${FTP_Dir}
mrm ${OldWWWBackup}
mrm ${OldDBBackup}
mput ${TodayWWWBackup}
mput ${TodayDBBackup}
bye
EOF

echo "complete."
fi
