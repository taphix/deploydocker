#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION_ID=$VERSION_ID
else
    echo "Невозможно определить операционную систему"
    exit 1
fi

echo "Определена операционная система: $OS $VERSION_ID"

install_docker_debian() {
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce
}

install_docker_centos() {
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
}

case $OS in
    ubuntu|debian)
        install_docker_debian
        ;;
    centos|rhel)
        install_docker_centos
        ;;
    *)
        echo "Этот скрипт не поддерживает установку Docker на $OS."
        exit 1
        ;;
esac

sudo systemctl status docker --no-pager

if systemctl is-active --quiet docker; then
    echo "Docker is active, proceeding with Docker Compose installation..."

    sudo curl -L "https://github.com/docker/compose/releases/download/2.28.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose

    docker compose version

    echo "Docker настроен успешно"
else
    echo "Docker не активен, проверьте установку Docker."
fi
