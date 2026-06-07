# Claude Code — Home Assistant Addon

A Home Assistant addon that runs Claude Code CLI directly in your browser, with full access to your HA configuration.

## Installation

1. In HA: **Settings → Addons → Add-on Store → ⋮ → Repositories**
2. Add: `https://github.com/YOUR_USERNAME/haos-claude-code`
3. Install **Claude Code CLI**
4. Set your `anthropic_api_key` in the addon config
5. Start → Open Web UI

## Repository structure

```
haos-claude-code/
└── claude-code/
    ├── config.yaml       # Addon manifest
    ├── Dockerfile
    ├── build.yaml
    ├── DOCS.md
    └── rootfs/
        ├── etc/services.d/ttyd/
        │   ├── run       # s6 service start script
        │   └── finish
        └── usr/local/bin/
            └── claude-ha-wrapper.sh
```
