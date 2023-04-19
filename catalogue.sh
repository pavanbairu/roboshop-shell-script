script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh

component=catalogue
echo calling function
func_nodejs

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

