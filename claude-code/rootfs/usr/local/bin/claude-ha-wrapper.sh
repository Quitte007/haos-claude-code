#!/bin/bash
# Wrapper that sets up HA context before launching Claude Code

# Credentials persist in /data (HA addon persistent volume) via HOME=/data
export HOME=/data
export TERM=xterm-256color

# HA addons run as root inside an isolated container. Claude Code refuses
# --dangerously-skip-permissions as root unless it knows it's sandboxed.
export IS_SANDBOX=1

mkdir -p /data/.claude

# HA Supervisor token is injected automatically as SUPERVISOR_TOKEN
if [ -n "${SUPERVISOR_TOKEN}" ]; then
    export HA_TOKEN="${SUPERVISOR_TOKEN}"
fi

# Deploy HA API instructions to /data/CLAUDE.md on first run only.
# The "if [ ! -f ]" guard means updates NEVER overwrite this file —
# the user's personal notes and Claude's memory are always preserved.
if [ ! -f /data/CLAUDE.md ]; then
    cp /opt/claude-ha-template.md /data/CLAUDE.md
    echo "[Claude Code Addon] Deployed HA instructions to /data/CLAUDE.md"
fi

# Set working directory to HA config (path differs across HA versions)
cd /homeassistant 2>/dev/null || cd /config 2>/dev/null || cd /data

# Detect whether we're authenticated (subscription login or API key)
LOGGED_IN=0
if [ -f /data/.claude/.credentials.json ] || [ -n "${ANTHROPIC_API_KEY}" ]; then
    LOGGED_IN=1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║           Claude Code — Home Assistant Edition               ║
║                                                              ║
║  /config   → HA config (automations, scripts, etc.)         ║
║  /data     → Addon storage (credentials, memory, CLAUDE.md) ║
║  /share    → shared storage                                  ║
╚══════════════════════════════════════════════════════════════╝
EOF

if [ "${LOGGED_IN}" -eq 0 ]; then
    cat << 'EOF'

  ┌──────────────────────────────────────────────────────────┐
  │  FIRST RUN — you are not logged in yet.                  │
  │                                                          │
  │  Claude will now open. Type:   /login                    │
  │  then choose "Claude account (Pro/Max)" and follow the   │
  │  link. Your login is saved in /data and survives restarts│
  └──────────────────────────────────────────────────────────┘

EOF
fi

# Loop so that if claude exits (e.g. after /login or a crash) the terminal
# restarts it instead of dropping to an empty shell.
while true; do
    claude --dangerously-skip-permissions
    echo ""
    echo "Claude exited. Restarting in 3s... (close the tab to stop)"
    sleep 3
done
