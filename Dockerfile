FROM centos:6.7
MAINTAINER Philip Mischenko

RUN yum update -y
RUN yum install httpd mysql-server php php-mysql mysql -y


ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
EXPOSE 80

