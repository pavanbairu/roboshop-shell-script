# created the mongodb repo file
echo -e "\e[36m setup the mongodb repo file\e[0m"
cp /home/centos/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m install mongodb \e[0m"
yum install mongodb-org -y

# need to replace the ip address 127.0.0.1 with 0.0.0.0 in cd /etc/mongo.conf location
echo -e "\e[36m need to change the mongodb listening address\e[0m"
sed -i -e 's|127.0.0.0|0.0.0.0|' /etc/mongod.conf

echo -e "\e [36m start mongodb \e[0m"
systemctl enable mongod
systemctl restart mongod