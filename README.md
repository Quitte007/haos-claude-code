# Claude Code Add-ons — Home Assistant Addon-Repository

![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Addon-blue)

## Add-ons in diesem Repository

| Addon | Beschreibung |
|-------|-------------|
| **Claude Code CLI** | Claude Code AI-Assistent direkt in HA — Terminal im Browser |
| **AirConnect** | AirPlay-Bridge für Chromecast- & UPnP/Sonos-Geräte ([Doku](airconnect/DOCS.md)) |

---

# Claude Code — Home Assistant Addon

Claude Code CLI als Addon direkt in Home Assistant — KI-gestütztes Konfigurieren und Troubleshooten deines HAOS, direkt im Browser, ohne externen PC.

---

## Was kann das Addon?

- **Terminal im Browser** — Claude Code läuft direkt in HA, kein SSH, kein extra Tool
- **Vollzugriff auf `/config`** — Claude liest und schreibt deine Automationen, Skripte, configuration.yaml etc.
- **Supervisor API** — Addons neu starten, HA-Version abfragen, Logs lesen — alles per KI
- **REST API** — live Entity-States abfragen, Services aufrufen
- **Persistente Sessions via tmux** — Tab schließen, Claude arbeitet weiter im Hintergrund
- **Mehrere parallele Sessions** — z.B. "main" für Alltag, "debug" für Fehlersuche
- **Pro/Max Abo** — keine API-Kosten, läuft auf deinem Claude-Abonnement
- **Memory überlebt Updates** — deine persönlichen Notizen und Claude's Gedächtnis werden nie überschrieben

---

## Voraussetzungen

- Home Assistant OS (HAOS) oder Home Assistant Supervised
- **Nicht kompatibel** mit HA Container oder HA Core (kein Addon-Store)
- Claude Pro oder Claude Max Abonnement (claude.ai)

---

## Installation

### Schritt 1 — Repository hinzufügen

1. In HA: **Einstellungen → Apps** (früher: Add-ons)
2. Oben rechts: **⋮ → Repositories**
3. Diese URL eintragen und auf **Hinzufügen** klicken:
   ```
   https://github.com/Quitte007/haos-claude-code
   ```
4. **Schließen** → Seite neu laden (F5)

### Schritt 2 — Addon installieren

1. Ganz unten im App-Store erscheint die Gruppe **"Claude Code Add-ons"**
2. **Claude Code CLI** anklicken → **Installieren**
3. Der erste Build dauert 3–5 Minuten (Node.js + Claude Code werden im Container gebaut)

### Schritt 3 — Konfigurieren

Im Tab **Konfiguration** (alles optional, Defaults funktionieren):

| Option | Beschreibung | Standard |
|--------|-------------|---------|
| `claude_model` | Modell — `claude-sonnet-4-6` oder `claude-opus-4-8` | `claude-sonnet-4-6` |
| `ha_url` | HA-URL für interne API-Calls | `http://homeassistant:8123` |
| `anthropic_api_key` | **Nur ausfüllen wenn du API-Credits statt Abo nutzen willst.** Sonst leer lassen! | _(leer)_ |

### Schritt 4 — Starten & einloggen

1. Tab **Info** → **Starten**
2. Optional: **"In Seitenleiste anzeigen"** aktivieren → Claude erscheint dauerhaft links in HA
3. **"Web-Oberfläche öffnen"** klicken
4. Im Terminal erscheint der Session-Picker (siehe tmux-Abschnitt weiter unten)
5. Enter drücken (Default-Session "main")
6. Claude startet — beim ersten Mal erscheint der Login-Hinweis:
   ```
   /login
   ```
7. **"Claude account (Pro/Max subscription)"** wählen
8. Den angezeigten Link im Browser öffnen → bei Anthropic einloggen → autorisieren
9. Fertig — Login ist dauerhaft gespeichert, auch nach Neustarts

---

## tmux — persistente & parallele Sessions

Das Addon nutzt **tmux** als Session-Manager. Das löst ein fundamentales Problem:

**Ohne tmux:**
```
Tab öffnen → Claude startet
Tab schließen → Claude stirbt → Aufgabe weg
```

**Mit tmux:**
```
Tab öffnen → tmux-Session startet (oder reconnect zur laufenden)
Tab schließen → Session läuft unsichtbar weiter
Tab wieder öffnen → du siehst genau wo Claude aufgehört hat
```

### Session-Picker beim Öffnen

Jedes Mal wenn du das Web-Terminal öffnest, erscheint:

```
Running tmux sessions:
  • claude-ha-main   (idle, running 2h ago)
  • claude-ha-debug  (attached, running 10min ago)

Session name [main] (Enter für default):
```

| Eingabe | Was passiert |
|---------|-------------|
| **Enter** (leer) | Verbindet mit Session "main" — oder erstellt sie neu |
| `debug` eingeben | Verbindet mit Session "debug" — oder erstellt sie neu |
| `analyse` eingeben | Neue Session "analyse" — läuft parallel zu "main" |

Nach 10 Sekunden ohne Eingabe startet automatisch "main".

### Wichtige tmux Shortcuts

| Shortcut | Aktion |
|----------|--------|
| `Ctrl+B` dann `D` | **Detach** — Tab schließbar, Session läuft weiter |
| `Ctrl+B` dann `S` | Alle Sessions anzeigen und wechseln |
| `Ctrl+B` dann `$` | Session umbenennen |
| `Ctrl+B` dann `[` | Scroll-Modus (mit Pfeiltasten scrollen, `Q` zum Beenden) |

---

## Was Claude alles kann

### Konfiguration bearbeiten
```
Erstelle eine Automation die alle Lichter um 23 Uhr ausschaltet
Zeig mir alle Automationen die den Bewegungsmelder im Flur nutzen
Füge einen input_boolean Helper namens "Gästemodus" hinzu
```

### Troubleshooting
```
Warum ist meine Zigbee-Integration auf unavailable?
Schau in die Logs und erkläre mir den letzten Fehler
Prüfe ob meine configuration.yaml Fehler hat
```

### System verwalten
```
Starte das Mosquitto Addon neu
Welche HA-Version läuft gerade?
Mach ein Backup
```

---

## Dateipfade die Claude kennt

| Pfad | Inhalt |
|------|--------|
| `/config/` | Deine gesamte HA-Konfiguration |
| `/config/automations.yaml` | Alle Automationen |
| `/config/configuration.yaml` | Haupt-Konfiguration |
| `/config/home-assistant.log` | Aktuelles Log |
| `/config/home-assistant.log.fault` | Crash-Log (falls vorhanden) |
| `/config/.storage/` | Interne HA-Datenbank (Entity-Registry etc.) |
| `/data/CLAUDE.md` | Claude's HA-Anleitung (persistent, Update-sicher) |
| `/data/.claude/` | Login-Credentials, Memory, Sessions |
| `/share/` | Geteilter Speicher zwischen Addons |

---

## Memory & Updates

Claude's Gedächtnis und deine persönlichen Notizen sind **Update-sicher**:

- **`/data/CLAUDE.md`** — wird beim ersten Start aus dem Template angelegt, danach **nie wieder angefasst**. Du kannst hier eigene Infos zu deinem Setup eintragen (Geräte, Räume, Präferenzen).
- **`/config/CLAUDE.md`** — optionale persönliche Memory-Datei, komplett in deiner Hand
- **`/data/.claude/`** — Login, Auto-Memory von Claude Code — persistent

---

## HAOS Einschränkungen

Das Addon läuft in einem Docker-Container. Folgendes geht **nicht** (HAOS-Design, nicht Addon-Bug):

- USB-Laufwerke oder externe Festplatten mounten
- Pakete auf dem Host-OS installieren
- Host-Systemdateien ändern (absichtlich read-only in HAOS)

Für alles was HA-Konfiguration, Automationen und Addon-Management betrifft reicht der Zugriff vollständig aus.

---

## Lizenz

MIT — mach damit was du willst.
