# setup redis repo
echo -e "\e[36m setup the redis rep \e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

# Enable Redis 6.2 from package streams.
echo -e "\e[36m Enable Redis 6.2 from package streams \e[0m"
dnf module enable redis:remi-6.2 -y

# install redis
echo -e "\e[36m install redis \e[0m"
yum install redis -y

#need to replace the redis Listen Address
echo -e "\e[36m replace the redis Listen Address \e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf /etc/redis.conf

echo -e "\e[36m restart the redis rep \e[0m"
systemctl enable redis
systemctl restart redis