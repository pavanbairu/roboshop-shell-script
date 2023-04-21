script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "${rabbitmq_appuser_password}" ]; then
  echo Input rabbitmq_appuser_password is missing
  exit
fi

func_print "setup erlang repo"
curl -sL https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "Install ErLang"
yum install erlang -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "setup the rabbitmq repo "
curl -sL https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "install rabbitmq server "
yum install rabbitmq-server -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "start the service"
systemctl enable rabbitmq-server &>>$logfile
systemctl restart rabbitmq-server &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "add app user"
rabbitmqctl list_user | grep {app_user} # to check the user exists or not
if [ $? -ne 0 ]; then
  rabbitmqctl add_user {app_user} ${rabbitmq_appuser_password} &>>$logfile
fi

func_print "configuring password permissions for ${app_user}"
rabbitmqctl set_permissions -p / ${app_user} ".*" ".*" ".*" &>>$logfile
func_status_check $? #to checck the status of previous command or stage
