# Konzept für Jondos-Dockerserver

----

## Ziel-Infrastruktur

### Host 1: mintaka.anonymous-proxy-servers.net

* Container für MySQL
* Container für Redmine
* Container für Nagios
* Container für Kimai
* Container für Jenkins
* Container für Etherpad
* Reverse Proxy auf dem Host

### Host 2: bellatrix.anonymous-proxy-servers.net

* Container für Exim4 / Courier
* Container für Apache (ip-check.info)
* Container für SVN (noch notwendig? Vielleicht lieber GitHub)
* Container für Apache (shop.anonymous-proxy-servers.net)

---

## mintaka

### MySQL

https://hub.docker.com/_/redmine/

### Redmine

Anleitung zur Docker-Installation von Redmine:

https://hub.docker.com/_/redmine/
