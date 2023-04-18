# setup node js repo
echo -e "\e[36m setup nodejs\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

# install nodejs
echo -e "\e[36m install nodejs \e[0m"
yum install nodejs -y

# add application user
echo -e "\e[36m add application user \e[0m"
useradd roboshop

echo -e "\e[36m create directory \e[0m"
rm -rf /app
mkdir /app

# download the application code
echo -e "\e[36m download the application code\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

# download the dependencies
echo -e "\e[36m download the dependencies\e[0m"
npm install

# created the cart service and copying it
echo -e "\e[36m created the cart service and copying it \e[0m"
cp /home/centos/roboshop-shell-script/cart.service /etc/systemd/system/cart.service

#Load the service.
echo -e "\e[36m Load the service \e[0m"
systemctl daemon-reload

# start the service
echo -e "\e[36m start the service\e[0m"
systemctl enable cart
systemctl restart cart

