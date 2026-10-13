#!/bin/sh
# install-sh-skeleton.sh -- Asset for oss-standards.
#
# Minimal curl|bash installer skeleton demonstrating the professional
# idioms: POSIX sh, strict mode, TLS hardening, checksum verification
# (fail-closed), progress bar, trap cleanup, atomic install, and honest
# PATH guidance. Replace the bracketed values for your project.
set -eu

APP="<app-name>"
VERSION="${APP_VERSION:-<default-version>}"
INSTALL_DIR="${APP_INSTALL_DIR:-$HOME/.local/bin}"
BASE_URL="<https://releases.example.com>"

# --- helpers ---------------------------------------------------------------
info()  { printf '%s\n' "$1" >&2; }
error() { printf 'error: %s\n' "$1" >&2; exit 1; }
need_cmd() { command -v "$1" >/dev/null 2>&1 || error "need '$1' (not found)"; }

usage() {
    printf 'usage: %s [--help] [--version]\n' "$0"
    printf 'env: APP_VERSION (pin release), APP_INSTALL_DIR (default %s)\n' "$HOME/.local/bin"
}

for arg in "$@"; do
    case "$arg" in
        --help) usage; exit 0 ;;
        --version) printf '%s\n' "${APP_VERSION:-<default-version>}"; exit 0 ;;
    esac
done

# --- platform --------------------------------------------------------------
os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
case "$arch" in
    x86_64) arch="x86_64" ;;
    aarch64|arm64) arch="aarch64" ;;
    *) error "unsupported architecture: $arch" ;;
esac
if [ "$(uname -o 2>/dev/null)" = "Android" ]; then
    info "Android/Termux detected"
fi

# --- download ---------------------------------------------------------------
need_cmd curl
need_cmd tar
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT INT TERM

tarball="$APP-$VERSION-$os-$arch.tar.gz"
url="$BASE_URL/$tarball"
info "=> downloading $tarball"
curl --proto '=https' --tlsv1.2 -fSL --retry 3 --progress-bar \
    "$url" -o "$tmpdir/$tarball" ||
    error "download failed: $url"
info "=> verifying checksum"
curl --proto '=https' --tlsv1.2 -fsSL \
    "$BASE_URL/SHA256SUMS" -o "$tmpdir/SHA256SUMS" ||
    error "could not fetch SHA256SUMS"
(cd "$tmpdir" && sha256sum -c SHA256SUMS --status) ||
    error "checksum verification FAILED for $tarball"

# --- install (atomic) --------------------------------------------------------
info "=> installing to $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
tar -xzf "$tmpdir/$tarball" -C "$tmpdir"
# extract to tmp dir first, then move into place atomically
mv "$tmpdir/$APP" "$INSTALL_DIR/$APP"
chmod +x "$INSTALL_DIR/$APP"

info "$APP installed successfully to $INSTALL_DIR/$APP"
case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *) printf 'Next step: add %s to your PATH, e.g.\n  export PATH="%s:$PATH"\n' \
            "$INSTALL_DIR" "$INSTALL_DIR" >&2 ;;
esac
printf "Run '%s --help' to get started.\n" "$APP" >&2
