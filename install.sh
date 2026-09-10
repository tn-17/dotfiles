#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly AI_INSTALLER="$SCRIPT_DIR/ai/install.sh"
readonly CONFIG_INSTALLER="$SCRIPT_DIR/.config/install.sh"
readonly COMPONENTS=(
    ai/agents
    ai/herdr
    ai/terminal-browser
    ai/vera
    config/astrovim
    config/ghostty
    config/herdr
    config/tuxedo
    config/yazi
)

declare -a requested=()

auto_install_all() {
    printf 'install: AI configuration\n'
    "$AI_INSTALLER" --all

    printf 'install: application configuration\n'
    "$CONFIG_INSTALLER" --all
}

usage() {
    cat <<'EOF'
Usage: install.sh [--interactive | --all | component ...]
       install.sh ai [--interactive | --all | component ...]
       install.sh config [--interactive | --all | component ...]

Install AI and application configuration. With no arguments, open one
interactive multi-select picker covering both configuration groups. Keep
using the nested scripts for direct, group-specific access.

Examples:
  install.sh                         Install selected components interactively
  install.sh --all                   Install every component in both groups
  install.sh ai agents vera           Install selected AI components
  install.sh config astrovim yazi     Install selected application components
  install.sh ai/herdr config/herdr   Install both Herdr components

Options:
  -i, --interactive  Open the unified component picker
  --all              Install every component in both groups
  -h, --help         Show this help

Components:
  ai/agents           AGENTS.md and agent rules
  ai/herdr            Herdr skill and listed plugins
  ai/terminal-browser terminal-browser skill
  ai/vera             Vera skill
  config/astrovim     AstroNvim config -> XDG config directory/nvim
  config/ghostty      Ghostty config -> XDG config directory/ghostty
  config/herdr        Herdr config -> XDG config directory/herdr
  config/tuxedo       Tuxedo config -> XDG config directory/tuxedo
  config/yazi         Yazi config -> XDG config directory/yazi

Groups:
  ai                 Delegate to ai/install.sh
  config             Delegate to .config/install.sh
EOF
}

print_components() {
    printf 'Available components:\n'
    printf '  1) ai/agents           AGENTS.md and agent rules\n'
    printf '  2) ai/herdr            Herdr skill and listed plugins\n'
    printf '  3) ai/terminal-browser terminal-browser skill\n'
    printf '  4) ai/vera             Vera skill\n'
    printf '  5) config/astrovim     AstroNvim config\n'
    printf '  6) config/ghostty      Ghostty config\n'
    printf '  7) config/herdr        Herdr config\n'
    printf '  8) config/tuxedo       Tuxedo config\n'
    printf '  9) config/yazi         Yazi config\n'
}

pick_components() {
    local selection
    local status

    if command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
        if selection="$(
            printf '%s\n' "${COMPONENTS[@]}" |
                fzf --multi --height=50% --layout=reverse --border \
                    --prompt='Install > ' \
                    --header='TAB select  ENTER install  ESC cancel'
        )"; then
            if [[ -n "$selection" ]]; then
                mapfile -t requested <<< "$selection"
            else
                requested=()
            fi
            return 0
        fi

        status=$?
        if ((status == 130)); then
            requested=()
            return 0
        fi

        printf 'install: component picker failed (status %d)\n' "$status" >&2
        return "$status"
    fi

    print_components
    printf '\nSelect components (names or numbers, separated by spaces or commas): '
    selection=''
    if IFS= read -r selection; then
        IFS=', ' read -r -a requested <<< "$selection"
    else
        requested=()
    fi
}

install_selected() {
    local item
    declare -a ai_components=()
    declare -a config_components=()

    for item in "${requested[@]}"; do
        case "${item,,}" in
            all)
                ai_components+=(agents herdr terminal-browser vera)
                config_components+=(astrovim ghostty herdr tuxedo yazi)
                ;;
            1|ai/agents|ai:agents|agents)
                ai_components+=(agents)
                ;;
            2|ai/herdr|ai:herdr)
                ai_components+=(herdr)
                ;;
            3|ai/terminal-browser|ai:terminal-browser|ai/terminal_browser|terminal-browser|terminal_browser|terminalbrowser)
                ai_components+=(terminal-browser)
                ;;
            4|ai/vera|ai:vera|vera)
                ai_components+=(vera)
                ;;
            5|config/astrovim|config:astrovim|astrovim|astro-nvim|nvim|neovim)
                config_components+=(astrovim)
                ;;
            6|config/ghostty|config:ghostty|ghostty)
                config_components+=(ghostty)
                ;;
            7|config/herdr|config:herdr)
                config_components+=(herdr)
                ;;
            8|config/tuxedo|config:tuxedo|tuxedo)
                config_components+=(tuxedo)
                ;;
            9|config/yazi|config:yazi|yazi)
                config_components+=(yazi)
                ;;
            herdr)
                printf 'install: use ai/herdr or config/herdr for the ambiguous Herdr component\n' >&2
                return 2
                ;;
            ''|none|skip)
                ;;
            *)
                printf 'install: unknown component: %s\n' "$item" >&2
                usage >&2
                return 2
                ;;
        esac
    done

    if ((${#ai_components[@]} == 0 && ${#config_components[@]} == 0)); then
        printf 'install: no components selected\n'
        return 0
    fi

    if ((${#ai_components[@]} != 0)); then
        printf 'install: AI configuration\n'
        "$AI_INSTALLER" "${ai_components[@]}"
    fi

    if ((${#config_components[@]} != 0)); then
        printf 'install: application configuration\n'
        "$CONFIG_INSTALLER" "${config_components[@]}"
    fi
}

interactive=0

if (($# == 0)); then
    interactive=1
else
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -i|--interactive)
            if (($# != 1)); then
                printf 'install: --interactive cannot be combined with other arguments\n' >&2
                usage >&2
                exit 2
            fi
            interactive=1
            ;;
        --all|all)
            if (($# != 1)); then
                printf 'install: --all cannot be combined with other arguments\n' >&2
                usage >&2
                exit 2
            fi
            auto_install_all
            exit 0
            ;;
        ai|--ai)
            shift
            "$AI_INSTALLER" "$@"
            exit 0
            ;;
        config|--config)
            shift
            "$CONFIG_INSTALLER" "$@"
            exit 0
            ;;
        -*)
            printf 'install: unknown option: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
        *)
            requested=("$@")
            install_selected
            exit $?
            ;;
    esac
fi

if ((interactive)); then
    pick_components
    install_selected
fi
