#!/usr/bin/env bash
#
# Update SHA256 checksums in a formula in this tap.
# Usage: ./update-checksums.sh <formula> [VERSION]
#   formula  : formula basename without .rb (e.g. rgrc, zukan)
#   VERSION  : optional; read from the formula file when omitted
#
# Works for any formula in Formula/ that downloads GitHub Release tarballs
# named <formula>-<version>-<triple>.tar.gz.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

get_version_from_formula() {
    grep -E '^\s*version\s+"[^"]+"' "$FORMULA_FILE" | sed -E 's/.*"([^"]+)".*/\1/' | head -1
}

download_and_checksum() {
    local url="$1"
    local tmpfile="/tmp/$(basename "$url")"

    info "Downloading: $url" >&2
    if curl -fsSL -o "$tmpfile" "$url"; then
        local checksum
        if [[ "$OSTYPE" == "darwin"* ]]; then
            checksum=$(shasum -a 256 "$tmpfile" | awk '{print $1}')
        else
            checksum=$(sha256sum "$tmpfile" | awk '{print $1}')
        fi
        rm -f "$tmpfile"
        echo "$checksum"
    else
        return 1
    fi
}

main() {
    if [[ $# -lt 1 ]]; then
        error "Usage: $0 <formula> [VERSION]"
        exit 1
    fi

    local FORMULA="$1"
    FORMULA_FILE="${SCRIPT_DIR}/Formula/${FORMULA}.rb"
    if [[ ! -f "$FORMULA_FILE" ]]; then
        error "Formula file not found: $FORMULA_FILE"
        exit 1
    fi

    local VERSION
    if [[ $# -ge 2 ]]; then
        VERSION="$2"
        info "Using version from command line: $VERSION"
    else
        VERSION="$(get_version_from_formula)"
        if [[ -z "$VERSION" ]]; then
            error "Could not extract version from formula file"
            exit 1
        fi
        info "Using version from formula file: $VERSION"
    fi

    # owner/name from the formula homepage, e.g. lazywalker/zukan
    local REPO
    REPO="$(grep -E '^\s*homepage' "$FORMULA_FILE" | sed -E 's#.*github.com/([^"]+).*#\1#' | head -1)"
    if [[ -z "$REPO" ]]; then
        error "Could not parse repo from formula homepage"
        exit 1
    fi
    local BASE="https://github.com/${REPO}/releases/download/v${VERSION}"

    info "Updating ${FORMULA} (${REPO}) at version ${VERSION}"
    echo

    local TRIPLES
    TRIPLES=($(grep -oE '(aarch64-apple-darwin|x86_64-apple-darwin|aarch64-unknown-linux-musl|x86_64-unknown-linux-gnu|x86_64-unknown-linux-musl)' "$FORMULA_FILE" | sort -u))
    if [[ ${#TRIPLES[@]} -eq 0 ]]; then
        error "No known target triples found in $FORMULA_FILE"
        exit 1
    fi

    local TRIPLE url_v url_u sha
    for TRIPLE in "${TRIPLES[@]}"; do
        # Try the versioned asset name first. rgrc still ships unversioned
        # assets, so fall back to <formula>-<triple> when the versioned one 404s.
        url_v="${BASE}/${FORMULA}-${VERSION}-${TRIPLE}.tar.gz"
        url_u="${BASE}/${FORMULA}-${TRIPLE}.tar.gz"
        sha=""
        if ! sha="$(download_and_checksum "$url_v")"; then
            sha="$(download_and_checksum "$url_u")" || {
                error "Failed to get checksum for ${TRIPLE}"
                exit 1
            }
        fi

        sed -i.bak -e "/${TRIPLE}/{" -e "n" -e "s/sha256 \"[^\"]*\"/sha256 \"${sha}\"/" -e "}" "$FORMULA_FILE"
        rm -f "${FORMULA_FILE}.bak"

        if grep -q "$sha" "$FORMULA_FILE"; then
            info "${TRIPLE}: ${sha}"
        else
            error "Checksum for ${TRIPLE} missing after update"
            exit 1
        fi
    done

    info "Updated successfully. Review with: git diff $FORMULA_FILE"
}

main "$@"
