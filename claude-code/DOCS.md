# Claude Code for Home Assistant

## Setup

1. Add this repository to your HA addon store
2. Install the addon
3. Start the addon
4. Open the Web UI via the sidebar panel
5. On first run, type `/login` and sign in with your Claude Pro/Max account

Your login is stored in `/data` (the addon's persistent volume) and survives
restarts, updates, and reboots — you only log in once.

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `claude_model` | Claude model to use | `claude-sonnet-4-6` |
| `ha_url` | Home Assistant URL for API calls | `http://homeassistant:8123` |
| `anthropic_api_key` | **Optional.** Set this only if you want to bill an API key instead of your Pro/Max subscription. Leave empty to use subscription login. | _(empty)_ |

## Login (subscription)

The addon defaults to your **Claude Pro/Max subscription** — no API costs.
On first start the terminal tells you to run `/login`; pick the
"Claude account" option and open the printed link in your browser.

## What Claude can access

- **`/homeassistant`** — your full HA config directory (automations, scripts, integrations, etc.) — read/write
- **`/share`** — shared storage — read/write  
- **`/ssl`** — SSL certificates — read only
- **Supervisor API** — manage addons, restart HA, check logs — via `http://supervisor/`
- **HA REST API** — query states, call services — via the injected token

## What Claude CANNOT do (HAOS limits)

- Mount USB drives or external storage directly
- Install packages on the host OS
- Modify host system files (intentionally read-only in HAOS)

These are HAOS design constraints, not addon limitations. For disk mounting use the HA UI or a dedicated addon.

## Example prompts

- "Show me all automations that trigger at sunrise"
- "Create an automation that turns off all lights at midnight"
- "Why is my Zigbee integration showing unavailable?"
- "Add a new input_boolean helper called 'guest_mode'"
- "Restart the Mosquitto addon"

## Security

The addon requires `hassio_role: manager` to control addons via the Supervisor API.  
Your API key is stored encrypted in the addon configuration.  
The web terminal is only accessible within your HA network (no external exposure).
