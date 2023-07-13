#!/usr/bin/just

update-theme:
    git submodule update --recursive --remote --init

check:
    zola check

build:
    mkdir -p templates/
    zola build

publish: build
    #!/usr/bin/env bash
    set -euxo pipefail
    cp .domains public/.domains
    pushd public/
    git init
    git remote add origin "https://${PAGES_ACCESS_TOKEN}@codeberg.org/${CI_REPO}.git"
    git add -A
    git commit -m "update site page for ${CI_COMMIT_SHA:-}"
    git push --force -u origin main

local-publish
    #!/usr/bin/env bash
    set -euxo pipefail
    export CI_COMMIT_SHA="$(git rev-parse HEAD)"
    cp .domains public/.domains
    pushd public/
    git init
    git remote add origin "git@codeberg.org:uncomfyhalomacro/pages.git"
    git add -A
    git commit -m "update site page for ${CI_COMMIT_SHA:-}"
    git push --force -u origin main

do-all: update-theme publish
