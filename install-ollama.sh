#!/bin/bash

# install ollama
curl -fsSL https://ollama.com/install.sh | sh

# enable ollama
sudo systemctl enable ollama

# install nginx
sudo amazon-linux-extras install nginx1 -y

# write nginx config
sudo tee /etc/nginx/conf.d/ollama.conf<<EOF
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:11434;
         proxy_set_header Host localhost:11434;
    }
}
EOF

# enable nginx
sudo systemctl enable nginx
