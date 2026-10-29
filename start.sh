#!/bin/bash
set -e

echo "🚀 Starting X-UI + nginx reverse proxy..."
export NGINX_PORT=3000
cd /usr/local/x-ui

# اجرای اولیه برای ساخت دیتابیس
./x-ui &
X_UI_PID=$!
sleep 3

# اعمال تنظیمات (بدون || true تا خطاها دیده شوند)
echo "🔧 Applying panel settings..."
./x-ui setting -port 2053 -webBasePath /managepanel/

# ری‌استارت برای اعمال تنظیمات
kill $X_UI_PID || true
sleep 1

echo "🔧 Building nginx.conf for fixed port: $NGINX_PORT"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️  Starting x-ui in background..."
./x-ui &
sleep 2

echo "▶️  Starting nginx in foreground on port $NGINX_PORT..."
nginx -t
exec nginx -g "daemon off;"
