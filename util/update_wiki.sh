#!/bin/bash
set -e

if [[ $# != 2 ]]; then
    echo "Missing arguments"
    exit -1
fi

if [[ -z "$GITHUB_REPOSITORY" || -z "$GITHUB_TOKEN" ]]; then
    echo "Missing environment"
    exit -1
fi

INPUTS="$1"
TAGNAME="$2"

WIKIPATH="tmp_wiki"
WIKIFILE="${WIKIPATH}/Latest.md"
git clone "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.wiki.git" "${WIKIPATH}"

echo "# Latest Autobuilds" > "$WIKIFILE"

for f in "${INPUTS}"/*.txt; do
    VARIANT="${f::-4}"
    echo "[${VARIANT}](https://github.com/${GITHUB_REPOSITORY}/releases/download/${TAGNAME}/${f})" >> "$WIKIFILE"
done

git -C "${WIKIPATH}" add "$WIKIFILE"
git -C "${WIKIPATH}" commit -m "Update latest version info"
git -C "${WIKIPATH}" push

rm -rf "$WIKIPATH"
