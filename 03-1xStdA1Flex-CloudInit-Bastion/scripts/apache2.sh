#!/bin/bash
sudo apt update
sudo apt-get update
sudo apt install -y apache2
sudo iptables -F
sudo echo "<h1> Welcome to my terraform InfraTI IP: $(ip route get 1.2.3.4 | awk '{print $7}') </h1>" | sudo tee "/var/www/html/index.html"
