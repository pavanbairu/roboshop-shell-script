source ${script_path}/common.sh

func_print "setup the redis rep"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "Enable Redis 6.2 from package streams"
dnf module enable redis:remi-6.2 -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "install redis"
yum install redis -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "replace the redis Listen Address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf /etc/redis.conf &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "restart the redis"
systemctl enable redis &>>$logfile
systemctl restart redis &>>$logfile
func_status_check $? #to checck the status of previous command or stage