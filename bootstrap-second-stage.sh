#!/data/data/com.AliSystem.secure/files/usr/bin/bash
# Ali Terminal - First Run Setup

HOME_DIR="$HOME"
ALI_DIR="$HOME_DIR/.alisystem"
mkdir -p "$ALI_DIR"

echo "[AliSystem] Setting up your terminal..."

# 1. Colors
mkdir -p "$HOME_DIR/.termux"
cat > "$HOME_DIR/.termux/colors.properties" << 'EOF'
background=#1e222a
foreground=#d8dee9
cursor=#88c0d0
EOF

# 2. Termux properties
cat > "$HOME_DIR/.termux/termux.properties" << 'EOF'
extra-keys = []
EOF

# 3. MOTD banner
cat > "$ALI_DIR/motd.sh" << 'MOTDEOF'
#!/data/data/com.AliSystem.secure/files/usr/bin/bash
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
GREY='\033[90m'
RESET='\033[0m'

echo -e "${CYAN}"
cat << 'LOGO'
  ▄▄▄▄   ▄▄     ▄        ▄▄▄▄▄▄▄▄▄                                   ▄▄   
▄██▀▀██▄ ██ ▀▀  ▀        ▀▀▀███▀▀▀                   ▀▀              ██   
███  ███ ██ ██   ▄█▀▀▀      ███ ▄█▀█▄ ████▄ ███▄███▄ ██  ████▄  ▀▀█▄ ██   
███▀▀███ ██ ██   ▀███▄      ███ ██▄█▀ ██ ▀▀ ██ ██ ██ ██  ██ ██ ▄█▀██ ██   
███  ███ ██ ██▄  ▄▄▄█▀      ███ ▀█▄▄▄ ██    ██ ██ ██ ██▄ ██ ██ ▀█▄██ ██   
LOGO
echo -e "${RESET}"

DATE=$(TZ='Asia/Karachi' date "+%A, %d %B %Y")
TIME=$(TZ='Asia/Karachi' date "+%I:%M:%S %p")

echo -e "  ${GREEN}╭──────────────────────────────────────────╮${RESET}"
echo -e "  ${GREEN}│${RESET}  📅 Date : ${YELLOW}$DATE${RESET}"
echo -e "  ${GREEN}│${RESET}  🕐 Time : ${YELLOW}$TIME${RESET}"
echo -e "  ${GREEN}╰──────────────────────────────────────────╯${RESET}"

# Storage
STORAGE=$(df -h /data/data/com.AliSystem.secure/files 2>/dev/null | tail -1 | awk '{print $4}')
[ -n "$STORAGE" ] && echo -e "  💾 Storage : ${GREEN}${STORAGE} free${RESET}"

# RAM
if [ -f /proc/meminfo ]; then
    TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    AVAIL=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    USED=$((TOTAL - AVAIL))
    TOTAL_G=$(awk "BEGIN {printf \"%.1f\", $TOTAL/1048576}")
    USED_G=$(awk "BEGIN {printf \"%.1f\", $USED/1048576}")
    echo -e "  🧠 RAM     : ${GREEN}${USED_G}G / ${TOTAL_G}G${RESET}"
fi

echo -e "  👤 User    : ${MAGENTA}$(whoami)@secure${RESET}"
echo ""
echo -e "  ${YELLOW}⚡ Welcome back, Ali. Let's build something amazing! 🚀${RESET}"
echo -e "  ${GREY}────────────────────────────────────────────${RESET}"
echo ""
MOTDEOF

chmod +x "$ALI_DIR/motd.sh"

# 4. .bashrc with Pakistan timezone
cat > "$HOME_DIR/.bashrc" << 'RCEOF'
# Ali Terminal - Professional Prompt
PS1='\[\033[1;35m\]┌─[\033[1;32m\]ali\[\033[1;35m\]@\[\033[1;36m\]secure\[\033[1;35m\]]─[\033[1;33m\]\w\[\033[1;35m\]]\n\[\033[1;35m\]└──╼ \[\033[1;37m\]\$ \[\033[0m\]'

# Pakistan Time Zone (Islamabad)
export TZ='Asia/Karachi'

alias ls='ls --color=auto'
alias ll='ls -la'
alias ali='cd ~/.alisystem'
alias ali-update='pkg update && pkg upgrade -y'
alias ali-help='cat ~/.alisystem/help.txt 2>/dev/null'

# Custom MOTD
~/.alisystem/motd.sh
RCEOF

# 5. System motd khali karo
touch $PREFIX/etc/motd

# 6. Help file
cat > "$ALI_DIR/help.txt" << 'HELPEOF'
--- Ali Terminal Help ---
ali           -> Go to ali directory
ali-update    -> Update all packages
ali-help      -> Show this help
HELPEOF

echo "[AliSystem] Setup complete. Restarting shell..."
