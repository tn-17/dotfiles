#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly AGENTS_SOURCE="${HOME}/.omp/agent/AGENTS.md"
readonly SKILLS_SOURCE="${HOME}/.agents/skills"
readonly CONFIG_SOURCE="${XDG_CONFIG_HOME:-${HOME}/.config}"
readonly HERDR_PLUGINS_SOURCE="${CONFIG_SOURCE}/herdr/plugins.json"
readonly HERDR_PLUGIN_LIST_TARGET="${SCRIPT_DIR}/herdr/plugins.txt"

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

gather_herdr_plugin_list() {
    local target_directory
    local temporary

    if [[ ! -f "$HERDR_PLUGINS_SOURCE" ]]; then
        printf 'update: skipping missing Herdr plugin metadata: %s\n' "$HERDR_PLUGINS_SOURCE" >&2
        return 0
    fi

    if ! command -v jq >/dev/null 2>&1; then
        printf 'update: skipping Herdr plugin list; jq is not installed\n' >&2
        return 0
    fi

    target_directory="$(dirname -- "$HERDR_PLUGIN_LIST_TARGET")"
    mkdir -p -- "$target_directory"
    temporary="$(mktemp -- "$target_directory/.plugins.txt.XXXXXX")"

    if ! jq -r '
        if type != "array" then
            error("expected an array")
        else
            (.[] |
                select(.source.kind? == "github") |
                select((.source.owner? | type) == "string") |
                select((.source.repo? | type) == "string") |
                "\(.source.owner)/\(.source.repo)")
        end
    ' "$HERDR_PLUGINS_SOURCE" >"$temporary"; then
        rm -f -- "$temporary"
        printf 'update: unable to parse Herdr plugin metadata: %s\n' "$HERDR_PLUGINS_SOURCE" >&2
        return 0
    fi

    chmod 0644 "$temporary"
    mv -- "$temporary" "$HERDR_PLUGIN_LIST_TARGET"
}

copy_file "$AGENTS_SOURCE" "$SCRIPT_DIR/AGENTS.md"
copy_file "$SKILLS_SOURCE/herdr/SKILL.md" "$SCRIPT_DIR/herdr/SKILL.md"
sync_directory_contents "$SKILLS_SOURCE/terminal-browser" "$SCRIPT_DIR/terminal-browser"
sync_directory_contents "$SKILLS_SOURCE/vera" "$SCRIPT_DIR/vera"
gather_herdr_plugin_list
