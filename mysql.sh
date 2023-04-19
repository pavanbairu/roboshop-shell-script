script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory
mysql_root_password=$1
# created the mysql.repo
echo -e "\e[36m setup the mysql repo \e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

# mysql centos comes with default mysql 8 we need to disable it and use the 5.7 version
echo -e "\e[36m disable mqsql 8 version \e[0m"
dnf module disable mysql -y

# install mysql connector
echo -e "\e[36m install mqsql connector \e[0m"
yum install mysql-community-server -y

#start the service
echo -e "\e[36m start the service \e[0m"
systemctl enable mysqld
systemctl restart mysqld

# need to change the default root password
echo -e "\e[36m change the default root password \e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}