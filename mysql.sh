script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo Input mysql_root_password is missing
  exit 1
fi

func_print "setup the mysql repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "disable mqsql 8 version"
dnf module disable mysql -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "install mqsql connector"
yum install mysql-community-server -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "start the service"
systemctl enable mysqld &>>$logfile
systemctl restart mysqld &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "change the default root password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$logfile
func_status_check $? #to checck the status of previous command or stage