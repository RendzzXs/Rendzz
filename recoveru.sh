#!/bin/bash
# FIX ERROR SYNTAX PADA FILE PHP

WEB_ROOT="/var/www/f2afbpanel.pterodactylxcz.my.id"

# 1. Bikin ulang login.php
cat > "$WEB_ROOT/login.php" << 'PHPEOF'
<?php
require_once __DIR__ . '/includes/config.php';
if (isLoggedIn()) { header('Location: /'); exit; }
$err = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!checkCsrf($_POST['csrf'] ?? '')) $err = 'CSRF Error';
    else {
        $s = $pdo->prepare("SELECT * FROM users WHERE username=?"); $s->execute([trim($_POST['username'])]);
       ('Location $u = $: /s->fetch();
       '); if ($u && password_verify exit($_POST['password'], $u['password'])) {
            $_SESSION['user_id'] = $u['id']; $_SESSION['username'] = $u['username'];
            header;
        } else $err = 'Login gagal!';
    }
}
$pageTitle = 'Login';
include __DIR__ . '/includes/header.php';
?>
<div class="container" style="max-width:400px; margin-top:60px">
    <div class="card">
        <div style="text-align:center; margin-bottom:20px">
            <div class="card-icon" style="background:linear-gradient(135deg,var(--primary),#6d28d9); margin:0 auto 15px; width:60px; height:60px; font-size:1.5em"><i class="fas fa-lock"></i></div>
            <h2 style="font-size:1.4em">Login</h2>
            <p style="color:var(--muted); font-size:0.9em">Masuk untuk akses Authenticator</p>
        </div>
        <?php if ($err): ?><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <?= $err ?></div><?php endif; ?>
        <form method="POST">
            <input type="hidden" name="csrf" value="<?= csrf() ?>">
            <div class="form-group"><label><i class="fas fa-user"></i> Username</label><input type="text" name="username" required autofocus></div>
            <div class="form-group"><label><i class="fas fa-key"></i> Password</label><input type="password" name="password" required></div>
            <button class="btn btn-primary btn-block"><i class="fas fa-sign-in-alt"></i> Masuk</button>
        </form>
        <p style="text-align:center; margin-top:15px; font-size:0.9em; color:var(--muted)">Belum punya akun? <a href="/register.php" style="color:var(--primary)">Daftar</a></p>
    </div>
</div>
<?php include __DIR__ . '/includes/footer.php'; ?>
PHPEOF

# 2. Bikin ulang register.php
cat > "$WEB_ROOT/register.php" << 'PHPEOF'
<?php
require_once __DIR__ . '/includes/config.php';
if (isLoggedIn()) { header('Location: /'); exit; }
$err = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!checkCsrf($_POST['csrf'] ?? '')) $err = 'CSRF Error';
    else {
        $u = trim($_POST['username']); $p = $_POST['password'];
        if (strlen($u) < 3) $err = 'Username min 3';
        elseif (strlen($p) < 6) $err = 'Password min 6';
        else {
            $s = $pdo->prepare("SELECT id FROM users WHERE username=?"); $s->execute([$u]);
            if ($s->fetch()) $err = 'Username sudah dipakai';
            else {
                $pdo->prepare("INSERT INTO users (username, password) VALUES (?,?)")->execute([$u, password_hash($p, PASSWORD_BCRYPT)]);
                header('Location: /login.php'); exit;
            }
        }
    }
}
$pageTitle = 'Daftar';
include __DIR__ . '/includes/header.php';
?>
<div class="container" style="max-width:400px; margin-top:60px">
    <div class="card">
        <div style="text-align:center; margin-bottom:20px">
            <div class="card-icon" style="background:linear-gradient(135deg,var(--primary),#6d28d9); margin:0 auto 15px; width:60px; height:60px; font-size:1.5em"><i class="fas fa-user-plus"></i></div>
            <h2 style="font-size:1.4em">Daftar Akun</h2>
        </div>
        <?php if ($err): ?><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <?= $err ?></div><?php endif; ?>
        <form method="POST">
            <input type="hidden" name="csrf" value="<?= csrf() ?>">
            <div class="form-group"><label><i class="fas fa-user"></i> Username</label><input type="text" name="username" required></div>
            <div class="form-group"><label><i class="fas fa-key"></i> Password</label><input type="password" name="password" required></div>
            <button class="btn btn-primary btn-block"><i class="fas fa-user-plus"></i> Daftar</button>
        </form>
        <p style="text-align:center; margin-top:15px; font-size:0.9em; color:var(--muted)">Sudah punya akun? <a href="/login.php" style="color:var(--primary)">Login</a></p>
    </div>
</div>
<?php include __DIR__ . '/includes/footer.php'; ?>
PHPEOF

# 3. Fix Nginx & Restart
cat > /etc/nginx/sites-available/f2afbpanel.pterodactylxcz.my.id << 'NGINXEOF'
server {
    listen 80;
    listen [::]:80;
    server_name f2afbpanel.pterodactylxcz.my.id;
    root /var/www/f2afbpanel.pterodactylxcz.my.id;
    index index.php index.html;
    location / { try_files $uri $uri/ =404; }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
    }
}
NGINXEOF

ln -sf /etc/nginx/sites-available/f2afbpanel.pterodactylxcz.my.id /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

chown -R www-data:www-data "$WEB_ROOT"
systemctl restart php8.3-fpm nginx

echo ""
echo "✅ FIX BERHASIL!"
echo "Buka: http://f2afbpanel.pterodactylxcz.my.id/login.php"
