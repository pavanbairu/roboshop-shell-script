app_user=roboshop

func_print(){
  echo -e "\e[36m $1 \e[0m"
}

func_status_check()
{
  if [ $1 -eq 0 ]; then
    echo "\e[32m SUCCESS \e[0m"
  else
    echo "\e[31m FAILURE \e[0m"
    exit
  fi
}
func_schema_setup() {

   if [ "$schema_setup" == "mongo" ]; then
    # now we need to load schema to function the mongodb
    # created the mongo repo file
    func_print "setup mongo repo file and copying it"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    func_status_check $? #to checck the status of previous command or stage

    # install mongodb client
    func_print "install mongodb client"
    yum install mongodb-org-shell -y
    func_status_check $? #to checck the status of previous command or stage

    # loading the schema
    func_print "loading the schema"
    mongo --host mongodb-dev.pavanbairu.tech </app/schema/catalogue.js
    func_status_check $? #to checck the status of previous command or stage
  fi
  if [ "$schema_setup" == "mysql" ]; then

      func_print "setup mqsql repo file and copying it"
      cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
      func_status_check $? #to checck the status of previous command or stage

      func_print "install the mysql client"
      yum install mysql -y
      func_status_check $? #to checck the status of previous command or stage

      func_print "load schema"
      mysql -h mysql-dev.pavanbairu.tech -uroot -p${mysql_root_password} < /app/schema/${component}.sql
      func_status_check $? #to checck the status of previous command or stage
  fi
}

func_app_prereq(){

  # add application user
    func_print "add application user"
    useradd ${app_user}
    func_status_check $? #to checck the status of previous command or stage

    func_print "create directory"
    rm -rf /app
    mkdir /app
    func_status_check $? #to checck the status of previous command or stage

    # download the application code
    func_print "download the application code"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    cd /app
    unzip /tmp/${component}.zip
    func_status_check $? #to checck the status of previous command or stage

}

func_systemd_setup(){

  # created the service and copying it
    func_print "created the ${component} service and copying it"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
    func_status_check $? #to checck the status of previous command or stage

    # start the service
    func_print "start the ${component} service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}
    func_status_check $? #to checck the status of previous command or stage

}

func_nodejs(){

  # setup node js repo
  func_print "setup nodejs"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_status_check $? #to checck the status of previous command or stage

  # install nodejs
  func_print "install nodejs"
  yum install nodejs -y
  func_status_check $? #to checck the status of previous command or stage

  func_app_prereq # calling app user

  # download the dependencies
  func_print "download the dependencies"
  npm install
  func_status_check $? #to checck the status of previous command or stage

  func_schema_setup
  func_systemd_setup

}

func_java(){
  
  # need to install the java and it comes within maven package
  func_print "install maven"
  yum install maven -y
  func_status_check $? #to checck the status of previous command or stage
  
  func_app_prereq # calling app user
  
  # download the dependencies and build application
  func_print "download the dependencies and build application"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar
  func_status_check $? #to checck the status of previous command or stage

  func_schema_setup
  func_systemd_setup
  
}