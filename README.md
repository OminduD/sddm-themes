<div align="center">
  <img src="https://raw.githubusercontent.com/Keyitdev/sddm-astronaut-theme/master/Fonts/astronaut.svg" width="100" height="100" alt="Logo" style="display:none;"/>
  <h1>🌌 Hyprlands Video Themes 🌌</h1>
  
  <p><b>A highly customizable, cinematic SDDM theme collection featuring 23 unique video backgrounds.</b></p>
  
  <p>
    <img alt="Platform" src="https://img.shields.io/badge/Platform-Linux-blue?style=for-the-badge&logo=linux"/>
    <img alt="License" src="https://img.shields.io/badge/License-GPLv3-green?style=for-the-badge"/>
    <img alt="SDDM" src="https://img.shields.io/badge/SDDM-Theme-ff69b4?style=for-the-badge&logo=kde"/>
  </p>
</div>

<br/>

<div align="center">
  <i>Elevate your login screen with dynamic, minimal, and premium aesthetic visuals.</i>
</div>

---

## ✨ Key Features

- **🎬 23 Looping Video Backgrounds:** Immersive and high-quality visuals right from the login screen.
- **🛠️ Fully Interactive Installer:** A built-in TUI script (`install.sh`) handles everything—from resolving dependencies to live-previewing themes.
- **🎨 Dynamic QML UI:** Modular components allowing left, right, or center visual alignments based on your preferred configuration.
- **👤 Modern Avatars:** Profile picture support with an animated, glowing fallback ring.
- **🖥️ Multi-Session Support:** Dropdown for Window Managers (Hyprland, Sway) or Desktop Environments (KDE, GNOME).
- **⌨️ Virtual Keyboard Support:** Built-in toggle for touch-friendly virtual keyboard inputs.

---

## 🎭 The Themes Collection

Choose from a massive curated list of 23 unique visual variants, ranging from Cyberpunk aesthetics to serene Japanese landscapes:

<table>
  <tr>
    <td>🐉 <b>Blind Dragon</b></td>
    <td>👦🐉 <b>Boy and Dragon</b></td>
    <td>☁️🏰 <b>Cloud Castle</b></td>
  </tr>
  <tr>
    <td>🌙 <b>Crimson Moon</b></td>
    <td>🚶‍♂️🌅 <b>Dawn Wanderer</b></td>
    <td>🤖 <b>Digital Shadows</b></td>
  </tr>
  <tr>
    <td>👁️‍🗨️🐉 <b>Dragon's Gaze</b></td>
    <td>👧 <b>Evelyn</b></td>
    <td>🚗🌃 <b>Evening Drive</b></td>
  </tr>
  <tr>
    <td>🪈 <b>Fantasy Flute</b></td>
    <td>🌤️ <b>Golden Hour</b></td>
    <td>🌸 <b>Japanese Spring</b></td>
  </tr>
  <tr>
    <td>🏔️ <b>Majestic Peaks</b></td>
    <td>🌊🌕 <b>Moonlight Seascape</b></td>
    <td>⛰️🌅 <b>Mountain Horizon</b></td>
  </tr>
  <tr>
    <td>🌌 <b>Nebula Black Hole</b></td>
    <td>🗡️ <b>Samurai Spirit</b></td>
    <td>🌳 <b>Samurai Tree</b></td>
  </tr>
  <tr>
    <td>🚂🌇 <b>Sunset Train</b></td>
    <td>🎭 <b>Torn Mask</b></td>
    <td>🏞️ <b>Tranquil Lake</b></td>
  </tr>
  <tr>
    <td>🌸🌳 <b>Under Cherry Tree</b></td>
    <td>👊💥 <b>Vi and Powder</b></td>
    <td></td>
  </tr>
</table>

---

## 🚀 Installation & Usage

> **Note:** Root privileges are required to copy themes into your system's SDDM directory (`/usr/share/sddm/themes/`).

1. **Clone the repository:**
   ```bash
   git clone https://github.com/omindu/sddm-themes.git
   cd sddm-themes
   ```

2. **Launch the Installer:**
   ```bash
   sudo ./install.sh
   ```

3. **Follow Prompt Options:**
   The TUI will guide you through:
   - Installing required dependencies (Qt5 / Qt6 plugins).
   - Selecting your desired visual theme.
   - Adjusting layout positioning (Left, Center, Right).
   - Configuring clock fonts and sizes.
   - Launching a **Live Preview** of your final setup.

---

## ⚙️ Manual Configuration

Once installed, you can modify your theme instantly by editing its `.conf` file located in `/usr/share/sddm/themes/hyprlands-video-themes/Themes/`.

Example settings you can change:
- `FormPosition`: Change login box alignment (`left`, `center`, `right`).
- `Font`: Set a custom font family.
- `BlurRadius`: Adjust background blur intensity.
- `TimeFormat` & `DateFormat`: Personalize how the clock is displayed.

---

## 🙌 Credits & Acknowledgements

A massive shoutout to the open-source Linux community. This project’s architecture, QML logic, and modularity would not have been possible without the brilliant work behind the **SDDM Astronaut Theme**. 

🌟 **Original Inspiration & Codebase Foundation:** [Keyitdev / sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme)

Make sure to check out their repository and drop a star!

---

<div align="center">
  <p>Made with ❤️ for r/unixporn and the ricing community</p>
</div>
