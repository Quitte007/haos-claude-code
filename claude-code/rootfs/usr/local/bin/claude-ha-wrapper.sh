#!/bin/bash
# Wrapper that sets up HA context before launching Claude Code

export HOME=/root
export TERM=xterm-256color

# HA Supervisor token is injected automatically as SUPERVISOR_TOKEN
# Use it for HA API calls
if [ -n "${SUPERVISOR_TOKEN}" ]; then
    export HA_TOKEN="${SUPERVISOR_TOKEN}"
fi

# Set working directory to HA config
cd /homeassistant || cd /config || cd /root

# Show welcome message
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║           Claude Code — Home Assistant Edition               ║
║                                                              ║
║  /homeassistant  → your HA config (automations, etc.)       ║
║  /share          → shared storage                            ║
║  curl http://supervisor/...  → Supervisor API                ║
╚══════════════════════════════════════════════════════════════╝

EOF

exec claude --dangerously-skip-permissions
