dckr_srv=10.1.1.101
last_port=$(cat /etc/httpd/conf/httpd.conf | grep BalancerMember | awk 'BEGIN { FS=":" } /1/ { print $3 }' | grep -o [0-9]* | tail -1)
echo last used container port: $last_port
next_port=$((last_port+1))
echo $next_port will be use next
sed -i  "/${dckr_srv}:${last_port}/ a BalancerMember \"http://${dckr_srv}:${next_port}\"" /etc/httpd/conf/httpd.conf
ssh root@${dckr_srv} "docker run --name app${next_port} -p ${next_port}:80 -v /var/project/:/var/www/html -d app"
echo enjoy! your new container is up 
echo your brand new container started with name "app${next_port}" and it running on ${dckr_srv}:${next_port}
echo apache will be restarted now...
systemctl restart httpd
