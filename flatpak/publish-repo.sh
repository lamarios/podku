#!/usr/bin/env bash
# Imports a podku flatpak bundle into the flatpak repository served by GitHub Pages (docs/flatpak)
# and writes the podku.flatpakref / podku.flatpakrepo files pointing at it.
#
# Usage: flatpak/publish-repo.sh <bundle.flatpak> <gpg key id> [gpg homedir]
#
# SITE_URL is the public url of the docs folder, defaults to https://lamarios.github.io/podku
set -euo pipefail

BUNDLE=$1
GPG_KEY_ID=$2
GPG_HOMEDIR=${3:-${GNUPGHOME:-$HOME/.gnupg}}

APP_ID=com.github.lamarios.podku
SITE_URL=${SITE_URL:-https://lamarios.github.io/podku}
DOCS_DIR=${DOCS_DIR:-$(git rev-parse --show-toplevel)/docs}
OUT_DIR=$DOCS_DIR/flatpak
BASE_URL=$SITE_URL/flatpak
REPO=$OUT_DIR/repo

if [ ! -d "$REPO/objects" ]; then
  mkdir -p "$REPO"
  ostree init --mode=archive-z2 --repo="$REPO"
fi

flatpak build-import-bundle --no-update-summary --gpg-sign="$GPG_KEY_ID" --gpg-homedir="$GPG_HOMEDIR" "$REPO" "$BUNDLE"

# Only the latest build is kept, older commits stay available in the git history
flatpak build-update-repo --prune --prune-depth=0 \
  --title="Podku" --default-branch=master \
  --gpg-sign="$GPG_KEY_ID" --gpg-homedir="$GPG_HOMEDIR" "$REPO"

# Lock and tmp files aren't needed by clients
rm -rf "$REPO/tmp" "$REPO/.lock"

GPG_KEY=$(gpg --homedir "$GPG_HOMEDIR" --export "$GPG_KEY_ID" | base64 -w 0)

cat > "$OUT_DIR/podku.flatpakref" <<EOF
[Flatpak Ref]
Name=$APP_ID
Branch=master
Title=Podku
Url=$BASE_URL/repo/
SuggestRemoteName=podku
Homepage=https://github.com/lamarios/podku
Icon=$SITE_URL/assets/icon.svg
RuntimeRepo=https://dl.flathub.org/repo/flathub.flatpakrepo
IsRuntime=false
GPGKey=$GPG_KEY
EOF

cat > "$OUT_DIR/podku.flatpakrepo" <<EOF
[Flatpak Repo]
Title=Podku
Url=$BASE_URL/repo/
Homepage=https://github.com/lamarios/podku
Icon=$SITE_URL/assets/icon.svg
GPGKey=$GPG_KEY
EOF

# GitHub pages ignores files and folders starting with . or _ unless jekyll is disabled
touch "$DOCS_DIR/.nojekyll"
