#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════╗
# ║     Hyprlands SDDM Video Themes — install.sh               ║
# ║     Ultra-Premium 23 Cinematic Login Screen Themes         ║
# ╚════════════════════════════════════════════════════════════╝
# Supports: Arch, Fedora, Ubuntu/Debian, openSUSE, Void Linux

set -euo pipefail

readonly THEME_NAME="hyprlands-video-themes"
readonly THEMES_DIR="/usr/share/sddm/themes"
readonly THEME_DST="${THEMES_DIR}/${THEME_NAME}"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly METADATA="${THEME_DST}/metadata.desktop"
readonly DATE=$(date +%s)
readonly LOG="/tmp/${THEME_NAME}_install_${DATE}.log"

readonly -a THEME_VARIANTS=(
    "boy_and_dragon"
    "sunset_train"
    "nebula_black_hole"
    "blind_dragon"
    "cloud_castle"
    "crimson_moon"
    "dawn_wanderer"
    "evelyn"
    "evening_drive"
    "fantasy_flute"
    "golden_hour"
    "japanese_spring"
    "majestic_peaks"
    "digital_shadows"
    "moonlight_seascape"
    "mountain_horizon"
    "samurai_tree"
    "samurai_spirit"
    "torn_mask"
    "tranquil_lake"
    "under_cherry_tree"
    "dragons_gaze"
    "vi_and_powder"
)

readonly -a THEME_NAMES=(
    "🐉  Boy & Dragon"
    "🚆  Sunset Train"
    "🌌  Nebula Black Hole"
    "🐲  Blind Dragon"
    "🏰  Cloud Castle"
    "🌕  Crimson Moon"
    "🌅  Dawn Wanderer"
    "💃  Evelyn"
    "🚗  Evening Drive"
    "🎵  Fantasy Flute"
    "🌄  Golden Hour"
    "🌸  Japanese Spring"
    "🗻  Majestic Peaks"
    "🖥️   Digital Shadows"
    "🌊  Moonlight Seascape"
    "⛰️   Mountain Horizon"
    "🌳  Samurai Tree"
    "⚔️   Samurai Spirit"
    "🎭  Torn Mask"
    "🏞️   Tranquil Lake"
    "🌸  Under Cherry Tree"
    "👁️   Dragon's Gaze"
    "💥  Vi & Powder"
)

# ──────────────────────────────────────────────────────────────
# Logging helpers (ultra-premium gum-powered with plain fallback)
# ──────────────────────────────────────────────────────────────
info()  { command -v gum &>/dev/null && gum style --foreground 212 "✨  $*" || echo -e "\e[38;5;212m✨  $*\e[0m"; }
success() { command -v gum &>/dev/null && gum style --foreground 118 "✅  $*" || echo -e "\e[38;5;118m✅  $*\e[0m"; }
warn()  { command -v gum &>/dev/null && gum style --foreground 220 "⚡  $*" || echo -e "\e[38;5;220m⚡  $*\e[0m"; }
error() { command -v gum &>/dev/null && gum style --foreground 196 "💀  $*" >&2 || echo -e "\e[38;5;196m💀  $*\e[0m" >&2; }
title() {
    clear
    if command -v gum &>/dev/null; then
        gum style \
            --foreground 212 --border-foreground 99 \
            --border rounded --align center --width 65 \
            --margin "1 1" --padding "1 2" \
            "✨ 💎 HYPRLANDS SDDM THEMES 💎 ✨" "" "Ultra-Premium Video Wallpapers" "with immersive cinematic ambiance" "" "Designed for perfection."
    else
        echo -e "\n\e[1;38;5;213m✨ 💎 HYPRLANDS SDDM THEMES 💎 ✨\e[0m\n"
    fi
}

confirm() {
    command -v gum &>/dev/null && gum confirm "$1" ||
    { echo -n "$1 (y/n): "; read -r r; [[ "$r" =~ ^[Yy]$ ]]; }
}

choose() {
    command -v gum &>/dev/null && gum choose --cursor.foreground 212 --item.foreground 252 --selected.foreground 213 "$@" ||
    { select opt in "$@"; do [[ -n "$opt" ]] && { echo "$opt"; break; }; done; }
}

spin() {
    local ttl="$1"; shift
    command -v gum &>/dev/null && gum spin --spinner points --spinner.foreground 212 --title.foreground 140 --title "$ttl" -- "$@" ||
    { echo "$ttl"; "$@"; }
}

# ──────────────────────────────────────────────────────────────
# Detect package manager
# ──────────────────────────────────────────────────────────────
detect_pm() {
    for m in pacman xbps-install dnf zypper apt; do
        command -v "$m" &>/dev/null && { echo "$m"; return; }
    done
    echo "unknown"
}

# ──────────────────────────────────────────────────────────────
# Install gum (optional, better TUI)
# ──────────────────────────────────────────────────────────────
install_gum() {
    local pm; pm=$(detect_pm)
    case "$pm" in
        pacman)       sudo pacman -S --noconfirm gum ;;
        dnf)          sudo dnf install -y gum ;;
        zypper)       sudo zypper install -y gum ;;
        xbps-install) sudo xbps-install -y gum ;;
        apt)
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
                | sudo tee /etc/apt/sources.list.d/charm.list
            sudo apt update && sudo apt install -y gum ;;
        *) warn "Cannot install gum automatically; using plain UI"; return 1 ;;
    esac
}

check_gum() {
    command -v gum &>/dev/null && return
    warn "gum not found — we strongly recommend it for the best installer experience!"
    confirm "Install gum now?" && install_gum && { success "gum installed! Restarting..."; main; } || warn "Continuing with plain UI"
}

# ──────────────────────────────────────────────────────────────
# Step 1 — Install dependencies
# ──────────────────────────────────────────────────────────────
install_deps() {
    local pm; pm=$(detect_pm)
    info "Package manager: $pm"
    case "$pm" in
        pacman)
            spin "Installing SDDM & Qt6 multimedia..." \
                sudo pacman --needed -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg qt6-5compat ;;
        dnf)
            spin "Installing SDDM & Qt6 multimedia..." \
                sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia qt6-qt5compat ;;
        zypper)
            spin "Installing SDDM & Qt6 multimedia..." \
                sudo zypper install -y sddm libQt6Svg6 qt6-virtualkeyboard qt6-multimedia qt6-qt5compat-imports ;;
        xbps-install)
            spin "Installing SDDM & Qt6 multimedia..." \
                sudo xbps-install -y sddm qt6-svg qt6-virtualkeyboard qt6-multimedia qt6-5compat ;;
        apt)
            spin "Updating apt..." sudo apt update
            spin "Installing SDDM & Qt6 multimedia..." \
                sudo apt install -y sddm qt6-svg-dev qml6-module-qtquick-virtualkeyboard \
                    qt6-multimedia-dev gstreamer1.0-libav gstreamer1.0-plugins-bad qml6-module-qt5compat-graphicaleffects ;;
        *) error "Unsupported package manager. Install manually: sddm qt6-multimedia qt6-svg qt6-virtualkeyboard"; return 1 ;;
    esac
    success "Dependencies installed."
}

# ──────────────────────────────────────────────────────────────
# Step 2 — Install fonts
# ──────────────────────────────────────────────────────────────
install_fonts() {
    local font_dst="/usr/share/fonts/hyprlands-sddm"
    sudo mkdir -p "$font_dst"

    # Copy bundled fonts from the theme's Fonts/ directory
    if [[ -d "${SCRIPT_DIR}/Fonts" ]]; then
        spin "Installing bundled fonts..." \
            sudo cp -r "${SCRIPT_DIR}/Fonts/"* "$font_dst/"
        info "Bundled fonts copied."
    fi

    # Copy fonts from sddm-astronaut-theme if available
    local astro_fonts="$HOME/sddm-astronaut-theme/Fonts"
    if [[ -d "$astro_fonts" ]]; then
        spin "Copying fonts from sddm-astronaut-theme..." \
            sudo cp -r "${astro_fonts}/"* "$font_dst/"
        info "sddm-astronaut-theme fonts copied (includes Electroharmonix)."
    fi

    # Attempt to download decorative East-Asian fonts from public sources
    local tmp_fonts; tmp_fonts=$(mktemp -d)
    declare -A FONT_URLS=(
        ["Electroharmonix.otf"]="https://github.com/Keyitdev/sddm-astronaut-theme/raw/master/Fonts/Electroharmonix.otf"
    )
    for fname in "${!FONT_URLS[@]}"; do
        if [[ ! -f "$font_dst/$fname" ]]; then
            if curl -fsSL --max-time 10 "${FONT_URLS[$fname]}" -o "$tmp_fonts/$fname" 2>/dev/null; then
                sudo cp "$tmp_fonts/$fname" "$font_dst/"
                info "Downloaded: $fname"
            else
                warn "Could not download $fname — place it manually in $font_dst/"
            fi
        else
            info "$fname already present."
        fi
    done
    rm -rf "$tmp_fonts"

    spin "Refreshing font cache..." sudo fc-cache -fv &>/dev/null
    success "Fonts installed to $font_dst"
}

# ──────────────────────────────────────────────────────────────
# Step 3 — Copy theme to SDDM themes directory
# ──────────────────────────────────────────────────────────────
copy_theme() {
    # Backup existing installation
    [[ -d "$THEME_DST" ]] && sudo mv "$THEME_DST" "${THEME_DST}_backup_${DATE}"

    sudo mkdir -p "$THEME_DST"
    spin "Copying theme files..." sudo cp -r "${SCRIPT_DIR}/"* "$THEME_DST/"

    # Ensure Backgrounds symlink from sddm-astronaut-theme if present
    local astro_bg="$HOME/sddm-astronaut-theme/Backgrounds"
    if [[ -d "$astro_bg" ]]; then
        sudo ln -sf "$astro_bg" "${THEME_DST}/Backgrounds_astronaut" 2>/dev/null || true
    fi

    sudo chmod -R 755 "$THEME_DST"
    success "Theme installed successfully to $THEME_DST"
}

# ──────────────────────────────────────────────────────────────
# Step 4 — Configure SDDM
# ──────────────────────────────────────────────────────────────
configure_sddm() {
    # Main SDDM config
    sudo mkdir -p /etc/sddm.conf.d
    printf '[Theme]\nCurrent=%s\n' "$THEME_NAME" | sudo tee /etc/sddm.conf >/dev/null

    # Virtual keyboard
    printf '[General]\nInputMethod=qtvirtualkeyboard\n' \
        | sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null

    success "SDDM configured. Active theme set to: $THEME_NAME"
}

# ──────────────────────────────────────────────────────────────
# Step 5 — Select theme variant via interactive menu
# ──────────────────────────────────────────────────────────────
select_variant() {
    [[ ! -f "$METADATA" ]] && { error "Please install the theme main files first (Option 4)."; return 1; }

    local pretty i=0
    declare -a pretty_names=()
    for name in "${THEME_NAMES[@]}"; do
        pretty_names+=("$name")
    done

    info "Select your desired masterpiece:"
    local chosen; chosen=$(choose "${pretty_names[@]}")

    # Map display name back to file key
    for i in "${!THEME_NAMES[@]}"; do
        if [[ "${THEME_NAMES[$i]}" == "$chosen" ]]; then
            local variant="${THEME_VARIANTS[$i]}"
            sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${variant}.conf|" "$METADATA"
            success "Active variant set to → $variant!"
            return
        fi
    done
    warn "Selection unclear; keeping current variant."
}

# ──────────────────────────────────────────────────────────────
# Step 6 — Set user avatar (AccountsService)
# ──────────────────────────────────────────────────────────────
setup_avatar() {
    local avatar_dir="/var/lib/AccountsService/icons"
    local avatar_conf="/var/lib/AccountsService/users/${USER}"

    if [[ ! -f "${avatar_dir}/${USER}" ]]; then
        warn "No avatar found for '$USER' at ${avatar_dir}/${USER}"
        info "To set your avatar, simply copy an image to: ${avatar_dir}/${USER}"
        info "Example: sudo cp ~/my-photo.png ${avatar_dir}/${USER}"
        return
    fi
    success "Avatar already configured for $USER at ${avatar_dir}/${USER}"
}

# ──────────────────────────────────────────────────────────────
# Step 7 — Preview the currently configured theme variant
# ──────────────────────────────────────────────────────────────
preview_theme() {
    if ! command -v sddm-greeter-qt6 &>/dev/null; then
        error "sddm-greeter-qt6 not found. Install SDDM with Qt6 first."
        return 1
    fi
    [[ ! -d "$THEME_DST" ]] && { error "Install theme first."; return 1; }

    local variant; variant=$(sed -n 's|^ConfigFile=Themes/\(.*\)\.conf|\1|p' "$METADATA" 2>/dev/null || echo "not set")
    info "Launching preview engine for: $variant"

    sddm-greeter-qt6 --test-mode --theme "$THEME_DST/" >"$LOG" 2>&1 &
    local pid=$!
    for _ in {1..15}; do kill -0 "$pid" 2>/dev/null || break; sleep 1; done
    kill -0 "$pid" 2>/dev/null && kill "$pid"
    success "Preview closed smoothly. Logs saved at: $LOG"
}

# ──────────────────────────────────────────────────────────────
# Step 7.5 — Preview ANY theme without changing active install permanently
# ──────────────────────────────────────────────────────────────
preview_any_theme() {
    if ! command -v sddm-greeter-qt6 &>/dev/null; then
        error "sddm-greeter-qt6 not found. Install SDDM with Qt6 first."
        return 1
    fi
    [[ ! -d "$THEME_DST" ]] && { error "Install theme files first (Option 4)."; return 1; }

    info "Which theme would you like to preview?"
    local i=0
    declare -a pretty_names=()
    for name in "${THEME_NAMES[@]}"; do
        pretty_names+=("$name")
    done

    local chosen; chosen=$(choose "${pretty_names[@]}")
    local variant=""

    for i in "${!THEME_NAMES[@]}"; do
        if [[ "${THEME_NAMES[$i]}" == "$chosen" ]]; then
            variant="${THEME_VARIANTS[$i]}"
            break
        fi
    done

    [[ -z "$variant" ]] && { warn "Preview canceled."; return 1; }

    info "Launching preview engine for: $variant"
    
    local original_variant
    original_variant=$(sed -n 's|^ConfigFile=Themes/\(.*\)\.conf|\1|p' "$METADATA" 2>/dev/null || echo "")

    sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${variant}.conf|" "$METADATA"

    sddm-greeter-qt6 --test-mode --theme "$THEME_DST/" >"$LOG" 2>&1 &
    local pid=$!
    for _ in {1..15}; do kill -0 "$pid" 2>/dev/null || break; sleep 1; done
    kill -0 "$pid" 2>/dev/null && kill "$pid"
    
    if [[ -n "$original_variant" && "$original_variant" != "$variant" ]]; then
        echo
        info "Preview finished. Did you like that theme?"
        if confirm "Keep $variant as the active theme permanently?"; then
            success "Awesome! Active variant is now $variant."
        else
            sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${original_variant}.conf|" "$METADATA"
            info "Reverted to previous active theme: $original_variant"
        fi
    fi
}

# ──────────────────────────────────────────────────────────────
# Step 8 — Enable SDDM service
# ──────────────────────────────────────────────────────────────
enable_sddm() {
    command -v systemctl &>/dev/null || { error "systemctl not found. This OS may use another init system."; return 1; }
    sudo systemctl disable display-manager.service 2>/dev/null || true
    sudo systemctl enable sddm.service
    success "SDDM service dynamically enabled. Reboot to embrace the glow up!"
}

# ──────────────────────────────────────────────────────────────
# Complete installation (all-in-one)
# ──────────────────────────────────────────────────────────────
complete_install() {
    install_deps
    install_fonts
    copy_theme
    configure_sddm
    select_variant
    setup_avatar
    enable_sddm
    
    if command -v gum &>/dev/null; then
        gum style \
            --foreground 212 --border-foreground 118 \
            --border double --align center --width 60 \
            --margin "1 2" --padding "1 2" \
            "🎉 INSTALLATION COMPLETE! 🎉" "Reboot to enjoy your new cinematic login screen."
    else
        echo -e "\n\e[1;38;5;118m🎉 INSTALLATION COMPLETE! Reboot to enjoy your new login screen. 🎉\e[0m\n"
    fi

    echo
    if confirm "Would you like to preview your new premium login screen right now?"; then
        preview_theme
    fi
}

# ──────────────────────────────────────────────────────────────
# Main interactive menu
# ──────────────────────────────────────────────────────────────
main() {
    [[ $EUID -eq 0 ]] && { error "Hold up! Do not run as root. The script elevates with sudo internally."; exit 1; }

    check_gum

    while true; do
        title

        local choice; choice=$(choose \
            "─────────── QUICK ACTIONS ───────────" \
            "🚀  Complete Installation (1-Click Magic)" \
            "──────────── THEME SETUP ────────────" \
            "🎨  Select Theme Variant" \
            "👁️   Preview Any Theme" \
            "✨  Preview Selected Theme" \
            "🖼️   Setup User Avatar (info)" \
            "────────── ADVANCED TOOLS ───────────" \
            "📦  Install Dependencies" \
            "🔤  Install Fonts" \
            "📂  Copy Theme Files to SDDM" \
            "⚙️   Apply SDDM Configuration" \
            "🔧  Enable SDDM System Service" \
            "─────────────────────────────────────" \
            "❌  Exit Installer")

        case "$choice" in
            "🚀  Complete Installation (1-Click Magic)") complete_install; exit 0 ;;
            "🎨  Select Theme Variant")  select_variant ;;
            "👁️   Preview Any Theme")    preview_any_theme ;;
            "✨  Preview Selected Theme") preview_theme ;;
            "🖼️   Setup User Avatar (info)") setup_avatar ;;
            "📦  Install Dependencies")  install_deps ;;
            "🔤  Install Fonts")         install_fonts ;;
            "📂  Copy Theme Files to SDDM")   copy_theme ;;
            "⚙️   Apply SDDM Configuration")       configure_sddm ;;
            "🔧  Enable SDDM System Service")   enable_sddm ;;
            "❌  Exit Installer") 
                if command -v gum &>/dev/null; then
                    gum style --foreground 212 --margin "1 2" "🌸 さようなら (Sayōnara) ! 🌸"
                else
                    echo -e "\n\e[38;5;212m🌸 さようなら (Sayōnara) ! 🌸\e[0m\n"
                fi
                exit 0 
                ;;
            *) continue ;;
        esac

        echo
        command -v gum &>/dev/null &&
            gum input --placeholder "Press Enter to return to menu..." ||
            { echo -n "Press Enter to return to menu..."; read -r; }
    done
}

main "$@"
