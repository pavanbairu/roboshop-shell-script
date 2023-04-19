script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh

component=user
echo calling function
func_nodejs

#we have setup the mongo repo and copying it
echo -e "\e[36m setup the mongo repo and copying it \e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

#need to install mongodb shell
echo -e "\e[36m install mongodb shell \e[0m"
yum install mongodb-org-shell -y

# load schema
echo -e "\e[36m load schema \e[0m"
mongo --host mongodb-dev.pavanbairu.tech </app/schema/user.js
