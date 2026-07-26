#!/usr/bin/env bash
#
# Build the landing site and publish it into the josh.tf website repo.
#
# The previous one-liner copied dist/ into the website repo and stopped there, so
# it exited 0 while josh.tf/fxcommands stayed unchanged, leaving a large
# uncommitted delete-and-re-add sitting in that repo.
#
# Override the destination with WEBSITE_DIR=... if the checkout lives elsewhere.
set -euo pipefail

WEBSITE_DIR="${WEBSITE_DIR:-$HOME/development/josh-tf/website}"
SUBDIR="fxcommands"
TARGET="${WEBSITE_DIR}/${SUBDIR}"

if [ ! -d "${WEBSITE_DIR}/.git" ]; then
	echo "Error: ${WEBSITE_DIR} is not a git checkout."
	echo "       Set WEBSITE_DIR to the josh-tf/website checkout."
	exit 1
fi

echo "==> Building"
npm run build

# Guard the rm -rf below: if the build produced nothing usable, keep the live copy.
if [ ! -s "dist/index.html" ]; then
	echo "Error: dist/index.html is missing or empty — refusing to replace ${TARGET}"
	exit 1
fi

echo "==> Publishing to ${TARGET}"
# Wiping first is deliberate: Astro emits content-hashed filenames under _astro/,
# so a plain copy would accumulate every previous build's orphaned assets.
rm -rf "${TARGET}"
mkdir -p "${TARGET}"
cp -r dist/. "${TARGET}/"

cd "${WEBSITE_DIR}"

# Scope everything to ${SUBDIR}. The website repo routinely carries unrelated
# work in progress, and a bare `git commit -a` would sweep it into this commit.
git add -- "${SUBDIR}"

if git diff --cached --quiet -- "${SUBDIR}"; then
	echo "==> No change to ${SUBDIR}, nothing to publish"
	exit 0
fi

git commit -q -m "chore: rebuild fxcommands landing site" -- "${SUBDIR}"
git push
echo "==> Published — https://josh.tf/${SUBDIR}/"
