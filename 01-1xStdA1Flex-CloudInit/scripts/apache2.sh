#!/bin/bash
sudo apt update
sudo apt-get update
sudo apt install -y apache2
sudo iptables -F
sudo echo "<h1> Welcome to my terraform InfraTI IP: $(curl -s ifconfig.me) </h1>" | sudo tee "/var/www/html/index.html"
