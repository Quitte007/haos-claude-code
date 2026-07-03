# AirConnect — Home Assistant Addon

AirPlay-Bridge auf Basis von [philippe44/AirConnect](https://github.com/philippe44/AirConnect).

Macht Geräte, die kein AirPlay können, als **AirPlay-Speaker** im Netzwerk sichtbar:

- **aircast** — Chromecast-Geräte (Google Nest Hub, Nest Audio, Chromecast, Google Home …)
- **airupnp** — UPnP/DLNA- und Sonos-Geräte

## Wofür?

Hauptanwendungsfall: **Music Assistant AirPlay Sync Groups**. Cast-Geräte tauchen nach dem Start als AirPlay-Player in MA auf und können mit anderen AirPlay-Targets (z.B. shairport-sync auf dem HAOS-Rechner) in einer **synchronen** Lautsprechergruppe spielen — was mit einer Universal Group protokollübergreifend sonst nicht synchron möglich ist.

Details zur Konfiguration: siehe [DOCS.md](DOCS.md) bzw. den Tab „Dokumentation" in HA.
