# Use CentOS 7 docker image
FROM centos:latest

# Install nginx
RUN dnf -y install nginx

COPY https://github.com/mashiutz/888HA

# Copy custom nginx.conf file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy index.html file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Run nginx
RUN systemctl start nginx