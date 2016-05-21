dckr_srv=10.1.1.101
last_port=$(cat /etc/httpd/conf/httpd.conf | grep BalancerMember | awk 'BEGIN { FS=":" } /1/ { print $3 }' | grep -o [0-9]* | tail -1)
echo Hola!
echo Last used container port: $last_port
echo ''

sed -i "/${dckr_srv}:${last_port}/d" /etc/httpd/conf/httpd.conf

ssh root@${dckr_srv} "docker stop app${last_port}_balancer && docker rm app${last_port}_balancer"

echo Docker container app${next_port}_balancer was stoped and deleted.
echo Apache will be restarted now...
systemctl restart httpd
echo All done.