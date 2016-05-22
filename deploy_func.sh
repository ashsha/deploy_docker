#!/bin/bash

dckr_srv=10.1.1.101

function add_new {
    
    echo How many containers you want to add?
    read how_many
    echo Ok, let\'s deploy $how_many container\(s\):
        for ((i=$how_many; i>0; i--))
            do
                last_port=$(cat /etc/httpd/conf/httpd.conf | grep BalancerMember | awk 'BEGIN { FS=":" } /1/ { print $3 }' | grep -o [0-9]* | tail -1)
                echo Last used port for container in httpd.conf is: $last_port;
                next_port=$((last_port+1));
                echo $next_port will be use for next balancer member...
                sed -i  "/${dckr_srv}:${last_port}/ a BalancerMember \"http://${dckr_srv}:${next_port}\"" /etc/httpd/conf/httpd.conf
                ssh root@${dckr_srv} "docker run --name app${next_port}_balancer -p ${next_port}:80 --restart=always -v /var/project/:/var/www/html -d app" \\n
            done
    
    echo One moment, apache will be restarted now...\\n
    echo -e "\e[0;32mEnjoy! Your $how_many container(s) is up!\e[0m" \\n
    systemctl restart httpd
    }
 
function del_old {
    echo How many containers you want to remove?
    read how_many
    echo Ok, let\'s remove $how_many container\(s\):\\n
        for ((i=$how_many; i>0; i--))
            do
                last_port=$(cat /etc/httpd/conf/httpd.conf | grep BalancerMember | awk 'BEGIN { FS=":" } /1/ { print $3 }' | grep -o [0-9]* | tail -1)
                echo Last used port for container in httpd.conf is: $last_port;
                echo Container on port $last_port will be remove.
                sed -i "/${dckr_srv}:${last_port}/d" /etc/httpd/conf/httpd.conf 
                ssh root@${dckr_srv} "docker stop app${last_port}_balancer && docker rm app${last_port}_balancer >/dev/null 2>&1" \\n
            done
    echo Apache will be restarted now...
    systemctl restart httpd
    echo -e "\e[0;32mEnjoy! Your $how_many container(s) was stopped and removed!\e[0m" \\n

}

answer () {
        while read response; do
            case $response in
            [aA][dD][dD])
            add_new
            $2
        break
        ;;
            [dD][eE][lL])
            del_old
            $4
        break
        ;;
        *)
        printf "Please, enter Add or Del! "\\n
        esac
        done
}

echo -e "Add or Del? (Add/Del) "\\n
answer "Add" "" "Del" ""


