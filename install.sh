#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════╗
# ║     Hyprlands SDDM Video Themes — install.sh  v2.5               ║
# ║     Ultra-Premium 35 Cinematic Login Screen Themes                ║
# ║     Enhanced TUI with animated banners, dashboards & galleries    ║
# ╚════════════════════════════════════════════════════════════════════╝
# Supports: Arch, Fedora, Ubuntu/Debian, openSUSE, Void Linux

set -euo pipefail

readonly VERSION="2.5"
readonly THEME_NAME="hyprlands-video-themes"
readonly THEMES_DIR="/usr/share/sddm/themes"
readonly THEME_DST="${THEMES_DIR}/${THEME_NAME}"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly METADATA="${THEME_DST}/metadata.desktop"
readonly DATE=$(date +%s)
readonly LOG="/tmp/${THEME_NAME}_install_${DATE}.log"

# ── Step tracking for progress display ──
TOTAL_STEPS=7
CURRENT_STEP=0
declare -A STEP_STATUS=()

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
    "2b_midnight_bloom"
    "autumn_cat"
    "before_the_road"
    "dragon_bride"
    "landscape_sea_ships"
    "rocks_glow_with_autumn_fire"
    "serenity"
    "shadowblade_wanderer"
    "yae_miko_among_the_sakura"
    "yae_miko_pixel_art2"
    "zi_ling_a_mortals_journey_to_immortality"
    "green_fields_and_peaks"
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
    "🌸  2B Midnight Bloom"
    "🐱  Autumn Cat"
    "🛣️   Before The Road"
    "👰  Dragon Bride"
    "⛵  Sea Ships"
    "🔥  Autumn Fire"
    "🧘  Serenity"
    "🗡️   Shadowblade Wanderer"
    "🦊  Sakura Shrineden"
    "👾  Yae Pixel Art"
    "🐉  Mortal's Journey"
    "⛰️   Green Fields"
)

# ── Farewell quotes ──
readonly -a FAREWELL_QUOTES=(
    "花鳥風月|Kachō Fūgetsu|The beauties of nature"
    "一期一会|Ichigo Ichie|One chance, one encounter"
    "七転び八起き|Nana Korobi Ya Oki|Fall seven, rise eight"
    "物の哀れ|Mono no Aware|The pathos of things"
    "侘寂|Wabi-Sabi|Beauty in imperfection"
    "森林浴|Shinrin-Yoku|Forest bathing"
    "木漏れ日|Komorebi|Sunlight through leaves"
    "生き甲斐|Ikigai|A reason for being"
)

# ══════════════════════════════════════════════════════════════════════
# ANSI Color Palette
# ══════════════════════════════════════════════════════════════════════
C_RESET="\e[0m"
C_BOLD="\e[1m"
C_DIM="\e[2m"
C_PINK="\e[38;5;212m"
C_MAGENTA="\e[38;5;213m"
C_PURPLE="\e[38;5;141m"
C_GREEN="\e[38;5;118m"
C_YELLOW="\e[38;5;220m"
C_RED="\e[38;5;196m"
C_CYAN="\e[38;5;87m"
C_ORANGE="\e[38;5;208m"
C_BLUE="\e[38;5;75m"
C_LAVENDER="\e[38;5;183m"
C_GRAY="\e[38;5;245m"
C_WHITE="\e[38;5;255m"
C_BG_DARK="\e[48;5;234m"
C_BG_RED="\e[48;5;52m"

# ══════════════════════════════════════════════════════════════════════
# Logging helpers — ultra-premium gum-powered with rich plain fallback
# ══════════════════════════════════════════════════════════════════════
HAS_GUM=false
command -v gum &>/dev/null && HAS_GUM=true

info() {
    $HAS_GUM && gum style --foreground 212 "  ✨  $*" ||
    echo -e "  ${C_PINK}✨  $*${C_RESET}"
}
success() {
    $HAS_GUM && gum style --foreground 118 "  ✅  $*" ||
    echo -e "  ${C_GREEN}✅  $*${C_RESET}"
}
warn() {
    $HAS_GUM && gum style --foreground 220 "  ⚡  $*" ||
    echo -e "  ${C_YELLOW}⚡  $*${C_RESET}"
}
error() {
    if $HAS_GUM; then
        gum style \
            --foreground 196 --border-foreground 196 \
            --border rounded --align left --width 60 \
            --margin "0 2" --padding "0 1" \
            "💀  ERROR: $*" "" "💡 Check the log at: $LOG" >&2
    else
        echo -e "\n  ${C_BG_RED}${C_RED}${C_BOLD} 💀  ERROR ${C_RESET}" >&2
        echo -e "  ${C_RED}  $*${C_RESET}" >&2
        echo -e "  ${C_DIM}  💡  Check the log: $LOG${C_RESET}\n" >&2
    fi
}

# ══════════════════════════════════════════════════════════════════════
# ASCII Art Banner — the crown jewel
# ══════════════════════════════════════════════════════════════════════
show_banner() {
    clear
    local banner
    read -r -d '' banner << 'BANNER' || true

     ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ ███████╗
    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗██╔════╝
    ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║███████╗
    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║╚════██║
    ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝███████║
    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
BANNER

    if $HAS_GUM; then
        echo ""
        gum style \
            --foreground 212 --border-foreground 87 \
            --border double --align center --width 80 \
            --margin "0 2" --padding "0 0" \
            "$banner"
        gum style \
            --foreground 220 --align center --width 80 \
            --margin "0 2" \
            "⚡  S D D M   V I D E O   T H E M E S  ⚡" \
            "" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "  35 Cinematic Looping Backgrounds  •  v${VERSION}" \
            "  Designed for perfection. Built for r/unixporn." \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    else
        echo ""
        echo -e "${C_CYAN}${C_BOLD}${banner}${C_RESET}"
        echo ""
        echo -e "  ${C_YELLOW}${C_BOLD}⚡  S D D M   V I D E O   T H E M E S  ⚡${C_RESET}"
        echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
        echo -e "  ${C_PINK}  35 Cinematic Looping Backgrounds  •  v${VERSION}${C_RESET}"
        echo -e "  ${C_GRAY}  Designed for perfection. Built for r/unixporn.${C_RESET}"
        echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    fi
    echo ""
}

# ══════════════════════════════════════════════════════════════════════
# System Info Dashboard
# ══════════════════════════════════════════════════════════════════════
show_system_info() {
    local pm; pm=$(detect_pm)
    local sddm_ver="not installed"
    command -v sddm &>/dev/null && sddm_ver=$(sddm --version 2>/dev/null | head -1 || echo "unknown")
    
    local qt_ver="not found"
    if command -v qmake6 &>/dev/null; then
        qt_ver=$(qmake6 --version 2>/dev/null | grep -oP 'Qt version \K[\d.]+' || echo "unknown")
    elif command -v qmake &>/dev/null; then
        qt_ver=$(qmake --version 2>/dev/null | grep -oP 'Qt version \K[\d.]+' || echo "unknown")
    fi

    local active_theme="none"
    [[ -f "$METADATA" ]] && active_theme=$(sed -n 's|^ConfigFile=Themes/\(.*\)\.conf|\1|p' "$METADATA" 2>/dev/null || echo "none")

    local disk_free
    disk_free=$(df -h /usr/share 2>/dev/null | awk 'NR==2 {print $4}' || echo "??")

    local distro="Unknown"
    [[ -f /etc/os-release ]] && distro=$(. /etc/os-release && echo "${PRETTY_NAME:-$NAME}")

    if $HAS_GUM; then
        gum style \
            --foreground 208 --border-foreground 196 \
            --border double --align left --width 60 \
            --margin "0 3" --padding "0 2" \
            "  🔥  SYSTEM DASHBOARD  🔥" \
            "" \
            "  🐧  Distro           │  $distro" \
            "  📦  Package Manager  │  $pm" \
            "  🔹  SDDM Version     │  $sddm_ver" \
            "  💠  Qt Version       │  $qt_ver" \
            "  🎨  Active Theme     │  $active_theme" \
            "  💾  Free Space (/usr)│  $disk_free" \
            ""
    else
        echo -e "  ${C_BG_DARK}${C_ORANGE}${C_BOLD}  🔥  SYSTEM DASHBOARD  🔥                             ${C_RESET}"
        echo -e "  ${C_BG_DARK}                                                  ${C_RESET}"
        echo -e "  ${C_BG_DARK}  ${C_WHITE}  🐧  Distro           ${C_DIM}│${C_YELLOW}  $distro  ${C_RESET}"
        echo -e "  ${C_BG_DARK}  ${C_WHITE}  📦  Package Manager  ${C_DIM}│${C_YELLOW}  $pm  ${C_RESET}"
        echo -e "  ${C_BG_DARK}  ${C_WHITE}  🔹  SDDM Version     ${C_DIM}│${C_YELLOW}  $sddm_ver  ${C_RESET}"
        echo -e "  ${C_BG_DARK}  ${C_WHITE}  💠  Qt Version       ${C_DIM}│${C_YELLOW}  $qt_ver  ${C_RESET}"
        echo -e "  ${C_BG_DARK}  ${C_WHITE}  🎨  Active Theme     ${C_DIM}│${C_YELLOW}  $active_theme  ${C_RESET}"
        echo -e "  ${C_BG_DARK}  ${C_WHITE}  💾  Free Space (/usr) ${C_DIM}│${C_YELLOW}  $disk_free  ${C_RESET}"
        echo -e "  ${C_BG_DARK}                                                  ${C_RESET}"
    fi
    echo ""
}

# ══════════════════════════════════════════════════════════════════════
# Progress Bar
# ══════════════════════════════════════════════════════════════════════
progress_bar() {
    local step=$1 total=$2 label=$3
    local pct=$(( step * 100 / total ))
    local filled=$(( pct / 4 ))
    local empty=$(( 25 - filled ))
    local bar=""

    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done

    if $HAS_GUM; then
        gum style --foreground 212 --margin "0 3" \
            "  [$bar] ${pct}%  ─  Step $step/$total  ─  $label"
    else
        echo -e "\n  ${C_PINK}  [${C_MAGENTA}${bar}${C_PINK}] ${pct}%  ${C_DIM}─${C_RESET}  ${C_LAVENDER}Step $step/$total${C_RESET}  ${C_DIM}─${C_RESET}  ${C_WHITE}$label${C_RESET}\n"
    fi
}

step_start() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    progress_bar "$CURRENT_STEP" "$TOTAL_STEPS" "$1"
}

step_done() {
    STEP_STATUS["$1"]="✅"
}

step_fail() {
    STEP_STATUS["$1"]="❌"
}

# ══════════════════════════════════════════════════════════════════════
# Theme Color Swatch — reads colors from .conf files
# ══════════════════════════════════════════════════════════════════════
hex_to_ansi() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    printf "\e[48;2;%d;%d;%dm" "$r" "$g" "$b"
}

show_theme_card() {
    local variant="$1"
    local conf_file="${SCRIPT_DIR}/Themes/${variant}.conf"
    [[ ! -f "$conf_file" ]] && conf_file="${THEME_DST}/Themes/${variant}.conf"
    [[ ! -f "$conf_file" ]] && return

    local accent bg form login_bg position font header
    accent=$(sed -n 's/^AccentParticleColor="\(.*\)"/\1/p' "$conf_file" 2>/dev/null || echo "#ffffff")
    bg=$(sed -n 's/^FormBackgroundColor="\(.*\)"/\1/p' "$conf_file" 2>/dev/null || echo "#1a1a1a")
    form=$(sed -n 's/^LoginButtonBackgroundColor="\(.*\)"/\1/p' "$conf_file" 2>/dev/null || echo "#ffffff")
    login_bg=$(sed -n 's/^LoginFieldBackgroundColor="\(.*\)"/\1/p' "$conf_file" 2>/dev/null || echo "#2a2a2a")
    position=$(sed -n 's/^FormPosition="\(.*\)"/\1/p' "$conf_file" 2>/dev/null || echo "center")
    font=$(sed -n 's/^Font="\(.*\)"/\1/p' "$conf_file" 2>/dev/null || echo "Default")
    header=$(sed -n 's/^HeaderText="\(.*\)"/\1/p' "$conf_file" 2>/dev/null || echo "$variant")

    local swatch_accent; swatch_accent="$(hex_to_ansi "$accent")      ${C_RESET}"
    local swatch_bg; swatch_bg="$(hex_to_ansi "$bg")      ${C_RESET}"
    local swatch_form; swatch_form="$(hex_to_ansi "$form")      ${C_RESET}"
    local swatch_login; swatch_login="$(hex_to_ansi "$login_bg")      ${C_RESET}"

    local pos_display=""
    case "$position" in
        left)   pos_display="◀─── LEFT" ;;
        right)  pos_display="RIGHT ───▶" ;;
        center) pos_display="──CENTER──" ;;
        *)      pos_display="$position" ;;
    esac

    echo -e "  ${C_DIM}┌─────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "  ${C_DIM}│${C_RESET}  ${C_BOLD}${C_WHITE}${header}${C_RESET}"
    echo -e "  ${C_DIM}│${C_RESET}  ${C_GRAY}Font: ${C_LAVENDER}${font}${C_RESET}    ${C_GRAY}Layout: ${C_CYAN}${pos_display}${C_RESET}"
    echo -e "  ${C_DIM}│${C_RESET}  ${C_GRAY}Palette:${C_RESET}  ${swatch_accent} ${swatch_bg} ${swatch_form} ${swatch_login}"
    echo -e "  ${C_DIM}│${C_RESET}            ${C_DIM}accent  bg      btn     field${C_RESET}"
    echo -e "  ${C_DIM}└─────────────────────────────────────────────────────┘${C_RESET}"
}

# ══════════════════════════════════════════════════════════════════════
# UI Components
# ══════════════════════════════════════════════════════════════════════
confirm() {
    $HAS_GUM && gum confirm --affirmative "Yes" --negative "No" "$1" ||
    { echo -en "  ${C_PURPLE}$1 ${C_DIM}(y/n):${C_RESET} "; read -r r; [[ "$r" =~ ^[Yy]$ ]]; }
}

choose() {
    $HAS_GUM && gum choose \
        --cursor=" ❯ " \
        --cursor.foreground 196 \
        --item.foreground 252 \
        --selected.foreground 208 \
        --header.foreground 220 \
        "$@" ||
    { select opt in "$@"; do [[ -n "$opt" ]] && { echo "$opt"; break; }; done; }
}

spin() {
    local ttl="$1"; shift
    local spinners=("points" "line" "minidot" "jump" "pulse" "globe" "moon" "monkey" "meter" "hamburger")
    local rand_spinner="${spinners[$((RANDOM % ${#spinners[@]}))]}"
    $HAS_GUM && gum spin \
        --spinner "$rand_spinner" \
        --spinner.foreground 196 \
        --title.foreground 208 \
        --title "  $ttl" -- "$@" ||
    { echo -e "  ${C_ORANGE}$ttl${C_RESET}"; "$@"; }
}

section_header() {
    local icon="$1" title="$2"
    if $HAS_GUM; then
        gum style --foreground 220 --bold --margin "0 3" \
            "  $icon  $title"
        gum style --foreground 240 --margin "0 3" \
            "  $(printf '%.0s─' {1..50})"
    else
        echo -e "\n  ${C_YELLOW}${C_BOLD}  $icon  $title${C_RESET}"
        echo -e "  ${C_DIM}  $(printf '%.0s─' {1..50})${C_RESET}"
    fi
}

press_enter() {
    echo ""
    if $HAS_GUM; then
        gum input --placeholder "  ↵  Press Enter to return to menu..." > /dev/null
    else
        echo -en "  ${C_DIM}  ↵  Press Enter to return to menu...${C_RESET}"
        read -r
    fi
}

# ══════════════════════════════════════════════════════════════════════
# Detect package manager
# ══════════════════════════════════════════════════════════════════════
detect_pm() {
    for m in pacman xbps-install dnf zypper apt; do
        command -v "$m" &>/dev/null && { echo "$m"; return; }
    done
    echo "unknown"
}

# ══════════════════════════════════════════════════════════════════════
# Install gum (optional, better TUI)
# ══════════════════════════════════════════════════════════════════════
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
    $HAS_GUM && return
    warn "gum not found — we strongly recommend it for the best installer experience!"
    confirm "Install gum now?" && install_gum && { HAS_GUM=true; success "gum installed!"; } || warn "Continuing with plain UI"
}

# ══════════════════════════════════════════════════════════════════════
# Step 1 — Install dependencies
# ══════════════════════════════════════════════════════════════════════
install_deps() {
    section_header "📦" "INSTALLING DEPENDENCIES"
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

# ══════════════════════════════════════════════════════════════════════
# Step 2 — Install fonts
# ══════════════════════════════════════════════════════════════════════
install_fonts() {
    section_header "🔤" "INSTALLING FONTS"
    local font_dst="/usr/share/fonts/hyprlands-sddm"
    sudo mkdir -p "$font_dst"

    if [[ -d "${SCRIPT_DIR}/Fonts" ]]; then
        spin "Installing bundled fonts..." \
            sudo cp -r "${SCRIPT_DIR}/Fonts/"* "$font_dst/"
        info "Bundled fonts copied."
    fi

    local astro_fonts="$HOME/sddm-astronaut-theme/Fonts"
    if [[ -d "$astro_fonts" ]]; then
        spin "Copying fonts from sddm-astronaut-theme..." \
            sudo cp -r "${astro_fonts}/"* "$font_dst/"
        info "sddm-astronaut-theme fonts copied (includes Electroharmonix)."
    fi

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

# ══════════════════════════════════════════════════════════════════════
# Step 3 — Copy theme to SDDM themes directory
# ══════════════════════════════════════════════════════════════════════
copy_theme() {
    section_header "📂" "COPYING THEME FILES"
    [[ -d "$THEME_DST" ]] && sudo mv "$THEME_DST" "${THEME_DST}_backup_${DATE}"

    sudo mkdir -p "$THEME_DST"
    spin "Copying theme files..." sudo cp -r "${SCRIPT_DIR}/"* "$THEME_DST/"

    local astro_bg="$HOME/sddm-astronaut-theme/Backgrounds"
    if [[ -d "$astro_bg" ]]; then
        sudo ln -sf "$astro_bg" "${THEME_DST}/Backgrounds_astronaut" 2>/dev/null || true
    fi

    sudo chmod -R 755 "$THEME_DST"
    success "Theme installed successfully to $THEME_DST"
}

# ══════════════════════════════════════════════════════════════════════
# Step 4 — Configure SDDM
# ══════════════════════════════════════════════════════════════════════
configure_sddm() {
    section_header "⚙️ " "APPLYING SDDM CONFIGURATION"
    sudo mkdir -p /etc/sddm.conf.d
    printf '[Theme]\nCurrent=%s\n' "$THEME_NAME" | sudo tee /etc/sddm.conf >/dev/null

    printf '[General]\nInputMethod=qtvirtualkeyboard\n' \
        | sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null

    success "SDDM configured. Active theme set to: $THEME_NAME"
}

# ══════════════════════════════════════════════════════════════════════
# Step 5 — Select theme variant (with gallery)
# ══════════════════════════════════════════════════════════════════════
select_variant() {
    [[ ! -f "$METADATA" ]] && { error "Please install the theme main files first (Option 4)."; return 1; }

    section_header "🎨" "THEME GALLERY"
    info "Select your desired masterpiece:"
    echo ""

    local chosen
    if $HAS_GUM; then
        chosen=$(gum filter \
            --placeholder "🔍  Type to search 35 cinematic themes..." \
            --prompt " 🔥 " \
            --indicator "⚡ " \
            --match.foreground 196 \
            --prompt.foreground 208 \
            --cursor-text.foreground 220 \
            --header "  ✨ Choose a legendary theme variant:" \
            --header.foreground 208 \
            --height 20 \
            -- "${THEME_NAMES[@]}")
    else
        chosen=$(choose "${THEME_NAMES[@]}")
    fi

    for i in "${!THEME_NAMES[@]}"; do
        if [[ "${THEME_NAMES[$i]}" == "$chosen" ]]; then
            local variant="${THEME_VARIANTS[$i]}"
            echo ""
            show_theme_card "$variant"
            echo ""
            sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${variant}.conf|" "$METADATA"
            success "Active variant set to → $variant!"
            return
        fi
    done
    warn "Selection unclear; keeping current variant."
}

# ══════════════════════════════════════════════════════════════════════
# Step 6 — Set user avatar (AccountsService)
# ══════════════════════════════════════════════════════════════════════
setup_avatar() {
    section_header "🖼️ " "USER AVATAR SETUP"
    local avatar_dir="/var/lib/AccountsService/icons"
    local avatar_conf="/var/lib/AccountsService/users/${USER}"

    if [[ ! -f "${avatar_dir}/${USER}" ]]; then
        warn "No avatar found for '$USER' at ${avatar_dir}/${USER}"
        info "To set your avatar, simply copy an image to: ${avatar_dir}/${USER}"
        echo -e "  ${C_DIM}  Example: ${C_CYAN}sudo cp ~/my-photo.png ${avatar_dir}/${USER}${C_RESET}"
        return
    fi
    success "Avatar already configured for $USER at ${avatar_dir}/${USER}"
}

# ══════════════════════════════════════════════════════════════════════
# Step 7 — Preview the currently configured theme variant
# ══════════════════════════════════════════════════════════════════════
preview_theme() {
    section_header "✨" "LIVE THEME PREVIEW"
    if ! command -v sddm-greeter-qt6 &>/dev/null; then
        error "sddm-greeter-qt6 not found. Install SDDM with Qt6 first."
        return 1
    fi
    [[ ! -d "$THEME_DST" ]] && { error "Install theme first."; return 1; }

    local variant; variant=$(sed -n 's|^ConfigFile=Themes/\(.*\)\.conf|\1|p' "$METADATA" 2>/dev/null || echo "not set")
    info "Launching preview engine for: $variant"
    echo ""
    show_theme_card "$variant"
    echo ""

    sddm-greeter-qt6 --test-mode --theme "$THEME_DST/" >"$LOG" 2>&1 &
    local pid=$!
    for _ in {1..15}; do kill -0 "$pid" 2>/dev/null || break; sleep 1; done
    kill -0 "$pid" 2>/dev/null && kill "$pid"
    success "Preview closed smoothly. Logs saved at: $LOG"
}

# ══════════════════════════════════════════════════════════════════════
# Preview ANY theme with comparison card
# ══════════════════════════════════════════════════════════════════════
preview_any_theme() {
    section_header "👁️ " "PREVIEW ANY THEME"
    if ! command -v sddm-greeter-qt6 &>/dev/null; then
        error "sddm-greeter-qt6 not found. Install SDDM with Qt6 first."
        return 1
    fi
    [[ ! -d "$THEME_DST" ]] && { error "Install theme files first."; return 1; }

    info "Which theme would you like to preview?"
    echo ""

    local chosen
    if $HAS_GUM; then
        chosen=$(gum filter \
            --placeholder "🔍  Type to search themes..." \
            --prompt "❯ " \
            --indicator "▸" \
            --match.foreground 212 \
            --prompt.foreground 141 \
            --cursor-text.foreground 213 \
            --header "  Choose a theme to preview:" \
            --header.foreground 87 \
            --height 15 \
            -- "${THEME_NAMES[@]}")
    else
        chosen=$(choose "${THEME_NAMES[@]}")
    fi

    local variant=""
    for i in "${!THEME_NAMES[@]}"; do
        if [[ "${THEME_NAMES[$i]}" == "$chosen" ]]; then
            variant="${THEME_VARIANTS[$i]}"
            break
        fi
    done

    [[ -z "$variant" ]] && { warn "Preview canceled."; return 1; }

    # Show comparison card
    local original_variant
    original_variant=$(sed -n 's|^ConfigFile=Themes/\(.*\)\.conf|\1|p' "$METADATA" 2>/dev/null || echo "")

    if [[ -n "$original_variant" && "$original_variant" != "$variant" ]]; then
        echo ""
        echo -e "  ${C_CYAN}${C_BOLD}  ◀  CURRENT THEME${C_RESET}"
        show_theme_card "$original_variant"
        echo ""
        echo -e "  ${C_PINK}${C_BOLD}  ▶  PREVIEW THEME${C_RESET}"
        show_theme_card "$variant"
        echo ""
    else
        echo ""
        show_theme_card "$variant"
        echo ""
    fi

    info "Launching preview for: $variant"

    sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${variant}.conf|" "$METADATA"

    sddm-greeter-qt6 --test-mode --theme "$THEME_DST/" >"$LOG" 2>&1 &
    local pid=$!
    for _ in {1..15}; do kill -0 "$pid" 2>/dev/null || break; sleep 1; done
    kill -0 "$pid" 2>/dev/null && kill "$pid"

    if [[ -n "$original_variant" && "$original_variant" != "$variant" ]]; then
        echo ""
        info "Preview finished. Did you like that theme?"
        if confirm "Keep $variant as the active theme permanently?"; then
            success "Awesome! Active variant is now $variant."
        else
            sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${original_variant}.conf|" "$METADATA"
            info "Reverted to previous active theme: $original_variant"
        fi
    fi
}

# ══════════════════════════════════════════════════════════════════════
# Step 8 — Enable SDDM service
# ══════════════════════════════════════════════════════════════════════
enable_sddm() {
    section_header "🔧" "ENABLING SDDM SERVICE"
    command -v systemctl &>/dev/null || { error "systemctl not found. This OS may use another init system."; return 1; }
    sudo systemctl disable display-manager.service 2>/dev/null || true
    sudo systemctl enable sddm.service
    success "SDDM service dynamically enabled. Reboot to embrace the glow up!"
}

# ══════════════════════════════════════════════════════════════════════
# Uninstall Theme
# ══════════════════════════════════════════════════════════════════════
uninstall_theme() {
    section_header "🗑️ " "UNINSTALL THEME"

    if [[ ! -d "$THEME_DST" ]]; then
        warn "Theme is not currently installed at $THEME_DST"
        return 1
    fi

    echo ""
    echo -e "  ${C_RED}${C_BOLD}  ⚠️  This will remove the following:${C_RESET}"
    echo -e "  ${C_DIM}  ├── ${C_WHITE}$THEME_DST${C_RESET}"
    echo -e "  ${C_DIM}  ├── ${C_WHITE}/etc/sddm.conf (theme entry)${C_RESET}"
    echo -e "  ${C_DIM}  └── ${C_WHITE}/etc/sddm.conf.d/virtualkbd.conf${C_RESET}"
    echo ""

    if ! confirm "Are you absolutely sure you want to uninstall?"; then
        info "Uninstall canceled."
        return 0
    fi

    spin "Removing theme files..." sudo rm -rf "$THEME_DST"
    sudo rm -f /etc/sddm.conf.d/virtualkbd.conf

    # Reset SDDM to default
    if [[ -f /etc/sddm.conf ]]; then
        sudo sed -i "s|^Current=${THEME_NAME}|Current=|" /etc/sddm.conf
    fi

    success "Theme has been uninstalled completely."
    info "You may want to set another SDDM theme or display manager."
}

# ══════════════════════════════════════════════════════════════════════
# Post-install Status Report
# ══════════════════════════════════════════════════════════════════════
show_report() {
    local active_variant="none"
    [[ -f "$METADATA" ]] && active_variant=$(sed -n 's|^ConfigFile=Themes/\(.*\)\.conf|\1|p' "$METADATA" 2>/dev/null || echo "none")

    local sddm_svc="inactive"
    command -v systemctl &>/dev/null && systemctl is-enabled sddm.service &>/dev/null && sddm_svc="✅ enabled"

    echo ""
    if $HAS_GUM; then
        gum style \
            --foreground 118 --border-foreground 118 \
            --border double --align center --width 60 \
            --margin "0 3" --padding "1 2" \
            "🎉  INSTALLATION COMPLETE  🎉" "" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "" \
            "  🎨  Active Theme    →  $active_variant" \
            "  🔧  SDDM Service    →  $sddm_svc" \
            "  📂  Installed to    →  $THEME_DST" \
            "  📝  Install Log     →  $LOG" "" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "" \
            "Step Results:" \
            "  ${STEP_STATUS[deps]:-⏭️ }  Dependencies" \
            "  ${STEP_STATUS[fonts]:-⏭️ }  Fonts" \
            "  ${STEP_STATUS[copy]:-⏭️ }  Theme Files" \
            "  ${STEP_STATUS[config]:-⏭️ }  SDDM Config" \
            "  ${STEP_STATUS[variant]:-⏭️ }  Theme Variant" \
            "  ${STEP_STATUS[avatar]:-⏭️ }  User Avatar" \
            "  ${STEP_STATUS[service]:-⏭️ }  SDDM Service" "" \
            "Reboot to enjoy your cinematic login! 🚀"
    else
        echo -e "  ${C_GREEN}${C_BOLD}╔══════════════════════════════════════════════════════╗${C_RESET}"
        echo -e "  ${C_GREEN}${C_BOLD}║         🎉  INSTALLATION COMPLETE  🎉               ║${C_RESET}"
        echo -e "  ${C_GREEN}${C_BOLD}╠══════════════════════════════════════════════════════╣${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}                                                      ${C_GREEN}║${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}  🎨  Active Theme    ${C_DIM}→${C_RESET}  ${C_PINK}$active_variant${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}  🔧  SDDM Service    ${C_DIM}→${C_RESET}  ${C_CYAN}$sddm_svc${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}  📂  Installed to    ${C_DIM}→${C_RESET}  ${C_WHITE}$THEME_DST${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}  📝  Install Log     ${C_DIM}→${C_RESET}  ${C_DIM}$LOG${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}                                                      ${C_GREEN}║${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}  ${C_BOLD}Step Results:${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}    ${STEP_STATUS[deps]:-⏭️ }  Dependencies"
        echo -e "  ${C_GREEN}║${C_RESET}    ${STEP_STATUS[fonts]:-⏭️ }  Fonts"
        echo -e "  ${C_GREEN}║${C_RESET}    ${STEP_STATUS[copy]:-⏭️ }  Theme Files"
        echo -e "  ${C_GREEN}║${C_RESET}    ${STEP_STATUS[config]:-⏭️ }  SDDM Config"
        echo -e "  ${C_GREEN}║${C_RESET}    ${STEP_STATUS[variant]:-⏭️ }  Theme Variant"
        echo -e "  ${C_GREEN}║${C_RESET}    ${STEP_STATUS[avatar]:-⏭️ }  User Avatar"
        echo -e "  ${C_GREEN}║${C_RESET}    ${STEP_STATUS[service]:-⏭️ }  SDDM Service"
        echo -e "  ${C_GREEN}║${C_RESET}                                                      ${C_GREEN}║${C_RESET}"
        echo -e "  ${C_GREEN}║${C_RESET}  ${C_LAVENDER}Reboot to enjoy your cinematic login! 🚀${C_RESET}"
        echo -e "  ${C_GREEN}${C_BOLD}╚══════════════════════════════════════════════════════╝${C_RESET}"
    fi
    echo ""

    # Show the active theme card
    if [[ "$active_variant" != "none" ]]; then
        show_theme_card "$active_variant"
    fi
}

# ══════════════════════════════════════════════════════════════════════
# Complete installation (all-in-one) with progress tracking
# ══════════════════════════════════════════════════════════════════════
complete_install() {
    CURRENT_STEP=0

    step_start "Installing dependencies"
    if install_deps; then step_done "deps"; else step_fail "deps"; fi

    step_start "Installing fonts"
    if install_fonts; then step_done "fonts"; else step_fail "fonts"; fi

    step_start "Copying theme files"
    if copy_theme; then step_done "copy"; else step_fail "copy"; fi

    step_start "Applying SDDM configuration"
    if configure_sddm; then step_done "config"; else step_fail "config"; fi

    step_start "Selecting theme variant"
    if select_variant; then step_done "variant"; else step_fail "variant"; fi

    step_start "Setting up user avatar"
    if setup_avatar; then step_done "avatar"; else step_fail "avatar"; fi

    step_start "Enabling SDDM service"
    if enable_sddm; then step_done "service"; else step_fail "service"; fi

    show_report

    echo ""
    if confirm "Would you like to preview your new premium login screen right now?"; then
        preview_theme
    fi
}

# ══════════════════════════════════════════════════════════════════════
# Farewell animation
# ══════════════════════════════════════════════════════════════════════
show_farewell() {
    local idx=$(( RANDOM % ${#FAREWELL_QUOTES[@]} ))
    local entry="${FAREWELL_QUOTES[$idx]}"
    local kanji romaji english
    IFS='|' read -r kanji romaji english <<< "$entry"

    echo ""
    if $HAS_GUM; then
        gum style \
            --foreground 212 --border-foreground 141 \
            --border rounded --align center --width 50 \
            --margin "0 3" --padding "1 2" \
            "🌸  さようなら  🌸" \
            "" \
            "  $kanji" \
            "  $romaji" \
            "  « $english »" \
            "" \
            "Thank you for choosing Hyprlands."
    else
        echo -e "  ${C_DIM}  ╭────────────────────────────────────────╮${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}                                        ${C_DIM}│${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}      ${C_PINK}${C_BOLD}🌸  さようなら  🌸${C_RESET}              ${C_DIM}│${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}                                        ${C_DIM}│${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}        ${C_WHITE}${C_BOLD}$kanji${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}        ${C_LAVENDER}$romaji${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}        ${C_DIM}« $english »${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}                                        ${C_DIM}│${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}  ${C_GRAY}Thank you for choosing Hyprlands.${C_RESET}    ${C_DIM}│${C_RESET}"
        echo -e "  ${C_DIM}  │${C_RESET}                                        ${C_DIM}│${C_RESET}"
        echo -e "  ${C_DIM}  ╰────────────────────────────────────────╯${C_RESET}"
    fi
    echo ""
}

# ══════════════════════════════════════════════════════════════════════
# Browse all themes (gallery view)
# ══════════════════════════════════════════════════════════════════════
browse_gallery() {
    section_header "🖼️ " "FULL THEME GALLERY"
    echo ""
    for i in "${!THEME_VARIANTS[@]}"; do
        echo -e "  ${C_BOLD}${C_PINK}#$((i+1))${C_RESET}  ${THEME_NAMES[$i]}"
        show_theme_card "${THEME_VARIANTS[$i]}"
        echo ""
    done
}

# ══════════════════════════════════════════════════════════════════════
# Main interactive menu — redesigned with sections
# ══════════════════════════════════════════════════════════════════════
main() {
    [[ $EUID -eq 0 ]] && { error "Hold up! Do not run as root. The script elevates with sudo internally."; exit 1; }

    check_gum

    while true; do
        show_banner
        show_system_info

        local choice; choice=$(choose \
            "┈┈┈┈┈┈┈┈┈┈ ⚡ QUICK ACTIONS ⚡ ┈┈┈┈┈┈┈┈┈┈" \
            "🚀  Complete Installation  (1-Click Magic)" \
            "┈┈┈┈┈┈┈┈┈┈ 🎨 THEME SETUP 🎨 ┈┈┈┈┈┈┈┈┈┈" \
            "🎨  Select Theme Variant" \
            "👁️   Preview Any Theme  (with comparison)" \
            "✨  Preview Active Theme" \
            "🖼️   Browse Full Gallery  (all 35 themes)" \
            "👤  Setup User Avatar" \
            "┈┈┈┈┈┈┈┈┈ 🔧 ADVANCED TOOLS 🔧 ┈┈┈┈┈┈┈┈┈" \
            "📦  Install Dependencies" \
            "🔤  Install Fonts" \
            "📂  Copy Theme Files to SDDM" \
            "⚙️   Apply SDDM Configuration" \
            "🔧  Enable SDDM System Service" \
            "🗑️   Uninstall Theme" \
            "┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈" \
            "❌  Exit Installer")

        case "$choice" in
            *"Complete Installation"*)   complete_install; exit 0 ;;
            *"Select Theme Variant"*)    select_variant ;;
            *"Preview Any Theme"*)       preview_any_theme ;;
            *"Preview Active Theme"*)    preview_theme ;;
            *"Browse Full Gallery"*)     browse_gallery ;;
            *"Setup User Avatar"*)       setup_avatar ;;
            *"Install Dependencies"*)    install_deps ;;
            *"Install Fonts"*)           install_fonts ;;
            *"Copy Theme Files"*)        copy_theme ;;
            *"Apply SDDM"*)             configure_sddm ;;
            *"Enable SDDM"*)            enable_sddm ;;
            *"Uninstall Theme"*)         uninstall_theme ;;
            *"Exit"*)
                show_farewell
                exit 0
                ;;
            *) continue ;;
        esac

        press_enter
    done
}

main "$@"
