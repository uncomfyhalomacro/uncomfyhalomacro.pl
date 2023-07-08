#!/usr/bin/just

check:
  zola check

build:
  zola build

publish: build
  #!/usr/bin/bash

  set -euxo pipefail
  zola build
  cp .domains public/.domains
  git config --global init.defaultBranch main
  git config --global user.name "${CI_REPO_OWNER}"
  git config --global user.email "${MAIL}"
  pushd public/
  git init
  git remote add origin ""https://${PAGES_ACCESS_TOKEN}@codeberg.org/${CI_REPO}.git"
  git add -A
  git commit -m "update site page for ${CI_COMMIT_SHA:-}"
  git push --force -u origin main

do-all: check build publish