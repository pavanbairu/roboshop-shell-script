# set up repo
echo -e "\e[36m setup erlang repo\e[0m"
curl -sL https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

# Install ErLang
echo -e "\e[36m Install ErLang\e[0m"
yum install erlang -y

# setup the rabbitmq repo
echo -e "\e[36m setup the rabbitmq repo \e[0m"
curl -sL https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

# install rabbitmq server
echo -e "\e[36m install rabbitmq server \e[0m"
yum install rabbitmq-server -y

# start the service
echo -e "\e[36m start the service\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

# rabbitmq comes with default username and password guest:guest. lets change it
echo -e "\e[36m change default username and password\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
