#!/bin/bash

set -e

# Install Docker engine
sudo yum update -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# Download Gitlab image from Docker hub
sudo docker pull gitlab/gitlab-ce:latest

# Create a new Docker container for Gitlab
sudo docker run --detach \
--hostname 127.0.0.1 \
--publish 443:443 --publish 8080:80 --publish 22:22 \
--name gitlab \
--restart always \
--volume /srv/gitlab/config:/etc/gitlab \
--volume /srv/gitlab/logs:/var/log/gitlab \
--volume /srv/gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce:latest

# Access Gitlab
echo "Gitlab is now running at http://<hostname_or_ip>."


Access Gitlab: Once the container is up and running, access Gitlab by opening your web browser and entering the following URL: http://<hostname_or_ip>. You will be redirected to the Gitlab setup page where you can create your admin account and set up your first project.

The set -e command at the beginning of the script causes the script to exit immediately if any command fails. This way, if any of the commands fail during the installation process, the script will stop executing and the user will be alerted to the error.
