app_user=roboshop

print(){
  echo -e "\e[36m $1 \e[0m"
}

func_nodejs(){

  # setup node js repo
  echo calling print first time
  print "setup nodejs"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  # install nodejs
  print "install nodejs"
  yum install nodejs -y

  # add application user
  print "add application user"
  useradd ${app_user}

  print "create directory"
  rm -rf /app
  mkdir /app

  # download the application code
  print "download the application code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

  # download the dependencies
  print "download the dependencies"
  npm install

  # created the cart service and copying it
  print "created the ${component} service and copying it"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  #Load the service.
  print "Load the service"
  systemctl daemon-reload

  # start the service
  print "start the ${component} service"
  systemctl enable ${component}
  systemctl restart ${component}

}