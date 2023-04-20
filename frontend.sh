script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh

func_print "install nginx"
yum install nginx -y &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "start nginx"
systemctl enable nginx &>>$logfile
systemctl start nginx &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "copying roboshop.conf file"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "removing the existing content available in the below location"
rm -rf /usr/share/nginx/html/* &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "download the application code"
curl -L -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$logfile
cd /usr/share/nginx/html/ &>>$logfile
unzip /tmp/frontend.zip &>>$logfile
func_status_check $? #to checck the status of previous command or stage

func_print "restarting nginx"
systemctl restart nginx &>>$logfile
func_status_check $? #to checck the status of previous command or stage




