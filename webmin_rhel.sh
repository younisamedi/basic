# Copyright (c) 2019 - Younis Amedi www.younisamedi.com 
# This script is licensed under GNU GPL version 2.0 or above
#=========================================================================================
#title           : webmin_rhel.sh
#description     : Configure virtualmin / webmin on CentOS / RHEL
#date            : MAY 2019
#version         : 1.0    
#usage           : Instructions to build a webmin server on RHEL based systems
#=========================================================================================

### Copy and paste the commands:
######

cat <<EOF > /etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
yum -y install MariaDB-client.x86_64  MariaDB-server.x86_64
service mariadb start
/usr/bin/mysql_secure_installation

yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php56
yum-config-manager --enable remi-php73

# default webmin installation will install php 7.3 as per our enabled remi repo
# if you need php 5.6 install it with below command
yum install php56.x86_64 php56-php.x86_64 php56-php-bcmath.x86_64 php56-php-cli.x86_64 php56-php-common.x86_64 php56-php-fpm.x86_64 php56-php-gd.x86_64 php56-php-imap.x86_64 php56-php-intl.x86_64 php56-php-mbstring.x86_64 php56-php-mcrypt.x86_64 php56-php-mysqlnd.x86_64 php56-php-opcache.x86_64 php56-php-pdo.x86_64 php56-php-tidy.x86_64 php56-php-xml.x86_64 php56-php-xmlrpc.x86_64  -y

wget http://software.virtualmin.com/gpl/scripts/install.sh
# we will install virtualmin with LAMP stack
sh install.sh

# during installation you will be asked to provide valid fqdn hostname in this form servername.domain.com

# after installation go your IP url https://xx.xx.xx.xx:10000 use root password to login and follow on on-screen post installation instructions
# when on MySQL installation screen you will need to enter root password set in mysql installation above

yum install git -y
yum update -y

# Now go to Dashboard from virtualmin panel and upgrade authentic theme
# reboot system to have everything working
reboot

#########
# Configurations that need to be done in the web GUI:
#
# Default plan needed customization
# As root go to System Settings -> Account Plans -> Edit Default Plan and choose below options
# => Allowed virtual server features
# ==> BIND DNS domain
# ==> Apache website
# ==> SSL website
# ==> MySQL database
# ==> ProFTPD virtual FTP
# ==> Virus filtering
# ==> DAV Login
# ==> Home directory
# ==> Mail for domain
# ==> Spam filtering
# ==> AWstats reporting
# => Allowed capabilities
# ==> Can edit virtual server
# ==> Can manage aliases
# ==> Can install scripts
# ==> Can edit forwarding and proxies
# ==> Can select PHP versions
# ==> Can manage users
# ==> Can manage databases
# ==> Can manage SSL certificates
# ==> Can edit website redirects
# ==> Can configure spam and virus delivery
# ==> Can edit website options
# ==> Can change domain's password
# ==> Can edit DNS records

# then click on Save & Apply

# to create new site click on  Create  Virtual Server. type domain name and admin password, make sure to check the Setup SSL website too? option Under Enabled Features accordion.

# We then have to change PHP SAPI to php-fpm . we can do that from Server Configuration => Website Options => PHP script execution mode change to FPM .
 
# To install wordpress login to domain account and go to Install Scripts, Choose Wordpress and click Show Install Options choose sub-directory or top-level domain and click on Install.
# once done it will give link to complete wordpress 

# To force SSL and www prefix redirection for a specific website. Login as root choose that website left side menu drop down and click on Server Configurations => Website Redirects
# Add new redirect with following parameters 
# Source URL path => /
# Destination => URL at other website => https://www.our-domain.com/$1
# HTTP redirect type => Default
# Include sub-paths in redirect? => Yes
# Enable redirect for => Non-SSL website

### End
