script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh

# install golang
echo -e "\e[36m install golang \e[0m"
yum install golang -y

# add application user
echo -e "\e[36m add application user \e[0m"
useradd ${app_user}

# create the directory
echo -e "\e[36m create the directory \e[0m"
rm -rf /app
mkdir /app

# download the application code
echo -e "\e[36m download the application code \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

# download the dependencies and build the software
echo -e "\e[36m download the dependencies and build the software \e[0m"
cd /app
go mod init dispatch
go get
go build

# setup dispatch service and copying it
echo -e "\e[36m setup dispatch service and copying it \e[0m"
cp ${script_path}/dispatch.service /etc/yum.repos.d/dispatch.service

# load the service
echo -e "\e[36m load the service \e[0m"
systemctl daemon-reload

# start the service
echo -e "\e[36m start the service \e[0m"
systemctl enable dispatch
systemctl start dispatch
