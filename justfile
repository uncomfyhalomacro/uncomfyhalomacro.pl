#!/usr/bin/just

update-theme:
    git submodule update --recursive --remote --init
    git add themes/jera
    git commit -s -m "update theme" || true

check:
    zola check

build:
    mkdir -p templates/
    zola build

publish: update-theme build
    #!/usr/bin/env bash
    set -euxo pipefail
    cp .domains public/.CNAME
    cp LICENSE public/LICENSE
    scp -r public/* ${USER}@${IP_ADDRESS}:/var/www/uncomfyhalomacro.pl/

local-publish: update-theme build

do-all: update-theme publish

do-all-local: update-theme local-publish
