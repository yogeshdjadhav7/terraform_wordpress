#!/bin/bash

# Update the system and install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Docker login with credentials
sudo docker login --username "dockerhub username" --password-stdin <<< "dockerhub password"

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Enable Docker to start on boot
sudo chkconfig docker on

# Extract RDS credentials to files
echo "${aws_db_instance.rds_master.password}" | sudo tee /root/db_password.txt > /dev/null
echo "${aws_db_instance.rds_master.username}" | sudo tee /root/db_username.txt > /dev/null
echo "${aws_db_instance.rds_master.endpoint}" | sudo tee /root/db_endpoint.txt > /dev/null

# Create Docker Compose file
sudo tee /home/ec2-user/docker-compose.yml > /dev/null <<EOF
version: '3'
services:
  wordpress:
    image: wordpress:4.8-apache
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_USER: "$(cat /root/db_username.txt)"
      WORDPRESS_DB_HOST: "$(cat /root/db_endpoint.txt)"
      WORDPRESS_DB_PASSWORD: "$(cat /root/db_password.txt)"
    volumes:
      - wordpress-data:/var/www/html

volumes:
  wordpress-data:
EOF

# Change ownership of the Docker Compose file
sudo chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml

# Change directory to where docker-compose.yml is located
cd /home/ec2-user

# Start Docker Compose
sudo docker-compose up -d

