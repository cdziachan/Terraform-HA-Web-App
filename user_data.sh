#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
current_az=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="white">
<font color="black">Availability Zone: <font color="red">$current_az</font><br><p>
<font color="black">Server Private IP: <font color="red">$myip<br><br>
<font color="black">
<b>Version 1.0</b>
</body>
</html>
EOF

service httpd start
chkconfig httpd on