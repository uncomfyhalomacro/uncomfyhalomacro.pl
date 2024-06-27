#!/usr/bin/just

default: all

build:
	rm -rfv public
	npx quartz build
	cp -v .htaccess public/.htaccess

serve:
	rm -rfv public
	npx quartz build --serve

publish: build
	#!/usr/bin/env bash
	set -euxo pipefail
	sudo chown $USER1:$USER1 -R public/
	mv public zettel.uncomfyhalomacro.pl
	ssh ${USER2}@${IP_ADDRESS} 'rm -rfv "/srv/www/vhosts/zettel.uncomfyhalomacro.pl"'
	rsync --rsh="ssh -o StrictHostKeyChecking=no" -azvP --progress zettel.uncomfyhalomacro.pl "${USER2}@${IP_ADDRESS}:/srv/www/vhosts" > /dev/null
	rm -rvf zettel.uncomfyhalomacro.pl

all: serve

