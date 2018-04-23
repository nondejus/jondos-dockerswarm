cd /etc/rdiffweb/clients

for host in $(ls) ; do
	rdiff-backup \
		--include-globbing-filelist $host \
		--remote-schema 'ssh -p 55022 -C %s sudo /usr/bin/rdiff-backup --server --restrict-read-only /' \
		backup@$host::/ \
		/backups/$host
done
