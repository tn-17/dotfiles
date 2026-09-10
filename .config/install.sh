#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly CONFIG_TARGET="${HOME}/.config"
readonly COMPONENTS=(astrovim ghostty herdr tuxedo yazi)

copy_file() {
    local source=$1
    local target=$2

    if [[ ! -f "$source" ]]; then
        printf 'install: skipping missing file: %s\n' "$source" >&2
        return 0
    fi

    mkdir -p -- "$(dirname -- "$target")"
    cp -- "$source" "$target"
}

copy_directory_contents() {
    local source=$1
    local target=$2

    if [[ ! -d "$source" ]]; then
        printf 'install: skipping missing directory: %s\n' "$source" >&2
        return 0
    fi

    mkdir -p -- "$target"
    cp -a -- "$source/." "$target/"
}

install_ghostty() {
    local source="$SCRIPT_DIR/ghostty/config.ghostty"
    local target="$CONFIG_TARGET/ghostty/config.ghostty"

    if [[ ! -f "$source" ]]; then
        source="$SCRIPT_DIR/ghostty/config"
    fi

    if [[ -f "$CONFIG_TARGET/ghostty/config" && ! -f "$target" ]]; then
        target="$CONFIG_TARGET/ghostty/config"
    fi

    copy_file "$source" "$target"
}

install_component() {
    local component=$1

    case "$component" in
        astrovim)
            copy_directory_contents "$SCRIPT_DIR/astrovim" "$CONFIG_TARGET/nvim"
            ;;
        ghostty)
            install_ghostty
            ;;
        herdr)
            copy_file "$SCRIPT_DIR/herdr/config.toml" "$CONFIG_TARGET/herdr/config.toml"
            copy_file "$SCRIPT_DIR/herdr/plugins.txt" "$CONFIG_TARGET/herdr/plugins.txt"
            ;;
        tuxedo)
            copy_file "$SCRIPT_DIR/tuxedo/config.toml" "$CONFIG_TARGET/tuxedo/config.toml"
            ;;
        yazi)
            copy_file "$SCRIPT_DIR/yazi/yazi.toml" "$CONFIG_TARGET/yazi/yazi.toml"
            ;;
    esac
}

usage() {
    cat <<'EOF'
Usage: install.sh [--interactive] [--all | component ...]

Install selected configuration components. With no arguments, open an
interactive multi-select picker when fzf is available; otherwise prompt for
component names or numbers separated by spaces or commas.

Components:
  astrovim AstroNvim config -> ~/.config/nvim
  ghostty  Ghostty config -> ~/.config/ghostty/config.ghostty
  herdr    Herdr config and plugin list -> ~/.config/herdr
  tuxedo   Tuxedo config -> ~/.config/tuxedo/config.toml
  yazi     Yazi config -> ~/.config/yazi/yazi.toml

Options:
  -i, --interactive  Prompt for components explicitly
  --all              Install every component present in this checkout
  -h, --help         Show this help
EOF
}

print_components() {
    printf 'Available components:\n'
    printf '  1) astrovim AstroNvim config\n'
    printf '  2) ghostty  Ghostty config\n'
    printf '  3) herdr    Herdr config and plugin list\n'
    printf '  4) tuxedo   Tuxedo config\n'
    printf '  5) yazi     Yazi config\n'
}

pick_components() {
    local selection
    local status

    if command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
        if selection="$(
            printf '%s\n' "${COMPONENTS[@]}" |
                fzf --multi --height=40% --layout=reverse --border \
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

declare -a requested=()
interactive=0

if (($# == 0)); then
    interactive=1
else
    while (($#)); do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -i|--interactive)
                interactive=1
                ;;
            --all|all)
                requested+=(all)
                ;;
            --)
                shift
                requested+=("$@")
                break
                ;;
            -*)
                printf 'install: unknown option: %s\n' "$1" >&2
                usage >&2
                exit 2
                ;;
            *)
                requested+=("$1")
                ;;
        esac
        shift
    done
fi

if ((interactive)); then
    if ((${#requested[@]} != 0)); then
        printf 'install: --interactive cannot be combined with components\n' >&2
        usage >&2
        exit 2
    fi

    pick_components
fi

declare -a components=()
for item in "${requested[@]}"; do
    case "${item,,}" in
        all)
            components+=("${COMPONENTS[@]}")
            ;;
        1|astrovim|astro-nvim|nvim|neovim)
            components+=(astrovim)
            ;;
        2|ghostty)
            components+=(ghostty)
            ;;
        3|herdr)
            components+=(herdr)
            ;;
        4|tuxedo)
            components+=(tuxedo)
            ;;
        5|yazi)
            components+=(yazi)
            ;;
        ''|none|skip)
            ;;
        *)
            printf 'install: unknown component: %s\n' "$item" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if ((${#components[@]} == 0)); then
    printf 'install: no components selected\n'
    exit 0
fi

declare -A installed=()
for component in "${components[@]}"; do
    if [[ ${installed[$component]:-0} == 1 ]]; then
        continue
    fi

    installed["$component"]=1
    install_component "$component"
done
