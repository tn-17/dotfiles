#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly AI_UPDATER="$SCRIPT_DIR/ai/update.sh"
readonly CONFIG_UPDATER="$SCRIPT_DIR/.config/update.sh"

run_both() {
    printf 'update: AI configuration\n'
    "$AI_UPDATER"

    printf 'update: application configuration\n'
    "$CONFIG_UPDATER"
}

usage() {
    cat <<'EOF'
Usage: update.sh [--all | ai | config]

Update the repository from configuration installed on the current machine.
With no arguments, update both AI and application configuration groups. Keep
using the nested scripts for direct, group-specific access.

Examples:
  update.sh             Update both groups
  update.sh ai          Update only AI configuration
  update.sh config      Update only application configuration

Options:
  --all                 Update both configuration groups
  -h, --help            Show this help

Groups:
  ai                    Delegate to ai/update.sh
  config                Delegate to .config/update.sh
EOF
}

if (($# == 0)); then
    run_both
    exit 0
fi

case "$1" in
    -h|--help)
        usage
        ;;
    ai|--ai)
        if (($# != 1)); then
            printf 'update: group selection cannot be combined with other arguments\n' >&2
            usage >&2
            exit 2
        fi
        "$AI_UPDATER"
        ;;
    config|--config)
        if (($# != 1)); then
            printf 'update: group selection cannot be combined with other arguments\n' >&2
            usage >&2
            exit 2
        fi
        "$CONFIG_UPDATER"
        ;;
    all|--all)
        if (($# != 1)); then
            printf 'update: --all cannot be combined with other arguments\n' >&2
            usage >&2
            exit 2
        fi
        run_both
        ;;
    *)
        printf 'update: expected ai, config, or no arguments; got: %s\n' "$1" >&2
        usage >&2
        exit 2
        ;;
esac
