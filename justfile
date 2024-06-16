#!/usr/bin/just

update-theme:
    git submodule update --recursive --remote --init
    git add themes/gruvbox-v
    git commit -s -m "update theme" || true

check:
    zola check

build:
    mkdir -p templates/
    zola build

webring:
    mkdir -p templates/macros/
    echo "{% macro openring() %}" | tee templates/macros/in.html > /dev/null
    openring -n 6 -S webring-list -t in.html | tee -a templates/macros/in.html > /dev/null
    echo "{% endmacro %}" | tee -a templates/macros/in.html > /dev/null

local-publish: update-theme webring build
    #!/usr/bin/env bash
    set -euxo pipefail
    sudo chown $USER1:$USER1 -R public/
    cp LICENSE public/LICENSE
    ssh ${USER2}@${IP_ADDRESS} 'rm -rfv "${OUTPATH}/*"'
    rsync --rsh="ssh -o StrictHostKeyChecking=no" -aP public/* "${USER2}@${IP_ADDRESS}:${OUTPATH}" > /dev/null

publish: update-theme webring build
    #!/usr/bin/env bash
    set -euxo pipefail
    cp LICENSE public/LICENSE
    ssh ${USER2}@${IP_ADDRESS} 'rm -rfv "${OUTPATH}/*"' > /dev/null
    rsync --rsh="ssh -o StrictHostKeyChecking=no" -aP public/* "${USER2}@${IP_ADDRESS}:${OUTPATH}" > /dev/null

