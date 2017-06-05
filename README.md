# Skripte und Konfigurationsdateien für eine Docker-basierte Infrastruktur für JonDos GmbH

## Komponenten

### jondocker

Das Script "jondocker" bietet eine domänenspezifische Sprache (DSL) zur Definition von Docker-basierten Diensten bzw. Servern.

Um jondocker zu installieren, muss das Script einmalig mit Administratorrechten und dem Parameter "--install" ausgeführt werden:

```shell
> sudo jondocker --install
```
#### jondocker-Scripts

Ein JonDocker-Script sollte einen Namen mit der Endung `.jd` haben, das ist aber nicht zwingend erforderlich.

Die "Shebang"-Zeile am Anfang der Datei muss auf den Pfad zum Script jondocker zeigen.
```shell
#!/usr/local/bin/jondocker
```

#### Allgemein

Ein JonDocker-Script ist grundsätzlich ein normales Shell-Script, d.h. alle Shell-Befehle können darin aufgerufen werden.

Zusätzlich unterstützt es einige spezifische Direktiven (s.u.), die sich auf die Konfiguration und den Start eines Docker-Containers beziehen.

JonDocker arbeitet nach dem Prinzip "convention over configuration" - für jede Direktive gibt es einen voreingestellten Wert, so dass theoretisch eine ausführbare Datei mit der Endung `.jd`, das nur aus der obigen "Shebang"-Zeile besteht, bereits ein gültiges JonDocker-Script.

#### Funktionsweise

JonDocker strebt danach, den Prozess der Erstellung und des Starts eines Docker-Containers zu automatisieren.
Der Aufruf

```
./nagios.jd
```

versucht folgende Schritte durchzuführen:
1. Bau eines Docker-Abbilds mit dem Namen `nagios` gemäß `./nagios/Dockerfile`.
2. Erstellung eines Docker-Containers mit dem Namen `nagios` auf Basis des eben erstellten Abbilds.
3. Start des Docker-Containers.

Falls das Abbild bereits gebaut wurde, wird es nicht erneut gebaut, es sei denn, das Dockerfile wurde seitdem geändert.
Statt dem Bau eines Abbilds kann auch eines aus einem öffentlichen Repository verwendet werden.

Der Bau und der Start des Containers kann durch verschiedene Direktiven in der `.jd`-Datei beeinflusst werden.

#### Docker-Direktiven

##### depends

_Default: (nichts)_

`depends` definiert eine Abhängigkeit zwischen Docker-Containern. Die Direktive

```
depends container_name
```

bewirkt, dass im gleichen Verzeichnis nach einem JonDocker-Script namens `container_name.jd` gesucht wird.
Diese Datei wird dann als JonDocker-Script gestartet. Falls sie weitere `depends`-Direktiven enthält, werden diese rekursiv ausgeführt. Anschließend wird der Rest der aktuellen Datei ausgeführt.

Falls keine `.jd`-Datei dieses Namens gefunden wird, bricht das Skript mit einem Fehler ab.

##### entrypoint

_Default: (leer)_

Legt einen Entrypoint-Befehl für einen Docker-Container fest, abweichend von dem, der im Dockerfile konfiguriert ist.

Beispiel:
```shell
entrypoint /run.sh
```

Dies bewirkt, dass der Befehl zum Starten des Docker-Containers folgendermaßen ausgeführt wird:

```shell
docker run -d (Parameter...) /run.sh
```

##### image

_Default: Basisname der .jd-Datei ohne Endung_

Legt den Namen des zu verwendenden Docker-Abbilds fest.

JonDocker überprüft zunächst, ob im selben Verzeichnis der .jd-Datei ein Verzeichnis mit dem angegebenen Abbildnamen existiert. In diesem Verzeichnis muss eine Datei namens `Dockerfile` existieren, die ein gültiges Dockerfile darstellt. Falls diese Bedingungen erfüllt sind, wird aus dem Dockerfile das entsprechende Abbild mit dem angegebenen Namen gebaut.

Existiert kein Verzeichnis mit diesem Namen, wird im lokalen Abbild-Repositor nach einem entsprechenden Abbild gesucht. Ist keines vorhanden, wird versucht, mittels `docker pull` das entsprechende Abbild aus den öffentlichen Repositories herunterzuladen.
Wird keines gefunden, wird das Script fehlerhaft beendet.

##### map

_Default: (leer)_

Ordnet einem angegebenen Verzeichnis ein Volume im Docker-Container zu.
Beispiel:
```
map /from /to
```

Hiermit wird das Verzeichnis `/from` auf dem Host als Verzeichnis `/to` im Container sichtbar gemacht.
Die Direktive entspricht der Angabe `docker run -v /from:/to`.

##### params

_Default: (leer)_

Definiert weitere Parameter für das `docker run`-Kommando. Beispiel:

```
params --privileged --rm
```

##### port

_Default: (nichts)_

Ordnet einem TCP-Port des Hosts einen Port im laufenden Container zu. Normalerweise handelt es sich dabei um einen Port, der im Dockerfile mit `EXPOSE` freigegeben wurde; dies ist aber nicht zwingend erforderlich.
Beispiel:

```
port 78.129.167.168:21:21
```

Die Angabe entspricht dem Aufruf `docker run -p 78.129.167.168:21:21`. Die IP-Adresse kann auch weggelassen werden; in diesem Fall wird `0.0.0.0` angenommen.

##### post_startup

_Default: (nichts)_

In der `.jd`-Datei kann eine Funktion mit dem Namen `post_startup` definiert werden. Diese Funktion wird nach dem Start des Containers als Callback-Funktion aufgerufen. Es werden aktuell keine Parameter übergeben.

#### Reverse Proxy-Konfiguration

Um Web-Dienste auf einem der Docker-Container für Zugriffe von "außen" zugänglich zu machen, kann dem Container ein Reverse Proxy vorgeschaltet werden.

##### NginX-Konfiguration

Standardmäßig sucht JonDocker im aktuellen Verzeichnis nach einer Datei mit dem Pfad `nginx/<Containername>.conf`. Wird eine solche Datei gefunden, so wird sie **auf dem Host** per symbolischer Verknüpfung unter `/etc/nginx/sites-enabled` eingebunden. Falls dort bereits eine Datei oder eine symbolische Verknüpfung dieses Namens existiert, wird sie überschrieben.

##### Container-Hostname

Falls eine NginX-Konfiguration gefunden wird, versucht JonDocker, den Hostnamen des Containers auf den Namen festzulegen, der in der NginX-Konfiguration mit der Direktive `server_name` gesetzt wurde. Dieser Name wird dann an über den Parameter `-h` an den Docker-Container übergeben. Beispiel:

_`nginx/nagios.conf:`_
```
server_name monitoring.anonymous-proxy-servers.net;
```

_Effektives Docker-Kommando:_
```
docker run -d --name nagios -h monitoring.anonymous-proxy-servers.net nagios
```

##### SSL-Konfiguration / Hilfsskript `certbot.sh`

Der Hostname aus der NginX-Konfiguration wird zusätzlich in eine Datei `certbot-domains.conf` geschrieben.
Die dort abgelegten Domainnamen können mit dem Hilfsscript `certbot.sh` in eine Let's Encrypt-Konfiguration übertragen werden.

`certbot.sh` kennt folgende Parameter:

_--init_

Erstellt eine Let's Encrypt-Konfiguration mit den Domains in der Datei `certbot-domains.conf`.

_--renew_

Erneuert alle aktiven Let's Encrypt-Zertifikate.

In beiden Fällen wird ein ggf. laufender NginX-Server zunächst beendet und dann neu gestartet.

---

## Definierte Container

### etherpad-docker.jd _(derzeit nicht verwendet)_

Ein Docker-Container für Etherpad. Wird derzeit nicht verwendet.

### ipcheck.jd

Ein Container für den Dienst http://ip-check.info und den JonDos-Infoservice.

| **Hinweis** |
| Das zugehörige Abbild wurde aus einem laufenden Debian-System erstellt. Künftig soll hierfür ein Abbild verwendet werden, das aus einem Dockerfile erstellt wird. |

### jenkins.jd

Ein Container für das JonDos-Buildsystem.
Quelle: https://hub.docker.com/_/jenkins/

### kimai.jd

Ein Container für das Zeiterfassungssystem Kimai.

### mail.jd

Ein Container für eingehenden und ausgehenden Mailverkehr (Postfix und Dovecot).
Quelle: https://github.com/tomav/docker-mailserver

### mysql.jd

Ein Container für die Datenbank. Wird aktuell nur von kimai und Redmine verwendet.
Quelle: https://hub.docker.com/_/mysql/

### nagios.jd

Ein Container für das Monitoring-System.

### redmine.jd _(derzeit nicht verwendet)_

Ein Container für den Bugtracker Redmine. Der Container wird aktuell nicht verwendet; der Bugtracker läuft direkt auf dem jeweiligen Host.
Quelle: https://hub.docker.com/_/redmine/

### shop.jd

Ein Container für den Web-Shop von JonDos.

**Hinweis** |
| Das zugehörige Abbild wurde aus einem laufenden Debian-System erstellt. Künftig soll hierfür ein Abbild verwendet werden, das aus einem Dockerfile erstellt wird. |

### svn.jd

Ein Container für den Subversion-Server.
Quelle: https://hub.docker.com/r/krisdavison/svn-server/
