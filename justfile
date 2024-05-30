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
    sudo chown $USER1:$USER1 -R public/
    cp LICENSE public/LICENSE
    ssh ${USER2}@${IP_ADDRESS} 'rm -rfv /var/www/uncomfyhalomacro.pl/*'
    rsync -a public/* ${USER2}@${IP_ADDRESS}:/var/www/uncomfyhalomacro.pl/

