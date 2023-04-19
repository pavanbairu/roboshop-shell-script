#setup nodejs repo
echo -e "\e[36m setup nodejs repo \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#Install NodeJS
echo -e "\e[36m install nodejs \e[0m"
yum install nodejs -y

# Add application User
echo -e "\e[36m add application user \e[0m"
useradd roboshop

# create a new directory
echo -e "\e[36m create a new directory \e[0m"
rm -rf /app
mkdir /app

# download the application content
echo -e "\e[36m download the application content \e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

#download the dependencies
echo -e "\e[36m download the dependencies \e[0m"
npm install

# created the user.service file and copied it
echo -e "\e[36m created the user.service file and copied it \e[0m"
cp /home/centos/roboshop-shell-script/user.service /etc/systemd/system/user.service

# load the service
echo -e "\e[36m load the service \e[0m"
systemctl daemon-reload

# start the service
echo -e "\e[36m start the service \e[0m"
systemctl enable user
systemctl restart user

#we have setup the mongo repo and copying it
echo -e "\e[36m setup the mongo repo and copying it \e[0m"
cp /home/centos/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo

#need to install mongodb shell
echo -e "\e[36m install mongodb shell \e[0m"
yum install mongodb-org-shell -y

# load schema
echo -e "\e[36m load schema \e[0m"
mongo --host mongodb-dev.pavanbairu.tech </app/schema/user.js
