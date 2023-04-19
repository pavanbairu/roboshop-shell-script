script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh
rabbitmq_appuser_password=$1

# install the python
echo -e "\e[36m install python \e[0m"
yum install python36 gcc python3-devel -y

# add the application user
echo -e "\e[36m add the application user \e[0m"
useradd ${app_user}

# create the directory
echo -e "\e[36m create the directory \e[0m"
rm -rf /app
mkdir /app

# downlaod the application code
echo -e "\e[36m downlaod the application code \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

#download the dependencies
echo -e "\e[36m download the dependencies \e[0m"
pip3.6 install -r requirements.txt

# created the payment service and copying it
echo -e "\e[36m setup the payment service and copying it \e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

# Load the service.
echo -e "\e[36m Load the service \e[0m"
systemctl daemon-reload

# start the service
echo -e "\e[36m start the service \e[0m"
systemctl enable payment
systemctl restart payment
