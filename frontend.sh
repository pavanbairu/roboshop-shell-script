yum install nginx -y
systemctl enable nginx
systemctl start nginx

# created the roboshop config file
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

#removing the existing content available in the below location
rm -rf /usr/share/nginx/html/*
curl -L -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip

systemctl restart nginx




