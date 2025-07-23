#!/bin/bash

# سكربت لتثبيت Docker و Portainer على Raspberry Pi OS
# أعد كتابته: أحمد داود

echo "🔧 تحديث النظام..."
sudo apt update && sudo apt list --upgradable && sudo apt upgrade -y

echo "🐳 تثبيت Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "👤 إضافة المستخدم الحالي إلى مجموعة docker..."
sudo usermod -aG docker $USER

echo "🐍 تثبيت Docker Compose (اختياري)..."
sudo apt install -y python3-pip
sudo pip3 install docker-compose

echo "🔁 إعادة تشغيل Docker وتفعيله مع الإقلاع..."
sudo systemctl enable docker
sudo systemctl restart docker

echo "💾 إنشاء مجلد بيانات Portainer..."
docker volume create portainer_data

echo "🚀 تشغيل حاوية Portainer..."
docker run -d -p 9000:9000 -p 8000:8000 \
  --name=portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:linux-arm

echo "✅ تم التثبيت بنجاح!"
echo "🌐 افتح المتصفح وادخل إلى: http://$(hostname -I | awk '{print $1}'):9000"
echo "🔁 يُفضل إعادة تشغيل الجهاز الآن أو تنفيذ: newgrp docker"
