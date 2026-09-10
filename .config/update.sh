#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly CONFIG_SOURCE="${XDG_CONFIG_HOME:-${HOME}/.config}"

copy_file() {
    local source=$1
    local target=$2

    if [[ ! -f "$source" ]]; then
        printf 'update: skipping missing file: %s\n' "$source" >&2
        return 0
    fi

    mkdir -p -- "$(dirname -- "$target")"
    cp -- "$source" "$target"
}

sync_directory_contents() {
    local source=$1
    local target=$2
    local entry
    local source_entry
    local name
    local nullglob_was_set=0

    if [[ ! -d "$source" ]]; then
        printf 'update: skipping missing directory: %s\n' "$source" >&2
        return 0
    fi

    mkdir -p -- "$target"

    if shopt -q nullglob; then
        nullglob_was_set=1
    fi
    shopt -s nullglob

    for entry in "$target"/.[!.]* "$target"/..?* "$target"/*; do
        name=${entry##*/}
        source_entry="$source/$name"
        if [[
            (! -e "$source_entry" && ! -L "$source_entry") ||
            (-L "$entry" && ! -L "$source_entry") ||
            (! -L "$entry" && -L "$source_entry") ||
            (-d "$entry" && ! -d "$source_entry") ||
            (! -d "$entry" && -d "$source_entry")
        ]]; then
            rm -rf -- "$entry"
        fi
    done

    if ((nullglob_was_set == 0)); then
        shopt -u nullglob
    fi

    cp -a -- "$source/." "$target/"
}

sync_directory_contents "$CONFIG_SOURCE/nvim" "$SCRIPT_DIR/astrovim"
copy_file "$CONFIG_SOURCE/ghostty/config.ghostty" "$SCRIPT_DIR/ghostty/config.ghostty"
copy_file "$CONFIG_SOURCE/herdr/config.toml" "$SCRIPT_DIR/herdr/config.toml"
copy_file "$CONFIG_SOURCE/tuxedo/config.toml" "$SCRIPT_DIR/tuxedo/config.toml"
copy_file "$CONFIG_SOURCE/yazi/yazi.toml" "$SCRIPT_DIR/yazi/yazi.toml"
