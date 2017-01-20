#!/usr/bin/env bash
#Generates a string of Upper case and lower case and number.The default length is 10 bits, the first argument is the string length.
#para: length;
#reqire: none;
#return_echo: new_password;
generate_random_password () {
    dict=(a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9)
    length=10
    if [ $# -gt 0 ]; then
        length=$1
    fi
    for ((i=0;(i<length);i++));do
        result+=${dict[$RANDOM % ${#dict[@]}]}
    done
    echo $result
}

#Generate a five-digit number less than 65535, and does not conflict with the current port number.
#para: none;
#reqire: none;
#return_echo: new_port;
generate_random_port () {
    dict=(1 2 3 4 5 6 7 8 9)
    length=5
    for ((i=0;(i<length);i++));do
        result+=${dict[$RANDOM % ${#dict[@]}]}
    done
    if [ $((result)) -lt 65535 ]; then
            if [ $(netstat -ntlp |awk '{print $4}' |grep $result) ];
            then
                result=''
                i=0
                generate_random_port
            else
                echo $result
            fi
        else
            result=''
            i=0
            generate_random_port
    fi
}

#change yum source and update. (http://mirrors.aliyun.com/help/centos)
#para: "extreme"(use upgrade) or ""(use update)
#reqire: none;
#return_echo: none
change_yum_repo () {
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    yum makecache
    if [ $# -gt 0 ] && [ $1 == "extreme" ]; then
        yum -y upgrade #unsafe (http://unix.stackexchange.com/questions/55777/in-centos-what-is-the-difference-between-yum-update-and-yum-upgrade)
    else
        yum -y update #safer
    fi
}
#check package is installed.
#para: "package name";
#reqire: none;
#return_echo: result;
is_installed () {
    package_name=$1
    if [ $(yum list installed |grep ${package_name} |tail -n 1 |awk '{print $1}') ]; then
        echo -e "[\033[32m sucess \e[0m] yum install: $package_name";
    else
        echo -e "[\033[31m failed \e[0m] yum install: $package_name";
    fi
}
#yum install package and show result.
#para: "package name";
#reqire: "is_installed";
#return_echo: result;
yum_install () {
    if [ $# -gt 0 ]; then
        package_name=$1
        yum install -y $package_name
        echo $package_name
        is_installed $package_name
    else
        echo -e "[\033[31m failed \e[0m] yum install: no para";
    fi
}

#install basic package
#para: "package name";
#reqire: "yum_install" "is_installed";
#return_echo: result;
install_basic_package () {
    if [ $# -gt 0 ]; then
        packages_file=$1
        while read line
        do
            yum_install $line
        done < $packages_file
    else
        echo -e "[\033[31m failed \e[0m] install_basic_package: no para";
    fi
}

#yum install mysql online
#para: mysql version 5.x (5 | 6 | 7)
#reqire: "yum_install" "is_installed";
#return_echo: result;
yum_install_mysql() {
    wget http://repo.mysql.com//mysql57-community-release-el6-8.noarch.rpm
    rpm -ivh mysql57-community-release-el6-8.noarch.rpm
    yum repolist all | grep mysql
    sed -i '/enabled=/c enabled=0' /etc/yum.repos.d/mysql-community.repo
    line=`grep mysql5$1 -n /etc/yum.repos.d/mysql-community.repo  -A 5 | grep enable | awk -F "-" '{print $1}'`
    total="${line}""s/enabled=0/enabled=1/"
    sed -i $total /etc/yum.repos.d/mysql-community.repo
    yum repolist enabled | grep mysql
    yum_install mysql-community-server
    service mysqld start
}

#yum install mysql offline(https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.17-1.el7.x86_64.rpm-bundle.tar)
#para: mysql version 5.7
#reqire: "is_installed";
#return_echo: none;
yum_local_install_mysql() {
    yum localinstall mysql-community-server-5.7.17-1.el7.x86_64.rpm mysql-community-client-5.7.17-1.el7.x86_64.rpm  mysql-community-common-5.7.17-1.el7.x86_64.rpm mysql-community-libs-5.7.17-1.el7.x86_64.rpm
    is_installed mysql
}

#install jdk
#wget http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz?AuthParam=1484749376_c16508346c3e699faecf69a72046a771
#tar -zxvf jdk-8u121-linux-x64.tar.gz
#mv jdk-8u121-linux-x64 /usr/local/jdk-8u121-linux-x64

#configure environment jdk
#echo "export JAVA_HOME=/usr/local/Java/jdk1.8.0_112" >> /etc/profile
#echo "export PATH=""$""JAVA_HOME/bin:""$""PATH" >> /etc/profile
#echo "export CLASSPATH=.:""$""JAVA_HOME/lib/dt.jar:""$""JAVA_HOME/lib/tools.jar" >> /etc/profile

#install tomcat
#wget http://219.239.26.10/files/21470000098C4D62/mirrors.cnnic.cn/apache/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz
#tar -zxvf apache-tomcat-8.5.9.tar.gz
#mv apache-tomcat-8.5.9 /usr/local/apache-tomcat-8.5.9

#add tomcat to service

#install nginx
#yum -y install nginx

#generate new ssh-key

#add new account for remote sshlogin

#add new account for mysql login

#denied root remote ssh login

#denied password ssh login

#change ssh port

#change mysql port

#firewalld allow nginx port

#firewalld allow new ssh port

#send email