# Skripte und Konfigurationsdateien für eine Docker-basierte Infrastruktur für JonDos GmbH

Gemäß dem Ansatz "infrastructure as code" wird zum Aufbau der einzelnen Server je ein docker-compose-Script benutzt.

## Allgemein

Jeder der Server nutzt NginX als Reverse Proxy. Dabei kommt das Docker-Image [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) zum Einsatz.

Zuständig für die Zertifikate ist ein eigenes Docker-Image, das als "Companion" für den Reverse Proxy läuft: [jrcs/letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)

## Volumes

### Lokale Volumes

Diese Volumes werden vom NginX-Reverse-Proxy und dem zugehörigen Let's Encrypt-Companion benötigt und müssen auf allen Hosts definiert sein:

| Pfad | Funktion |
|------|----------|
|./vhost.d|Containerspezifische Konfigurationsdateien für den Reverse Proxy|
|/var/run/docker.sock|Notwendig für die Kommunikation zwischen beiden Containern und dem Docker-Host|

### Benannte Volumes

Diese Volumes müssen aus demselben Grund auf allen Containern definiert sein, sind aber für den Host irrelevant und müssen daher nicht auf das lokale Dateisystem zeigen:

| Pfad | Funktion |
|------|----------|
|certs|Zertifikatsspeicher und -austauschverzeichnis für Reverse Proxy und Let's Encrypt-Container|
|conf.d|Persistente Konfiguration für Reverse Proxy (Let's Encrypt-Container benötigt ebenfalls Zugriff)|
|html|Reverse Proxy braucht Zugriff auf SSL-Challenge-Dateien, die der Let's Encrypt-Container hier ablegt|


Siehe auch:
  * _Peter Siering: [Umbauanleitung](https://www.heise.de/select/ct/2017/15/1500578738258740) - Docker-Container für Heim- und Webserver, c't Magazin für Computer und Technik, Ausgabe 15/2017, S. 110_

## backup.anonymous-proxy-servers.net

Für den Backup-Server kommt [jshridha/rdiffweb](https://github.com/jshridha/docker-rdiffweb) zum Einsatz.

### Volumes

#### Lokale Volumes

Der Container erhält 3 Volumes im lokalen Dateisystem:

| Lokaler Pfad | Beschreibung |
|--------------|--------------|
| /root/Backup | Das Verzeichnis, in dem die Backups nach Server abgelegt werden. |
| /root/Restore | Nach einem Restore landen hier die wieder hergestellten Dateien. |
| /root/rdiffweb_files/conf | Das Konfigurationsverzeichnis von rdiffweb |

## Rosenkranz

Der Server "Rosenkranz" ist eine AWS-EC2-Instanz mit dem micro-Profil.
Er behinhaltet folgende Dienste:

| Dienst | Image | URL |
|--------|-------|-----|
|[Redmine](https://www.redmine.org)|[Redmine](https://hub.docker.com/_/redmine/)|https://bugtracker.anonymous-proxy-servers.net|
|[Portainer](https://portainer.io)|[Portainer](https://hub.docker.com/r/portainer/portainer/)|https://monitoring.anonymous-proxy-servers.net/containers|
|[Kimai](https://www.kimai.org)|Eigenes Image basierend auf Ubuntu|https://timetracker.anonymous-proxy-servers.net|
|Etherpad|[Etherpad](https://github.com/ether/etherpad-docker)|https://etherpad.anonymous-proxy-servers.net|
|Icinga2| (in Vorbereitung) | |
|[MySQL](https://www.mysql.com)|[MySQL](https://hub.docker.com/_/mysql/)|(notwendig für Redmine, Kimai und Etherpad)|

Sofern erforderlich, gehört zum jeweiligen Container ein gleichnamiges Verzeichnis, in dem zusätzliche Dateien liegen, z.B. Dockerfiles und zusätzliche Konfigurationsdateien.
Ein weiteres Verzeichnis namens `vhost.d` dient als Volume für den NginX-Container und enthält dienstspezifische Konfigurationsdateien für den Reverse Proxy.

### Volumes

Die folgenden Volumes sind auf diesem Host zusätzlich zu denen unter ["Allgemein"](#Allgemein) zu definieren:

#### Lokale Volumes

| Pfad | Funktion |
|------|----------|
|/home/ubuntu/redmine_files/upload|Attachments in Redmine-Tickets|
|/home/ubuntu/redmine_files/configuration.yml|Konfigurationsdatei für Redmine|
|./portainer|Vorkonfigurierte Endpoints für Portainer|
|/home/ubuntu/portainer_files/data|Persistentes Datenverzeichnis für Portainer|
|/home/ubuntu/mysql|Datenverzeichnis für MySQL|

## Güldenstern

Der Server "Güldenstern" ist ein Root-Server.
Auf ihm laufen folgende Container:

| Dienst | Image | URL |
|--------|-------|-----|
|Mail    |Postfix/Dovecot: [tvial/docker-mailserver](https://hub.docker.com/r/tvial/docker-mailserver/) | mail.jondos.de |
|IP-Check|Eigenes Image, basierend auf [php:5-apache-jessie](https://hub.docker.com/_/php/)|https://ip-check.info|
|Shop|Eigenes Image, basierend auf [httpd](https://hub.docker.com/_/httpd/)|https://shop.anonymous-proxy-servers.net|
|[Jenkins](https://jenkins-ci.org)|[Jenkins](https://hub.docker.com/_/jenkins/)| https://build.anonymous-proxy-servers.net|
|[Subversion](https://subversion.apache.org)|[Subversion von MarvAmBass](https://hub.docker.com/r/marvambass/subversion/)|https://svn.jondos.de|

#### IP-Check

Der Container für "IP-Check" basiert auf einem eigens konstruierten Image, das wiederum auf dem offiziellen PHP-Image Version 5 (für Apache 2 und Debian Jessie) basiert. Es stellt folgende Dienste bereit:
  - Webseite https://ip-check.info auf Apache 2
  - FTP-Testseite
  - InfoService
  - Policy-Server
  - Tor

#### Shop

Auch der Container für "Shop" basiert auf einem eigens dafür konstruierten Image. Enthaltene Dienste:
  - Webseite https://shop.anonymous-proxy-servers.net auf Apache 2
  - Webshop für JonDos (Perl)
  - PaySafeCard-Client (Java auf Apache Tomcat 7)

### Volumes

Die folgenden Volumes sind auf diesem Host zusätzlich zu denen unter ["Allgemein"](#Allgemein) zu definieren:

##### Lokale Volumes

| Pfad | Funktion |
|------|----------|
|/root/jenkins-files|Persistente Konfiguration für Jenkins|
|/root/mail-files/data|Gespeicherte Daten des Mail-Containers|
|/root/mail-files/state|Persistenter Zustand des Mail-Containers|
|/root/mail-files/config|Persistente Konfiguration des Mail-Containers|
|/root/shop/db|MySQL-Datenbank des Shop-Containers|

##### Benannte Volumes

| Pfad | Funktion |
|------|----------|
|ipcheck-log|Im Container "IP-Check" fallen große Datenmengen an Log-Dateien an; dieses Volume sollte daher regelmäßig gelöscht und neu angelegt werden.|
