# Nextcloud Customized

Ein angepasstes Docker-Image auf Basis des offiziellen Nextcloud-Apache-Images. Das Image ergänzt Werkzeuge für Diagnose und SMB-Storage.

## Funktionen

- Basiert auf `nextcloud:35.0.2-apache` (Version wird im `Dockerfile` festgelegt).
- `procps` für Prozessdiagnose, z. B. `ps`.
- `smbclient` für den Zugriff auf SMB/CIFS-Freigaben.
- Veröffentlichung in der GitHub Container Registry (GHCR) über GitHub Actions.

> **Hinweis zu PHP-SMBClient:** Das Paket `smbclient` ist das Kommandozeilenwerkzeug und nicht identisch mit der PHP-Erweiterung `php-smbclient`. Installiere bzw. aktiviere die PHP-Erweiterung nur mit einer Methode, die zur PHP-Version des verwendeten Nextcloud-Images passt. Prüfe nach dem Build mit `php -m | grep -i smbclient`, ob sie geladen ist.

## Image verwenden

Die veröffentlichten Images liegen in der GitHub Container Registry:

```bash
docker pull ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache
```

Der Tag `latest` zeigt auf den zuletzt veröffentlichten Build:

```bash
docker pull ghcr.io/simon-sebold/nextcloud-customized:latest
```

Verwende für reproduzierbare Deployments bevorzugt einen expliziten Versions-Tag statt `latest`.

## Eigenes Image bauen

Im Repository-Verzeichnis:

```bash
docker build -t ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache .
```

Optional lokal testen:

```bash
docker run --rm ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache php -v
docker run --rm ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache smbclient --version
```

## Automatischer Build mit GitHub Actions

Der Workflow baut und veröffentlicht das Image bei einem Push auf den Branch `main`, wenn sich die `Dockerfile` ändert. Er kann außerdem manuell über **Actions → Build and publish Nextcloud image → Run workflow** gestartet werden.

Der Workflow liest die Nextcloud-Version aus der `FROM`-Zeile des Dockerfiles. Für:

```dockerfile
FROM nextcloud:35.0.2-apache
```

werden diese Tags veröffentlicht:

- `ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache`
- `ghcr.io/simon-sebold/nextcloud-customized:latest`

Die GitHub Actions benötigen die Berechtigungen `contents: read` und `packages: write`, die im Workflow konfiguriert sind. Das Paket muss in GHCR öffentlich sein, wenn es ohne Anmeldung heruntergeladen werden soll.

## In Kubernetes / FluxCD verwenden

Beispiel für den Container-Eintrag in einem Deployment:

```yaml
containers:
  - name: nextcloud
    image: ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache
    imagePullPolicy: Always
```

Passe `name`, Namespace und weitere Deployment-Felder an deine Konfiguration an. Pflege die Änderung in den von Flux verwalteten Git-Manifesten, damit sie nicht überschrieben wird.

`imagePullPolicy: Always` veranlasst Kubernetes, beim Start des Containers den Tag in der Registry aufzulösen. Für zuverlässige Rollouts empfiehlt sich dennoch, Images mit unveränderlichen Versions-Tags oder Digest-Pinning zu verwenden, statt einen bereits verwendeten Tag wie `latest` dauerhaft zu überschreiben.

## Prüfen

Prüfe die enthaltenen Werkzeuge:

```bash
docker run --rm ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache smbclient --version
docker run --rm ghcr.io/simon-sebold/nextcloud-customized:35.0.2-apache php -m
```

## Repository

- GitHub: https://github.com/simon-sebold/nextcloud-customized
- Container Registry: https://ghcr.io/simon-sebold/nextcloud-customized

## Lizenz

Für dieses Repository ist hier keine Lizenz festgelegt. Ergänze eine `LICENSE`-Datei, wenn du das Projekt unter einer bestimmten Open-Source-Lizenz veröffentlichen möchtest.
