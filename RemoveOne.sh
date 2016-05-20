dckr_srv=10.1.1.101
last_port=$(cat /etc/httpd/conf/httpd.conf | grep BalancerMember | awk 'BEGIN { FS=":" } /1/ { print $3 }' | grep -o [0-9]* | tail -1)
echo last used container port: $last_port
sed -i "/${dckr_srv}:${last_port}/d" /etc/httpd/conf/httpd.conf
ssh root@${dckr_srv} "docker stop app${last_port} && docker rm app${last_port}"
echo container app${next_port} stoped and deleted
echo apache will be restarted now...
systemctl restart httpd
