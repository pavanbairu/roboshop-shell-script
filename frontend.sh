script=$(realpath "$0") # gives current file path including filename
script_path=$(dirname "$script") # gives the current file directory

echo -e "\e[36m install nginx\e[0m"
yum install nginx -y

echo -e "\e[36m start nginx \e[0m"
systemctl enable nginx
systemctl start nginx

# created the roboshop config file
echo -e "\e[36m copying roboshop.conf file\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

#removing the existing content available in the below location
echo -e "\e[36m removing the existing content available in the below location \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m download the application code \e[0m"
curl -L -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip

echo -e "\e[36m restarting nginx \e[0m"
systemctl restart nginx




