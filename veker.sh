#!/bin/bash
SUBDOMAIN="f2afbpanel.pterodactylxcz.my.id"
WEB_ROOT="/var/www/$SUBDOMAIN"

echo "🔍 1. Cek Nginx..."
nginx -t
systemctl restart nginx

echo "🔍 2. Cek Firewall (UFW)..."
if command -v ufw >/dev/null 2>&1; then
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw reload
    echo "✅ Port 80 & 443 dibuka."
else
    echo "⚠️ UFW tidak terinstall (skip)."
fi

echo "🔍 3. Cek Folder & File..."
if [ ! -f "$WEB_ROOT/index.php" ]; then
    echo "❌ File index.php tidak ada! Membuat file sementara..."
    echo "<?php echo 'Web berjalan!'; ?>" > "$WEB_ROOT/index.php"
    chown -R www-data:www-data "$WEB_ROOT"
fi

echo "🔍 4. Cek IP VPS vs IP Domain..."
IP_VPS=$(curl -4 -s ifconfig.me)
IP_DOMAIN=$(dig +short A "$SUBDOMAIN" @8.8.8.8 | tail -1)

echo "IP VPS    : $IP_VPS"
echo "IP Domain : $IP_DOMAIN"

if [ "$IP_VPS" != "$IP_DOMAIN" ]; then
    echo "⚠️ PERINGATAN: IP Domain belum mengarah ke VPS kamu!"
    echo "👉 Solusi: Buka Cloudflare/DNS panel, arahkan A Record $SUBDOMAIN ke $IP_VPS"
else
    echo "✅ Domain sudah mengarah ke VPS."
fi

echo "🎉 Selesai. Silakan coba buka domainnya lagi."
