#!/bin/bash

# Обновляем информацию о пакетах
sudo apt update

# Устанавливаем необходимые пакеты
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Добавляем ключ GPG для Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Добавляем репозиторий Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Обновляем информацию о пакетах с учетом нового репозитория
sudo apt update

# Устанавливаем Docker
sudo apt install -y docker-ce

# Проверяем статус Docker
sudo systemctl status docker --no-pager

# Если Docker активен, продолжаем установку Docker Compose
if systemctl is-active --quiet docker; then
    echo "Docker is active, proceeding with Docker Compose installation..."

    # Устанавливаем Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/2.28.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    # Делаем Docker Compose исполняемым
    sudo chmod +x /usr/local/bin/docker-compose

    # Проверяем версию Docker Compose
    docker compose --version

    # Выводим сообщение об успешной настройке Docker
    echo "Docker настроен успешно"
else
    echo "Docker не активен, проверьте установку Docker."
fi
