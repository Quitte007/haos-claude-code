# AirConnect Addon — Dokumentation

## Funktionsweise

Das Addon startet einen oder beide AirConnect-Dienste:

| Dienst | Brückt | Standard |
|--------|--------|----------|
| `aircast` | Chromecast/Cast-Geräte → AirPlay | aktiviert |
| `airupnp` | UPnP/DLNA/Sonos-Geräte → AirPlay | deaktiviert |

Beide scannen das Netzwerk automatisch und legen für jedes gefundene Gerät einen
virtuellen AirPlay-Speaker an (Gerätename mit `+`-Suffix, z.B. `Nest Hub+`).

Das Addon läuft mit `host_network`, da AirPlay-Discovery (mDNS) und
Cast-/UPnP-Discovery (SSDP) hinter Docker-NAT nicht funktionieren.

## Optionen

| Option | Beschreibung | Standard |
|--------|-------------|----------|
| `enable_aircast` | Cast-Bridge starten | `true` |
| `enable_airupnp` | UPnP/Sonos-Bridge starten | `false` |
| `codec` | Audio-Codec zum Zielgerät: `flc` (FLAC, verlustfrei), `flc:5` (FLAC stärker komprimiert), `mp3`/`mp3:320`, `wav`, `pcm` | `flc` |
| `latency` | Puffer in ms als `rtp:http`, z.B. `1000:2000`. Höher = stabiler, träger. Leer = AirConnect-Default | `1000:2000` |
| `log_level` | `error`, `warn`, `info`, `debug`, `sdebug` | `warn` |
| `extra_args_aircast` | Zusätzliche CLI-Argumente für aircast | _(leer)_ |
| `extra_args_airupnp` | Zusätzliche CLI-Argumente für airupnp | _(leer)_ |

Nützliche `extra_args`-Beispiele (siehe [AirConnect-Doku](https://github.com/philippe44/AirConnect)):

- `-N "%s"` — kein `+`-Suffix am Gerätenamen
- `-b 192.168.178.x` — an bestimmtes Interface binden
- `-m nest,küche` — Geräte per Namensmuster ausschließen

## Einrichtung mit Music Assistant

1. Addon starten, Log prüfen: gefundene Cast-Geräte werden gelistet
2. In Music Assistant den **AirPlay-Provider** aktivieren (falls noch nicht)
3. Die neuen AirPlay-Player (z.B. `Nest Hub+`) erscheinen unter Settings → Players
4. **Sync Group** vom Typ AirPlay anlegen, z.B. `Nest Hub+` + shairport-sync-Player
5. Bei hörbarem Versatz: `latency` erhöhen bzw. in MA den Sync-Offset des Players justieren

## Troubleshooting

- **Keine Geräte gefunden**: Addon und Zielgeräte müssen im selben Subnetz/VLAN sein
  (mDNS/SSDP sind nicht routbar). Ggf. `-b <IP>` in `extra_args` setzen.
- **Abbrüche/Stottern**: `latency` erhöhen (z.B. `2000:5000`) oder Codec auf `mp3` stellen.
- **Doppelte Player nach Neustart**: Cast-Gerät neu starten oder in MA den alten Player deaktivieren.
- **Details im Log**: `log_level: info` oder `debug` setzen.
