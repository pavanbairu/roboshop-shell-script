script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh

# created the catalogue.service file
echo -e "\e[36m setup the systemd service and copying it\e[0m"
cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service

#Setup NodeJS repos. Vendor is providing a script to setup the repos.
echo -e "\e[36m sSetup NodeJS repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#install nodejs
echo -e "\e[36m install nodejs \e[0m"
yum install nodejs -y

#Add application User
echo -e "\e[36m Add application User \e[0m"
useradd ${app_user}

#creating a directory
echo -e "\e[36m creating a directory \e[0m"
rm -rf /app
mkdir /app

# download the code to above directory
echo -e "\e[36m download the code to above directory \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

# download the dependencies
echo -e "\e[36m download the dependencies \e[0m"
npm install

#reload the configuration
echo -e "\e[36m reload the configuration \e[0m"
systemctl daemon-reload

#enable and starting the service
echo -e "\e[36m enable and starting the service \e[0m"
systemctl enable catalogue
systemctl start catalogue

# now we need to load schema to function the mongodb
# created the mongo repo file
echo -e "\e[36m setup mongo repo file and copying it\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

# install mongodb client
echo -e "\e[36m install mongodb client\e[0m"
yum install mongodb-org-shell -y

# loading the schema
echo -e "\e[36m loading the schema \e[0m"
mongo --host mongodb-dev.pavanbairu.tech </app/schema/catalogue.js

