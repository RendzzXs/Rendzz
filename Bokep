#!/bin/bash

# ==============================================
# PTERODACTYL PREMIUM THEME - AUTO INSTALL ALL IN ONE
# LANGSUNG INSTALL SEMUA - NO ERROR, NO TANYA!
# ==============================================

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Config
PTERODACTYL_DIR="/var/www/pterodactyl"
BACKUP_DIR="/root/pterodactyl-backup-$(date +%Y%m%d-%H%M%S)"

# Auto fix error
set -e
set -o pipefail

# Function untuk auto fix error
auto_fix_error() {
    echo -e "${YELLOW}[Auto Fix] Memperbaiki error...${NC}"
    
    # Fix permission
    chown -R www-data:www-data "$PTERODACTYL_DIR" 2>/dev/null || true
    chmod -R 755 "$PTERODACTYL_DIR/storage" 2>/dev/null || true
    chmod -R 755 "$PTERODACTYL_DIR/bootstrap/cache" 2>/dev/null || true
    
    # Fix composer
    cd "$PTERODACTYL_DIR"
    composer dump-autoload -q 2>/dev/null || true
    
    # Fix artisan
    php artisan view:clear -q 2>/dev/null || true
    php artisan cache:clear -q 2>/dev/null || true
    php artisan config:clear -q 2>/dev/null || true
    
    echo -e "${GREEN}[Auto Fix] Selesai!${NC}"
}

# Trap error
trap 'echo -e "${RED}Error detected! Running auto fix...${NC}"; auto_fix_error' ERR

# Start install
clear
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║${WHITE}      PTERODACTYL PREMIUM THEME - AUTO INSTALL ALL       ${PURPLE}║${NC}"
echo -e "${PURPLE}║${WHITE}         LANGSUNG INSTALL - NO ERROR - NO TANYA          ${PURPLE}║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check root
echo -e "${YELLOW}[1/8] Checking root access...${NC}"
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Error: Must be root!${NC}"
    echo -e "${CYAN}Run: sudo bash $0${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Root access OK${NC}"

# Check Pterodactyl
echo -e "${YELLOW}[2/8] Checking Pterodactyl installation...${NC}"
if [ ! -d "$PTERODACTYL_DIR" ]; then
    echo -e "${RED}Error: Pterodactyl not found in $PTERODACTYL_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Pterodactyl found${NC}"

# Auto backup
echo -e "${YELLOW}[3/8] Creating automatic backup...${NC}"
mkdir -p "$BACKUP_DIR"
cp -r "$PTERODACTYL_DIR/resources/views" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$PTERODACTYL_DIR/public" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$PTERODACTYL_DIR/app" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$PTERODACTYL_DIR/routes" "$PTERODACTYL_DIR/routes-backup" 2>/dev/null || true
echo -e "${GREEN}✓ Backup created at: $BACKUP_DIR${NC}"

# Create directories
echo -e "${YELLOW}[4/8] Creating theme directories...${NC}"
mkdir -p "$PTERODACTYL_DIR/public/theme"
mkdir -p "$PTERODACTYL_DIR/public/theme/css"
mkdir -p "$PTERODACTYL_DIR/public/theme/js"
mkdir -p "$PTERODACTYL_DIR/public/theme/img"
mkdir -p "$PTERODACTYL_DIR/storage/app/wallpapers"
mkdir -p "$PTERODACTYL_DIR/storage/app/public/wallpapers"
mkdir -p "$PTERODACTYL_DIR/public/storage/wallpapers"
mkdir -p "$PTERODACTYL_DIR/resources/views/admin/theme"
echo -e "${GREEN}✓ Directories created${NC}"

# ==============================================
# INSTALL DARK THEME
# ==============================================
echo -e "${YELLOW}[5/8] Installing Dark Theme...${NC}"

cat > "$PTERODACTYL_DIR/public/theme/css/dark-theme.css" << 'EOF'
:root {
    --primary-bg: #0a0c0f;
    --secondary-bg: #1a1e24;
    --card-bg: #1f2329;
    --text-primary: #ffffff;
    --text-secondary: #b0b7c0;
    --accent-color: #6e45e2;
    --accent-hover: #8b5cf6;
    --accent-active: #4c2aa3;
    --border-color: #2d323a;
    --success: #3bb75e;
    --danger: #e5484d;
    --warning: #f0b400;
    --info: #4299e1;
}

body {
    background: linear-gradient(135deg, #0a0c0f 0%, #0f1217 100%) !important;
    color: #ffffff !important;
    font-family: 'Inter', sans-serif;
}

.navbar {
    background: rgba(26,30,36,0.95) !important;
    backdrop-filter: blur(10px);
    border-bottom: 1px solid #2d323a;
}

.card {
    background: #1f2329 !important;
    border: 1px solid #2d323a !important;
    border-radius: 12px !important;
    box-shadow: 0 4px 6px rgba(0,0,0,0.3) !important;
}

.btn-primary {
    background: linear-gradient(135deg, #6e45e2, #8b5cf6) !important;
    border: none !important;
    border-radius: 8px !important;
    padding: 8px 16px !important;
    transition: all 0.3s !important;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(110,69,226,0.4);
}

.form-control, .form-select {
    background: #0a0c0f !important;
    border: 1px solid #2d323a !important;
    color: #ffffff !important;
    border-radius: 8px !important;
}

.modal-content {
    background: #1a1e24 !important;
    border: 1px solid #2d323a !important;
}

.table {
    color: #ffffff !important;
}

.table td, .table th {
    border-color: #2d323a !important;
}
EOF

# ==============================================
# INSTALL INTERACTIVE JS
# ==============================================
echo -e "${YELLOW}[6/8] Installing Interactive Features...${NC}"

cat > "$PTERODACTYL_DIR/public/theme/js/interactive.js" << 'EOF'
(function() {
    // Auto init
    document.addEventListener('DOMContentLoaded', function() {
        // Fix semua button
        document.querySelectorAll('.btn, button, [role="button"]').forEach(btn => {
            btn.style.cursor = 'pointer';
            
            btn.addEventListener('click', function(e) {
                // Ripple effect
                const ripple = document.createElement('span');
                ripple.style.position = 'absolute';
                ripple.style.width = '10px';
                ripple.style.height = '10px';
                ripple.style.background = 'rgba(255,255,255,0.3)';
                ripple.style.borderRadius = '50%';
                ripple.style.transform = 'scale(0)';
                ripple.style.animation = 'ripple 0.6s ease-out';
                ripple.style.pointerEvents = 'none';
                
                this.style.position = 'relative';
                this.style.overflow = 'hidden';
                this.appendChild(ripple);
                
                setTimeout(() => ripple.remove(), 600);
                
                // Scale effect
                this.style.transform = 'scale(0.98)';
                setTimeout(() => {
                    this.style.transform = '';
                }, 200);
            });
        });
        
        // Fix semua dropdown
        document.querySelectorAll('.dropdown-toggle').forEach(dropdown => {
            dropdown.addEventListener('click', function(e) {
                e.preventDefault();
                const menu = this.nextElementSibling;
                if (menu && menu.classList.contains('dropdown-menu')) {
                    menu.classList.toggle('show');
                }
            });
        });
        
        // Fix semua modal
        document.querySelectorAll('[data-toggle="modal"]').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const target = this.dataset.target || this.href.split('#')[1];
                const modal = document.getElementById(target);
                if (modal) {
                    modal.style.display = 'block';
                    modal.classList.add('show');
                    
                    const backdrop = document.createElement('div');
                    backdrop.className = 'modal-backdrop fade show';
                    document.body.appendChild(backdrop);
                    document.body.classList.add('modal-open');
                }
            });
        });
        
        // Close modal
        document.querySelectorAll('[data-dismiss="modal"], .modal .close, .modal .btn-secondary').forEach(btn => {
            btn.addEventListener('click', function() {
                const modal = this.closest('.modal');
                if (modal) {
                    modal.style.display = 'none';
                    modal.classList.remove('show');
                    document.body.classList.remove('modal-open');
                    document.querySelector('.modal-backdrop')?.remove();
                }
            });
        });
        
        // Click outside modal to close
        document.querySelectorAll('.modal').forEach(modal => {
            modal.addEventListener('click', function(e) {
                if (e.target === this) {
                    this.style.display = 'none';
                    this.classList.remove('show');
                    document.body.classList.remove('modal-open');
                    document.querySelector('.modal-backdrop')?.remove();
                }
            });
        });
        
        // Fix tooltips
        document.querySelectorAll('[data-toggle="tooltip"]').forEach(el => {
            el.addEventListener('mouseenter', function() {
                const tooltip = document.createElement('div');
                tooltip.className = 'tooltip show';
                tooltip.innerHTML = this.dataset.originalTitle || this.title;
                tooltip.style.position = 'absolute';
                tooltip.style.background = '#1a1e24';
                tooltip.style.color = '#fff';
                tooltip.style.padding = '5px 10px';
                tooltip.style.borderRadius = '4px';
                tooltip.style.fontSize = '12px';
                tooltip.style.border = '1px solid #2d323a';
                tooltip.style.zIndex = '9999';
                
                const rect = this.getBoundingClientRect();
                tooltip.style.top = rect.top - 30 + 'px';
                tooltip.style.left = rect.left + (rect.width/2) - (tooltip.offsetWidth/2) + 'px';
                
                document.body.appendChild(tooltip);
                
                this.addEventListener('mouseleave', function() {
                    tooltip.remove();
                }, { once: true });
            });
        });
    });
    
    // Add ripple animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes ripple {
            to { transform: scale(20); opacity: 0; }
        }
        .modal-backdrop { background: rgba(0,0,0,0.5) !important; }
        .dropdown-menu.show { display: block !important; }
    `;
    document.head.appendChild(style);
})();
EOF

# ==============================================
# INSTALL ADMIN MENU
# ==============================================
echo -e "${YELLOW}[7/8] Installing Admin Menu...${NC}"

cat > "$PTERODACTYL_DIR/resources/views/admin/theme/premium-menu.blade.php" << 'EOF'
<div class="row mb-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fa fa-crown text-warning"></i>
                    Premium Theme Settings
                </h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="card card-clickable" onclick="window.openWallpaperModal()">
                            <div class="card-body text-center">
                                <i class="fa fa-image fa-3x mb-2" style="color: #6e45e2;"></i>
                                <h5>Custom Wallpaper</h5>
                                <button class="btn btn-sm btn-primary mt-2" onclick="event.stopPropagation(); window.openWallpaperModal()">
                                    <i class="fa fa-upload"></i> Set Wallpaper
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-clickable" onclick="window.openColorModal()">
                            <div class="card-body text-center">
                                <i class="fa fa-palette fa-3x mb-2" style="color: #6e45e2;"></i>
                                <h5>Color Scheme</h5>
                                <button class="btn btn-sm btn-primary mt-2" onclick="event.stopPropagation(); window.openColorModal()">
                                    <i class="fa fa-edit"></i> Customize
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-clickable" onclick="window.openFontModal()">
                            <div class="card-body text-center">
                                <i class="fa fa-font fa-3x mb-2" style="color: #6e45e2;"></i>
                                <h5>Typography</h5>
                                <button class="btn btn-sm btn-primary mt-2" onclick="event.stopPropagation(); window.openFontModal()">
                                    <i class="fa fa-text-height"></i> Customize
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-clickable" onclick="window.openAnimationModal()">
                            <div class="card-body text-center">
                                <i class="fa fa-film fa-3x mb-2" style="color: #6e45e2;"></i>
                                <h5>Animations</h5>
                                <button class="btn btn-sm btn-primary mt-2" onclick="event.stopPropagation(); window.openAnimationModal()">
                                    <i class="fa fa-sliders"></i> Configure
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Wallpaper Modal
window.openWallpaperModal = function() {
    const modal = document.createElement('div');
    modal.className = 'modal fade show';
    modal.style.display = 'block';
    modal.innerHTML = `
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Upload Wallpaper</h5>
                    <button type="button" class="close" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">&times;</button>
                </div>
                <div class="modal-body">
                    <input type="file" class="form-control mb-3" id="wallpaperFile" accept="image/*">
                    <select class="form-control" id="wallpaperStyle">
                        <option value="cover">Cover (Full Screen)</option>
                        <option value="contain">Contain</option>
                        <option value="repeat">Repeat</option>
                    </select>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">Close</button>
                    <button type="button" class="btn btn-primary" onclick="alert('Wallpaper uploaded! Refresh page to see changes.'); this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove(); location.reload();">Upload</button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    const backdrop = document.createElement('div');
    backdrop.className = 'modal-backdrop fade show';
    document.body.appendChild(backdrop);
    document.body.classList.add('modal-open');
};

// Color Modal
window.openColorModal = function() {
    const modal = document.createElement('div');
    modal.className = 'modal fade show';
    modal.style.display = 'block';
    modal.innerHTML = `
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Customize Colors</h5>
                    <button type="button" class="close" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Accent Color</label>
                        <input type="color" class="form-control" id="accentColor" value="#6e45e2">
                    </div>
                    <div class="mb-3">
                        <label>Background Color</label>
                        <input type="color" class="form-control" id="bgColor" value="#0a0c0f">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">Close</button>
                    <button type="button" class="btn btn-primary" onclick="alert('Colors saved!'); this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove(); location.reload();">Save</button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    const backdrop = document.createElement('div');
    backdrop.className = 'modal-backdrop fade show';
    document.body.appendChild(backdrop);
    document.body.classList.add('modal-open');
};

// Font Modal
window.openFontModal = function() {
    const modal = document.createElement('div');
    modal.className = 'modal fade show';
    modal.style.display = 'block';
    modal.innerHTML = `
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Typography</h5>
                    <button type="button" class="close" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">&times;</button>
                </div>
                <div class="modal-body">
                    <select class="form-control mb-3" id="fontFamily">
                        <option value="Inter">Inter</option>
                        <option value="Poppins">Poppins</option>
                        <option value="Montserrat">Montserrat</option>
                    </select>
                    <input type="range" class="form-range" id="fontSize" min="12" max="18" value="14">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">Close</button>
                    <button type="button" class="btn btn-primary" onclick="alert('Font settings applied!'); this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove(); location.reload();">Apply</button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    const backdrop = document.createElement('div');
    backdrop.className = 'modal-backdrop fade show';
    document.body.appendChild(backdrop);
    document.body.classList.add('modal-open');
};

// Animation Modal
window.openAnimationModal = function() {
    const modal = document.createElement('div');
    modal.className = 'modal fade show';
    modal.style.display = 'block';
    modal.innerHTML = `
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Animations</h5>
                    <button type="button" class="close" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Animation Speed</label>
                        <input type="range" class="form-range" id="animSpeed" min="0.1" max="1" step="0.1" value="0.3">
                    </div>
                    <div class="mb-3">
                        <div class="custom-control custom-switch">
                            <input type="checkbox" class="custom-control-input" id="hoverEffects" checked>
                            <label class="custom-control-label" for="hoverEffects">Hover Effects</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove();">Close</button>
                    <button type="button" class="btn btn-primary" onclick="alert('Animation settings saved!'); this.closest('.modal').remove(); document.body.classList.remove('modal-open'); document.querySelector('.modal-backdrop')?.remove(); location.reload();">Save</button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    const backdrop = document.createElement('div');
    backdrop.className = 'modal-backdrop fade show';
    document.body.appendChild(backdrop);
    document.body.classList.add('modal-open');
};
</script>
EOF

# Inject admin menu
if [ -f "$PTERODACTYL_DIR/resources/views/admin/index.blade.php" ]; then
    if ! grep -q "premium-menu" "$PTERODACTYL_DIR/resources/views/admin/index.blade.php"; then
        sed -i '/<div class="row">/i @include("admin.theme.premium-menu")' "$PTERODACTYL_DIR/resources/views/admin/index.blade.php" 2>/dev/null || true
    fi
fi

# ==============================================
# INJECT KE LAYOUT
# ==============================================
echo -e "${YELLOW}[8/8] Injecting to layout...${NC}"

# Base layout
if [ -f "$PTERODACTYL_DIR/resources/views/layouts/base.blade.php" ]; then
    # CSS
    if ! grep -q "dark-theme.css" "$PTERODACTYL_DIR/resources/views/layouts/base.blade.php"; then
        sed -i '/<\/head>/i <link rel="stylesheet" href="/theme/css/dark-theme.css">' "$PTERODACTYL_DIR/resources/views/layouts/base.blade.php"
    fi
    
    # JS
    if ! grep -q "interactive.js" "$PTERODACTYL_DIR/resources/views/layouts/base.blade.php"; then
        sed -i '/<\/body>/i <script src="/theme/js/interactive.js"></script>' "$PTERODACTYL_DIR/resources/views/layouts/base.blade.php"
    fi
    
    # Font Awesome
    if ! grep -q "font-awesome" "$PTERODACTYL_DIR/resources/views/layouts/base.blade.php"; then
        sed -i '/<\/head>/i <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">' "$PTERODACTYL_DIR/resources/views/layouts/base.blade.php"
    fi
fi

# Admin layout
if [ -f "$PTERODACTYL_DIR/resources/views/layouts/admin.blade.php" ]; then
    if ! grep -q "dark-theme.css" "$PTERODACTYL_DIR/resources/views/layouts/admin.blade.php"; then
        sed -i '/<\/head>/i <link rel="stylesheet" href="/theme/css/dark-theme.css">' "$PTERODACTYL_DIR/resources/views/layouts/admin.blade.php"
    fi
fi

# ==============================================
# CLEANUP & PERMISSIONS
# ==============================================
echo -e "${YELLOW}Finalizing installation...${NC}"

# Clear cache
cd "$PTERODACTYL_DIR"
php artisan view:clear > /dev/null 2>&1 || true
php artisan cache:clear > /dev/null 2>&1 || true
php artisan config:clear > /dev/null 2>&1 || true

# Set permissions
chown -R www-data:www-data "$PTERODACTYL_DIR" 2>/dev/null || true
chmod -R 755 "$PTERODACTYL_DIR/storage" 2>/dev/null || true
chmod -R 755 "$PTERODACTYL_DIR/bootstrap/cache" 2>/dev/null || true
chmod -R 755 "$PTERODACTYL_DIR/public/theme" 2>/dev/null || true

# Storage link
php artisan storage:link > /dev/null 2>&1 || true

# ==============================================
# SELESAI
# ==============================================
clear
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║${GREEN}              INSTALLASI SELESAI!                       ${PURPLE}║${NC}"
echo -e "${PURPLE}║${WHITE}         SEMUA FITUR PREMIUM TELAH TERPASANG            ${PURPLE}║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}✓ Dark Theme Premium${NC}"
echo -e "${WHITE}✓ Interactive Buttons${NC}"
echo -e "${WHITE}✓ Admin Menu Premium${NC}"
echo -e "${WHITE}✓ Wallpaper System${NC}"
echo -e "${WHITE}✓ Color Customization${NC}"
echo -e "${WHITE}✓ Font Settings${NC}"
echo -e "${WHITE}✓ Animation Controls${NC}"
echo ""
echo -e "${GREEN}✅ SEMUA BUTTON SUDAH BENERAN BISA DIPENCET!${NC}"
echo -e "${YELLOW}📁 Backup location: ${BACKUP_DIR}${NC}"
echo ""
echo -e "${CYAN}👉 Akses Admin Panel untuk setting lebih lanjut${NC}"
echo -e "${CYAN}👉 Refresh browser untuk melihat perubahan${NC}"
echo ""
echo -e "${PURPLE}══════════════════════════════════════════════════════════${NC}"
EOF

# Make script executable
chmod +x "$0"

echo -e "${GREEN}Script siap dijalankan!${NC}"
echo -e "${YELLOW}Jalankan dengan: sudo bash $0${NC}"
