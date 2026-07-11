#!/bin/bash

# ======================================================
# Pterodactyl Admin Notification Popup Installer
# Bisa diubah textnya dari Settings Admin Panel
# ======================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PANEL_PATH="/var/www/pterodactyl"
BACKUP_DIR="/root/pterodactyl_backups"

show_banner() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════╗"
    echo "║     ADMIN NOTIFICATION POPUP INSTALLER       ║"
    echo "║     Bisa diubah dari Settings Admin          ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}✗ Harus root!${NC}"
        exit 1
    fi
}

check_panel() {
    if [[ ! -d "$PANEL_PATH" ]]; then
        echo -e "${RED}✗ Panel tidak ditemukan di $PANEL_PATH${NC}"
        exit 1
    fi
}

create_backup() {
    mkdir -p "$BACKUP_DIR"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    echo -e "${YELLOW}→ Backup file asli...${NC}"
    
    # Backup semua file yang akan diubah
    cp "$PANEL_PATH/resources/views/layouts/admin.blade.php" "$BACKUP_DIR/admin.blade.php.$timestamp" 2>/dev/null
    cp "$PANEL_PATH/resources/views/layouts/master.blade.php" "$BACKUP_DIR/master.blade.php.$timestamp" 2>/dev/null
    cp "$PANEL_PATH/app/Http/Controllers/Admin/SettingsController.php" "$BACKUP_DIR/SettingsController.php.$timestamp" 2>/dev/null
    cp "$PANEL_PATH/resources/views/admin/settings/index.blade.php" "$BACKUP_DIR/settings_index.blade.php.$timestamp" 2>/dev/null
    
    echo "$timestamp" > "$BACKUP_DIR/last_backup.txt"
    echo -e "${GREEN}✓ Backup berhasil!${NC}"
}

install_notification() {
    show_banner
    echo -e "${BLUE}[ INSTALL NOTIFICATION ]${NC}\n"
    
    check_root
    check_panel
    create_backup
    
    echo -e "${YELLOW}→ Menginstall notification popup...${NC}"
    
    # ==================== 1. MODIFY ADMIN LAYOUT ====================
    ADMIN_LAYOUT="$PANEL_PATH/resources/views/layouts/admin.blade.php"
    
    # Cek apakah sudah terinstall
    if grep -q "ADMIN_NOTIFICATION" "$ADMIN_LAYOUT" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Notification sudah terinstall!${NC}"
        read -p "Reinstall? (y/n): " reinstall
        [[ "$reinstall" != "y" ]] && return
    fi
    
    # Tambahkan code di admin.blade.php
    cat >> "$ADMIN_LAYOUT" << 'EOF'

<!-- ADMIN_NOTIFICATION_START -->
@if(Setting::get('notification_enabled', false))
<div id="adminNotification" class="fixed inset-x-0 {{ Setting::get('notification_position', 'top-0') }} z-50 p-4 transition-all duration-500" style="display: none;">
    <div class="max-w-4xl mx-auto">
        <div class="alert alert-{{ Setting::get('notification_type', 'info') }} shadow-2xl rounded-lg border-l-4 flex items-center justify-between p-4">
            <div class="flex items-center space-x-3">
                <i class="fas fa-{{ Setting::get('notification_icon', 'info-circle') }} text-xl"></i>
                <div class="notification-content text-lg font-medium">
                    {!! Setting::get('notification_text', '') !!}
                </div>
            </div>
            <button onclick="closeAdminNotification()" class="text-gray-500 hover:text-gray-700 ml-4">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</div>

<script>
    function showAdminNotification() {
        const popup = document.getElementById('adminNotification');
        if (popup) {
            popup.style.display = 'block';
            setTimeout(() => {
                popup.style.opacity = '1';
                popup.style.transform = 'translateY(0)';
            }, 100);
            
            const autohide = {{ Setting::get('notification_autohide', 5) }};
            if (autohide > 0) {
                setTimeout(() => {
                    closeAdminNotification();
                }, autohide * 1000);
            }
        }
    }
    
    function closeAdminNotification() {
        const popup = document.getElementById('adminNotification');
        if (popup) {
            popup.style.opacity = '0';
            popup.style.transform = 'translateY(-20px)';
            setTimeout(() => {
                popup.style.display = 'none';
            }, 500);
        }
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        showAdminNotification();
    });
</script>
@endif
<!-- ADMIN_NOTIFICATION_END -->
EOF

    # ==================== 2. MODIFY MASTER LAYOUT ====================
    MASTER_LAYOUT="$PANEL_PATH/resources/views/layouts/master.blade.php"
    if [[ -f "$MASTER_LAYOUT" ]]; then
        cat >> "$MASTER_LAYOUT" << 'EOF'

<!-- ADMIN_NOTIFICATION_START -->
@if(Setting::get('notification_enabled', false))
<div id="adminNotification" class="fixed inset-x-0 {{ Setting::get('notification_position', 'top-0') }} z-50 p-4 transition-all duration-500" style="display: none;">
    <div class="max-w-4xl mx-auto">
        <div class="alert alert-{{ Setting::get('notification_type', 'info') }} shadow-2xl rounded-lg border-l-4 flex items-center justify-between p-4">
            <div class="flex items-center space-x-3">
                <i class="fas fa-{{ Setting::get('notification_icon', 'info-circle') }} text-xl"></i>
                <div class="notification-content text-lg font-medium">
                    {!! Setting::get('notification_text', '') !!}
                </div>
            </div>
            <button onclick="closeAdminNotification()" class="text-gray-500 hover:text-gray-700 ml-4">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</div>

<script>
    function showAdminNotification() {
        const popup = document.getElementById('adminNotification');
        if (popup) {
            popup.style.display = 'block';
            setTimeout(() => {
                popup.style.opacity = '1';
                popup.style.transform = 'translateY(0)';
            }, 100);
            
            const autohide = {{ Setting::get('notification_autohide', 5) }};
            if (autohide > 0) {
                setTimeout(() => {
                    closeAdminNotification();
                }, autohide * 1000);
            }
        }
    }
    
    function closeAdminNotification() {
        const popup = document.getElementById('adminNotification');
        if (popup) {
            popup.style.opacity = '0';
            popup.style.transform = 'translateY(-20px)';
            setTimeout(() => {
                popup.style.display = 'none';
            }, 500);
        }
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        showAdminNotification();
    });
</script>
@endif
<!-- ADMIN_NOTIFICATION_END -->
EOF
    fi

    # ==================== 3. MODIFY SETTINGS CONTROLLER ====================
    CONTROLLER="$PANEL_PATH/app/Http/Controllers/Admin/SettingsController.php"
    
    if [[ -f "$CONTROLLER" ]]; then
        # Cari function index() dan tambahkan variable
        if ! grep -q "notification_enabled" "$CONTROLLER"; then
            sed -i '/public function index()/a \
        $notification_settings = [\
            "notification_enabled" => Setting::get("notification_enabled", false),\
            "notification_text" => Setting::get("notification_text", ""),\
            "notification_type" => Setting::get("notification_type", "info"),\
            "notification_position" => Setting::get("notification_position", "top-0"),\
            "notification_icon" => Setting::get("notification_icon", "info-circle"),\
            "notification_autohide" => Setting::get("notification_autohide", 5),\
        ];\
        return view("admin.settings.index", compact("notification_settings"));' "$CONTROLLER"
        fi
    fi

    # ==================== 4. MODIFY SETTINGS VIEW ====================
    SETTINGS_VIEW="$PANEL_PATH/resources/views/admin/settings/index.blade.php"
    
    if [[ -f "$SETTINGS_VIEW" ]]; then
        # Cari form dan tambahkan section notification
        if ! grep -q "Notification Settings" "$SETTINGS_VIEW"; then
            sed -i '/<\/form>/i \
            <!-- Notification Settings -->\
            <div class="mt-8 bg-white shadow overflow-hidden sm:rounded-lg">\
                <div class="px-4 py-5 sm:px-6">\
                    <h3 class="text-lg leading-6 font-medium text-gray-900">\
                        <i class="fas fa-bell"></i> Notification Popup Settings\
                    </h3>\
                    <p class="mt-1 text-sm text-gray-500">\
                        Customize the notification popup that appears to all users.\
                    </p>\
                </div>\
                <div class="border-t border-gray-200 px-4 py-5 sm:p-6">\
                    <div class="grid grid-cols-1 gap-6">\
                        <!-- Enable/Disable -->\
                        <div class="flex items-start">\
                            <div class="flex items-center h-5">\
                                <input type="checkbox" name="notification_enabled" id="notification_enabled" \
                                    {{ Setting::get("notification_enabled", false) ? "checked" : "" }} \
                                    class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded">\
                            </div>\
                            <div class="ml-3 text-sm">\
                                <label for="notification_enabled" class="font-medium text-gray-700">Enable Notification</label>\
                                <p class="text-gray-500">Show notification popup to all users</p>\
                            </div>\
                        </div>\
                        \
                        <!-- Notification Text -->\
                        <div>\
                            <label for="notification_text" class="block text-sm font-medium text-gray-700">Notification Message</label>\
                            <textarea name="notification_text" id="notification_text" rows="3" \
                                class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"\
                                placeholder="Enter your notification message here...">{{ Setting::get("notification_text", "") }}</textarea>\
                            <p class="mt-1 text-sm text-gray-500">HTML tags are allowed for formatting</p>\
                        </div>\
                        \
                        <!-- Notification Type -->\
                        <div>\
                            <label for="notification_type" class="block text-sm font-medium text-gray-700">Notification Type</label>\
                            <select name="notification_type" id="notification_type" \
                                class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md">\
                                <option value="info" {{ Setting::get("notification_type", "info") == "info" ? "selected" : "" }}>Info (Blue)</option>\
                                <option value="success" {{ Setting::get("notification_type", "info") == "success" ? "selected" : "" }}>Success (Green)</option>\
                                <option value="warning" {{ Setting::get("notification_type", "info") == "warning" ? "selected" : "" }}>Warning (Yellow)</option>\
                                <option value="danger" {{ Setting::get("notification_type", "info") == "danger" ? "selected" : "" }}>Danger (Red)</option>\
                            </select>\
                        </div>\
                        \
                        <!-- Notification Position -->\
                        <div>\
                            <label for="notification_position" class="block text-sm font-medium text-gray-700">Position</label>\
                            <select name="notification_position" id="notification_position" \
                                class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md">\
                                <option value="top-0" {{ Setting::get("notification_position", "top-0") == "top-0" ? "selected" : "" }}>Top</option>\
                                <option value="bottom-0" {{ Setting::get("notification_position", "top-0") == "bottom-0" ? "selected" : "" }}>Bottom</option>\
                            </select>\
                        </div>\
                        \
                        <!-- Icon -->\
                        <div>\
                            <label for="notification_icon" class="block text-sm font-medium text-gray-700">Icon (Font Awesome)</label>\
                            <input type="text" name="notification_icon" id="notification_icon" \
                                value="{{ Setting::get("notification_icon", "info-circle") }}" \
                                class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"\
                                placeholder="info-circle, check-circle, exclamation-triangle, times-circle">\
                            <p class="mt-1 text-sm text-gray-500">Font Awesome icon name without the "fa-" prefix</p>\
                        </div>\
                        \
                        <!-- Auto Hide -->\
                        <div>\
                            <label for="notification_autohide" class="block text-sm font-medium text-gray-700">Auto Hide (seconds)</label>\
                            <input type="number" name="notification_autohide" id="notification_autohide" \
                                value="{{ Setting::get("notification_autohide", 5) }}" \
                                min="0" max="60" \
                                class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">\
                            <p class="mt-1 text-sm text-gray-500">Set to 0 for no auto-hide</p>\
                        </div>\
                    </div>\
                </div>\
            </div>' "$SETTINGS_VIEW"
        fi
    fi

    # ==================== 5. CREATE SETTINGS PROVIDER ====================
    cat > "$PANEL_PATH/app/Providers/SettingsServiceProvider.php" << 'EOF'
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Blade;

class SettingsServiceProvider extends ServiceProvider
{
    public function boot()
    {
        Blade::directive('setting', function ($expression) {
            return "<?php echo \\App\\Models\\Setting::get($expression); ?>";
        });
    }

    public function register()
    {
        //
    }
}
EOF

    # ==================== 6. UPDATE SETTINGS MODEL ====================
    if [[ ! -f "$PANEL_PATH/app/Models/Setting.php" ]]; then
        cat > "$PANEL_PATH/app/Models/Setting.php" << 'EOF'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

class Setting extends Model
{
    protected $fillable = ['key', 'value'];
    public $timestamps = true;

    public static function get($key, $default = null)
    {
        $setting = self::where('key', $key)->first();
        return $setting ? $setting->value : $default;
    }

    public static function set($key, $value)
    {
        $setting = self::updateOrCreate(
            ['key' => $key],
            ['value' => $value]
        );
        Cache::forget('settings');
        return $setting;
    }
}
EOF
    fi

    # ==================== 7. CREATE MIGRATION ====================
    if [[ ! -f "$PANEL_PATH/database/migrations/2024_01_01_000000_create_settings_table.php" ]]; then
        cat > "$PANEL_PATH/database/migrations/2024_01_01_000000_create_settings_table.php" << 'EOF'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSettingsTable extends Migration
{
    public function up()
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();
            $table->text('value')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('settings');
    }
}
EOF
    fi

    # ==================== 8. RUN MIGRATION ====================
    echo -e "${YELLOW}→ Running migration...${NC}"
    cd "$PANEL_PATH"
    php artisan migrate
    
    # ==================== 9. CLEAR CACHE ====================
    echo -e "${YELLOW}→ Clearing cache...${NC}"
    php artisan view:clear
    php artisan cache:clear
    php artisan config:clear
    
    echo -e "\n${GREEN}════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ NOTIFICATION INSTALLED SUCCESSFULLY!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════${NC}"
    echo -e "\n${YELLOW}📌 CARA PAKAI:${NC}"
    echo -e "1. Login ke Admin Panel Pterodactyl"
    echo -e "2. Pergi ke ${BLUE}Admin → Settings${NC}"
    echo -e "3. Scroll ke bawah cari ${BLUE}Notification Popup Settings${NC}"
    echo -e "4. Centang ${BLUE}Enable Notification${NC}"
    echo -e "5. Tulis pesan yang mau ditampilkan"
    echo -e "6. Klik ${BLUE}Save${NC}"
    echo -e "\n${GREEN}✨ Notification akan muncul di semua halaman!${NC}"
}

uninstall_notification() {
    show_banner
    echo -e "${RED}[ UNINSTALL NOTIFICATION ]${NC}\n"
    
    check_root
    
    echo -e "${YELLOW}⚠ Ini akan menghapus semua file dan restore backup${NC}"
    read -p "Yakin? (y/n): " confirm
    [[ "$confirm" != "y" ]] && return
    
    if [[ -f "$BACKUP_DIR/last_backup.txt" ]]; then
        TIMESTAMP=$(cat "$BACKUP_DIR/last_backup.txt")
        echo -e "${YELLOW}→ Restore dari backup: $TIMESTAMP${NC}"
        
        cp "$BACKUP_DIR/admin.blade.php.$TIMESTAMP" "$PANEL_PATH/resources/views/layouts/admin.blade.php" 2>/dev/null
        cp "$BACKUP_DIR/master.blade.php.$TIMESTAMP" "$PANEL_PATH/resources/views/layouts/master.blade.php" 2>/dev/null
        cp "$BACKUP_DIR/SettingsController.php.$TIMESTAMP" "$PANEL_PATH/app/Http/Controllers/Admin/SettingsController.php" 2>/dev/null
        cp "$BACKUP_DIR/settings_index.blade.php.$TIMESTAMP" "$PANEL_PATH/resources/views/admin/settings/index.blade.php" 2>/dev/null
        
        echo -e "${GREEN}✓ Files restored!${NC}"
    else
        echo -e "${YELLOW}→ No backup found, removing manually...${NC}"
        
        # Hapus dari layout
        for file in "$PANEL_PATH/resources/views/layouts/admin.blade.php" "$PANEL_PATH/resources/views/layouts/master.blade.php"; do
            if [[ -f "$file" ]]; then
                sed -i '/<!-- ADMIN_NOTIFICATION_START -->/,/<!-- ADMIN_NOTIFICATION_END -->/d' "$file"
            fi
        done
        
        # Hapus dari settings view
        if [[ -f "$PANEL_PATH/resources/views/admin/settings/index.blade.php" ]]; then
            sed -i '/<!-- Notification Settings -->/,/<\/div>/d' "$PANEL_PATH/resources/views/admin/settings/index.blade.php"
        fi
    fi
    
    # Clear cache
    cd "$PANEL_PATH"
    php artisan view:clear
    php artisan cache:clear
    
    echo -e "\n${GREEN}✓ Uninstall complete! Panel restored.${NC}"
}

# MAIN MENU
while true; do
    show_banner
    echo -e "${GREEN}1) Install Notification Popup (Bisa diubah dari Settings)${NC}"
    echo -e "${RED}2) Uninstall (Kembali ke default)${NC}"
    echo -e "${YELLOW}3) Exit${NC}"
    echo ""
    read -p "Pilih [1-3]: " choice
    
    case $choice in
        1) install_notification
           read -p "Press Enter..." ;;
        2) uninstall_notification
           read -p "Press Enter..." ;;
        3) echo -e "${GREEN}Bye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
done
