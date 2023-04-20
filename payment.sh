script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "${rabbitmq_appuser_password}" ]; then
  echo Input rabbitmq_appuser_password is missing
  exit
fi

component=payment
func_python