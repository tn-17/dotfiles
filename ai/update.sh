#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly AGENTS_SOURCE="${HOME}/.omp/agent/AGENTS.md"
readonly SKILLS_SOURCE="${HOME}/.agents/skills"

copy_file() {
    local source=$1
    local target=$2

    [[ -f "$source" ]] || {
        printf 'update: source file not found: %s\n' "$source" >&2
        return 1
    }

    cp -- "$source" "$target"
}

copy_directory_contents() {
    local source=$1
    local target=$2

    [[ -d "$source" ]] || {
        printf 'update: source directory not found: %s\n' "$source" >&2
        return 1
    }

    mkdir -p -- "$target"
    cp -a -- "$source/." "$target/"
}

copy_file "$AGENTS_SOURCE" "$SCRIPT_DIR/AGENTS.md"
copy_directory_contents "$SKILLS_SOURCE/herdr" "$SCRIPT_DIR/herdr"
copy_directory_contents "$SKILLS_SOURCE/terminal-browser" "$SCRIPT_DIR/terminal-browser"
copy_directory_contents "$SKILLS_SOURCE/vera" "$SCRIPT_DIR/vera"
