app_user=roboshop

print(){
  echo -e "\e[36m $1 \e[0m"
}



schema_setup() {

   if [ "$schema_setup" == "mongo" ]; then
    # now we need to load schema to function the mongodb
    # created the mongo repo file
    print "setup mongo repo file and copying it"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    # install mongodb client
    print "install mongodb client"
    yum install mongodb-org-shell -y

    # loading the schema
    print "loading the schema"
    mongo --host mongodb-dev.pavanbairu.tech </app/schema/catalogue.js
  fi
}
func_nodejs(){

  # setup node js repo
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

  schema_setup

}