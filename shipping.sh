script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo Input MySQL root password is missing
  exit
fi

component=shipping
schema_setup=mysql
func_java