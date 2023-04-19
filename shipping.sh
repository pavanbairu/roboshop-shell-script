script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo Input MySQL root password is missing
  exit
fi

# need to install the java and it comes within maven package
echo -e "\e[36m install maven \e[0m"
yum install maven -y

#add application user
echo -e "\e[36m add application user \e[0m"
useradd ${app_user}

# create the new directory
echo -e "\e[36m create the new directory \e[0m"
rm -rf /app
mkdir /app

# download the application code
echo -e "\e[36m download the application code \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

# download the dependencies and build application
echo -e "\e[36m download the dependencies and build application \e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

# created the shipping service and copying it
echo -e "\e[36m setup the shipping service and copying it \e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

# Load the service.
echo -e "\e[36m Load the service \e[0m"
systemctl daemon-reload

# start the service
echo -e "\e[36m start the service \e[0m"
systemctl enable shipping
systemctl restart shipping

# need to load the mqsql schema to function the db
# setup mqsql repo file and copying it
echo -e "\e[36m setup mqsql repo file and copying it \e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

# install the mysql client
echo -e "\e[36m install the mysql client \e[0m"
yum install mysql -y

# load schema
echo -e "\e[36m load schema \e[0m"
mysql -h mysql-dev.pavanbairu.tech -uroot -p${mysql_root_password} < /app/schema/shipping.sql

# restart the service
echo -e "\e[36m restart the service \e[0m"
systemctl restart shipping
