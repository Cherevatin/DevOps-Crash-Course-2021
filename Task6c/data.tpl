#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install nginx
cd /var/www
chgrp ec2-user html
chown ec2-user html
cd html
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<body>
<h1>Hello world from Crash course DevOps!</h1>
</body>
</html>
EOF
sudo systemctl start nginx

