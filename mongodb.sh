script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh

func_print "setup the mongodb repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "install mongodb"
yum install mongodb-org -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "need to change the mongodb listening address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "start mongodb"
systemctl enable mongod &>>$logfile
systemctl restart mongod &>>$logfile
func_status_check $? #to checck the status of previous command or stage