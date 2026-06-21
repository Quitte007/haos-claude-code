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

# Deploy tmux config on first run only — same update-safe pattern.
# Enables mouse support, clipboard via OSC 52, scroll buffer, statusbar.
if [ ! -f /data/.tmux.conf ]; then
    cp /opt/tmux.conf /data/.tmux.conf
    echo "[Claude Code Addon] Deployed tmux config to /data/.tmux.conf"
fi
export TMUX_CONFIG=/data/.tmux.conf

# Set working directory to HA config (path differs across HA versions)
cd /homeassistant 2>/dev/null || cd /config 2>/dev/null || cd /data

# Detect whether we're authenticated (subscription login or API key)
LOGGED_IN=0
if [ -f /data/.claude/.credentials.json ] || [ -n "${ANTHROPIC_API_KEY}" ]; then
    LOGGED_IN=1
fi

# ── Banner ────────────────────────────────────────────────────────────────────
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

# ── Session picker ────────────────────────────────────────────────────────────
# Show running sessions so the user can pick one to reattach
EXISTING=$(tmux list-sessions -F "  • #{session_name}  (#{?session_attached,attached,idle}, running #{t:session_activity})" 2>/dev/null)

if [ -n "$EXISTING" ]; then
    echo "Running tmux sessions:"
    echo "$EXISTING"
    echo ""
fi

echo "Session name [main] (Enter for default, new name for new session):"
read -r -t 10 SESSION_INPUT
SESSION_NAME="${SESSION_INPUT:-main}"
# Sanitize: spaces → dashes, lowercase
SESSION_NAME=$(echo "$SESSION_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

echo ""
echo "→ Connecting to session: claude-ha-${SESSION_NAME}"
echo "  (Tab schließen lässt die Session weiterlaufen)"
echo "  (tmux detach: Ctrl+B dann D)"
echo ""

# ── Launch inside tmux ────────────────────────────────────────────────────────
# -A = attach if exists, create if not
# -s = session name
# The inner loop restarts claude if it exits (e.g. after /login)
tmux -f /data/.tmux.conf new-session -A -s "claude-ha-${SESSION_NAME}" \
    "export IS_SANDBOX=1; export HOME=/data; export TERM=xterm-256color; export PATH=/usr/local/bin:/usr/bin:/bin; while true; do
        claude --dangerously-skip-permissions
        echo ''
        echo 'Claude exited. Restarting in 3s... (Ctrl+C to stay in shell)'
        sleep 3
    done"
