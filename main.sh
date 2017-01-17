#!/usr/bin/env bash
#Generates a string of Upper case and lower case and number.The default length is 10 bits, the first argument is the string length.
generate_random_password () {
    dict=(a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9)
    length=10
    if [ $# -gt 0 ]
    then
        length=$1
    fi
    for ((i=0;(i<length);i++));do
        result+=${dict[$RANDOM % ${#dict[@]}]}
    done
    echo $result
}
#Generate a five-digit number less than 65535, and does not conflict with the current port number.
generate_random_port () {
    dict=(1 2 3 4 5 6 7 8 9)
    length=5
    for ((i=0;(i<length);i++));do
        result+=${dict[$RANDOM % ${#dict[@]}]}
    done
    if [ $((result)) -lt 65535 ]
        then
            if [ $(netstat -ntlp |awk '{print $4}' |grep $result) ]
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
#Test case
#is_port_occupied () {
#result=3306
#if [ $(netstat -ntlp |awk '{print $4}' |grep $result) ]
#    then
#        echo wrong
#    else
#        echo right
#fi
#}

for ((c=0;(c<20);c++));do
#       ret=$(generate_random_port)
        ret=$(generate_random_password 30)
        echo $ret
done

#install basic software(vim,unzip,zip,dos2unix)
#install mysql
#install jdk
#install tomcat
#install nginx

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