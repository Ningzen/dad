#!/bin/bash

set -e

# Install docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# Install netplan
sudo yum install -y epel-release
sudo yum install -y netplan

# Configure firewall using netplan
sudo bash -c 'cat <<EOF > /etc/netplan/99-firewall.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      match:
        name: eth0
      set-name: eth0
      dhcp6: false
      addresses:
        - 192.168.0.2/24
      gateway4: 192.168.0.1
      nameservers:
          addresses: [8.8.8.8, 8.8.4.4]
      routes:
        - to: 0.0.0.0/0
          via: 192.168.0.1
          metric: 100
      firewalld:
        firewall-config:
          rule:
            - family: ipv4
              source: 0.0.0.0/0
              port:
                - protocol: tcp
                  port: "80"
                - protocol: tcp
                  port: "2222"
                - protocol: tcp
                  port: "443"
EOF'

sudo netplan apply

# Start GitLab container
sudo docker run --detach \
--hostname gitlab.example.com \
--publish 443:443 --publish 80:80 --publish 2222:22 \
--name gitlab \
--restart always \
--volume /srv/gitlab/config:/etc/gitlab \
--volume /srv/gitlab/logs:/var/log/gitlab \
--volume /srv/gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce:latest


# Access Gitlab
echo "Gitlab is now running at http://192.168.0.2"

------------
Access Gitlab: Once the container is up and running, access Gitlab by opening your web browser and entering the following URL: http://<hostname_or_ip>. You will be redirected to the Gitlab setup page where you can create your admin account and set up your first project.

The set -e command at the beginning of the script causes the script to exit immediately if any command fails. This way, if any of the commands fail during the installation process, the script will stop executing and the user will be alerted to the error.

sudo docker ps -a --filter "name=gitlab"

sudo docker stop 
sudo docker rm <container_id>

sudo netstat -tulpn | grep <ip_address>
sudo kill <pid>


sudo systemctl status sshd

sudo docker run --detach \
--privileged \
--hostname 192.168.0.2 \
--publish 8080:80 --publish 2222:22 \
--name gitlab \
--restart always \
--volume /srv/gitlab/config:/etc/gitlab \
--volume /srv/gitlab/logs:/var/log/gitlab \
--volume /srv/gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce:latest

sudo nano /etc/firewalld/services/gitlab.xml

<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>GitLab</short>
  <description>GitLab service</description>
  <port protocol="tcp" port="80"/>
  <port protocol="tcp" port="2222"/>
  <port protocol="tcp" port="443"/>
</service>

sudo firewall-cmd --reload


--------
#!/bin/bash

# Install docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# Configure firewall
sudo firewall-cmd --zone=public --add-port=80/tcp --add-port=443/tcp --add-port=2222/tcp --permanent
sudo firewall-cmd --reload

# Start GitLab container
sudo docker run --detach \
--hostname gitlab.example.com \
--publish 443:443 --publish 80:80 --publish 2222:22 \
--name gitlab \
--restart always \
--volume /srv/gitlab/config:/etc/gitlab \
--volume /srv/gitlab/logs:/var/log/gitlab \
--volume /srv/gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce:latest

https://forum.gitlab.com/t/cannot-access-local-gitlab-server-gui-using-browser/36452/6

/etc/hosts

https://medium.com/devops-with-valentine/setup-gitlab-ci-runner-with-docker-executor-on-windows-10-11-c58dafba9191
