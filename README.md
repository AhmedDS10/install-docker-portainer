لتثبيت **Docker** و **Portainer** على نظام **Raspberry Pi OS** (مثل Raspberry Pi OS Lite أو Desktop)، اتبع الخطوات التالية بدقة، ويفضل تنفيذ الأوامر كمستخدم `pi` مع صلاحيات `sudo`.

---

## ✅ الخطوة 1: تحديث النظام

```bash
sudo apt update && sudo apt list --upgradable && sudo apt upgrade -y
```

---

## ✅ الخطوة 2: تثبيت Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

🔹 بعد التثبيت، أضف المستخدم `pi` إلى مجموعة `docker` لتجنب استخدام `sudo` مع كل أمر:

```bash
sudo usermod -aG docker $USER
```

🔁 قم بإعادة تسجيل الدخول أو أعد تشغيل الجهاز لتفعيل الصلاحيات:

```bash
newgrp docker
# أو
reboot
```

---

## ✅ الخطوة 3: التحقق من تثبيت Docker

```bash
docker --version
docker run hello-world
```

---

## ✅ الخطوة 4: تثبيت Docker Compose (اختياري ولكن مفيد)

```bash
sudo apt install -y python3-pip
sudo pip3 install docker-compose
```

---

## ✅ الخطوة 5: تثبيت Portainer (واجهة إدارة Docker)

Portainer سيعمل كحاوية Docker.

```bash
docker volume create portainer_data

docker run -d -p 9000:9000 -p 8000:8000 \
  --name=portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:linux-arm
```

✅ إذا كان جهازك على معمارية ARMv7 أو ARM64 (معظم أجهزة Raspberry Pi الحديثة تدعم ذلك).

---

## ✅ الخطوة 6: الوصول إلى واجهة Portainer

افتح متصفحك وادخل إلى:

```
http://<RASPBERRY_PI_IP>:9000
```

مثلاً:

```
http://192.168.1.100:9000
```

🧑‍💼 عند الدخول لأول مرة:

* ستُطلب منك إعداد حساب Admin.
* ثم تختار `Local` كمصدر Docker وتبدأ في إدارة الحاويات.

---

## ✅ (اختياري) تمكين Docker عند الإقلاع

```bash
sudo systemctl enable docker
```

---

إليك سكربت Bash تلقائي يقوم بتثبيت Docker و Portainer على نظام **Raspberry Pi OS** (يدعم ARM/ARM64):

---

### ✅ اسم الملف: `install_docker_portainer.sh`

```bash
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
```

---

### 📦 خطوات الاستخدام:

1. احفظ السكربت في ملف:

   ```bash
   nano install_docker_portainer.sh
   ```

2. الصق المحتوى، ثم احفظ بالخروج من Nano (Ctrl + X ثم Y ثم Enter).

3. اجعل السكربت قابلاً للتنفيذ:

   ```bash
   chmod +x install_docker_portainer.sh
   ```

4. شغّل السكربت:

   ```bash
   ./install_docker_portainer.sh
   ```

---

### 📌 ملاحظات مهمة:

* بعد انتهاء السكربت، **أعد تشغيل الجهاز** أو نفذ:

  ```bash
  newgrp docker
  ```
* ثم افتح المتصفح وادخل إلى:

  ```
  http://<IP-الراسبيري>:9000
  ```

---
