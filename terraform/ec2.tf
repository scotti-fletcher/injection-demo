resource "aws_instance" "lab_webserver" {
  ami                    = "ami-020cba7c55df1f615" # Ubuntu 24.04 LTS
  instance_type          = "t2.medium"
  key_name               = "lab_key"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  subnet_id              = local.public_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.flappy_lab_profile.name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = <<-EOF
#!/bin/bash

# Install MongoDB
sudo apt-get update -y
sudo apt-get install -y wget curl gnupg2 software-properties-common git build-essential ruby-dev nginx jq
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-keyring.gpg
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-keyring.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Stop MongoDB if running and configure
sudo systemctl stop mongod || true
sudo tee /etc/mongod.conf <<'MONGOCONFIG'
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

storage:
  dbPath: /var/lib/mongodb
  engine: wiredTiger

net:
  port: 27017
  bindIp: 127.0.0.1

processManagement:
  timeZoneInfo: /usr/share/zoneinfo
MONGOCONFIG

# Set permissions
sudo chown mongodb:mongodb /etc/mongod.conf
sudo chown -R mongodb:mongodb /var/lib/mongodb
sudo chown -R mongodb:mongodb /var/log/mongodb

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Wait for startup
sleep 5

# Install Passenger
sudo apt-get install -y dirmngr gnupg apt-transport-https ca-certificates
curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/phusion.gpg >/dev/null
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger noble main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
sudo apt-get install -y libnginx-mod-http-passenger

# Setup application
sudo mkdir -p /var/www/flappy
sudo chown ubuntu: /var/www/flappy

cd /var/www/flappy
git clone https://github.com/scotti-fletcher/injection-demo
cd /var/www/flappy/injection-demo/web
sudo gem install bundler
sudo bundle config set --local deployment 'true'
sudo bundle config set --local without 'development test'
sudo bundle install

# Configure Nginx
server_ip=$(curl -s https://wtfismyip.com/text)
sudo tee /etc/nginx/sites-enabled/flappy.conf <<NGINXCONFIG
server {
    listen 80;
    server_name $server_ip;

    root /var/www/flappy/injection-demo/web/public;

    passenger_enabled on;
    passenger_ruby /usr/bin/ruby;
    passenger_env_var MONGODB_CONN mongodb://localhost:27017;
}
NGINXCONFIG

sudo service nginx restart
EOF

  tags = {
    Name = "Lab-WebServer"
  }
}


resource "aws_instance" "lab_attacker" {
  ami                    = "ami-020cba7c55df1f615" # Ubuntu 24.04 LTS
  instance_type          = "t2.small"
  key_name               = "lab_key"
  vpc_security_group_ids = [aws_security_group.attacker_sg.id]
  subnet_id              = local.public_subnet_ids[0]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }


  tags = {
    Name = "Lab-Attacker"
  }
}

# Output the public IP for easy access
output "webserver_public_ip" {
  value = aws_instance.lab_webserver.public_ip
}


# Output the public IP for easy access
output "attacker_public_ip" {
  value = aws_instance.lab_attacker.public_ip
}
