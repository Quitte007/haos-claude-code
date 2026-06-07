# Home Assistant — Claude Code Addon

Du bist Claude Code, eingebettet als Addon direkt in Home Assistant OS.
Diese Datei wird beim ersten Start angelegt und bei Updates NIE überschrieben.

## Deine Umgebung

- **Arbeitsverzeichnis:** `/config` (= deine gesamte HA-Konfiguration)
- **Addon-Speicher:** `/data` (persistent, nur für dieses Addon)
- **Geteilter Speicher:** `/share`
- **Backups:** `/backup`

## Home Assistant REST API

Der Supervisor-Token ist bereits als Umgebungsvariable verfügbar:

```bash
# Alle Entity-States abrufen
curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/core/api/states | jq '.[].entity_id'

# Einzelne Entity abfragen
curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/core/api/states/light.wohnzimmer

# Service aufrufen (z.B. Licht einschalten)
curl -s -X POST \
     -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"entity_id": "light.wohnzimmer"}' \
     http://supervisor/core/api/services/light/turn_on

# Alle verfügbaren Services anzeigen
curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/core/api/services | jq '.[].domain'
```

## Supervisor API (Addon-Management)

```bash
# Alle Addons auflisten
curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/addons | jq '.data.addons[] | {name, state, slug}'

# Addon neu starten (z.B. Mosquitto)
curl -s -X POST \
     -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/addons/core_mosquitto/restart

# HA Core neu starten
curl -s -X POST \
     -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/core/restart

# System-Logs abrufen
curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/core/logs

# Supervisor-Info (HA-Version etc.)
curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/info | jq '.data'
```

## Wichtige Dateien in /config

```
/config/
├── configuration.yaml      # Haupt-Konfiguration
├── automations.yaml        # Automationen
├── scripts.yaml            # Skripte
├── scenes.yaml             # Szenen
├── home-assistant.log      # Aktuelles Log
├── home-assistant.log.fault # Crash-Log (falls vorhanden!)
└── .storage/               # Interne HA-Datenbank (JSON)
    ├── core.entity_registry
    ├── core.device_registry
    └── lovelace.*          # Dashboard-Konfiguration
```

## Diagnose-Befehle

```bash
# Fehler im aktuellen Log
grep -i "error\|warning\|critical" /config/home-assistant.log | tail -50

# Crash-Log prüfen
[ -f /config/home-assistant.log.fault ] && cat /config/home-assistant.log.fault

# Disk-Belegung
df -h /config /data /share

# HA-Version
curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/core/info | jq '.data.version'
```

## Verhaltensregeln

- Konfigurationsänderungen immer mit `# Claude Code — <Datum>` kommentieren
- Vor Änderungen an `configuration.yaml` eine Kopie anlegen
- Nach YAML-Änderungen: HA Config validieren bevor neu starten
- Automationen in separate Dateien, nie direkt in `configuration.yaml`
- Antworten auf Deutsch, außer der Nutzer wechselt die Sprache

## Config validieren

```bash
curl -s -X POST \
     -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
     http://supervisor/core/check
```
