#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly AGENTS_TARGET="${HOME}/.omp/agent/AGENTS.md"
readonly SKILLS_TARGET="${HOME}/.agents/skills"
readonly HERDR_PLUGIN_LIST_SOURCE="$SCRIPT_DIR/herdr/plugins.txt"
readonly COMPONENTS=(agents herdr terminal-browser vera)

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

install_herdr_plugins() {
    local plugin
    local failed=0

    if [[ ! -f "$HERDR_PLUGIN_LIST_SOURCE" ]]; then
        printf 'install: skipping missing Herdr plugin list: %s\n' "$HERDR_PLUGIN_LIST_SOURCE" >&2
        return 0
    fi

    if ! command -v herdr >/dev/null 2>&1; then
        printf 'install: skipping Herdr plugins; herdr is not installed\n' >&2
        return 0
    fi

    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
        if [[ -z "${plugin//[[:space:]]/}" ]]; then
            continue
        fi

        printf 'install: installing Herdr plugin: %s\n' "$plugin"
        if ! herdr plugin install --yes "$plugin"; then
            printf 'install: unable to install Herdr plugin: %s\n' "$plugin" >&2
            failed=1
        fi
    done < "$HERDR_PLUGIN_LIST_SOURCE"

    return "$failed"
}

install_component() {
    local component=$1

    case "$component" in
        agents)
            copy_file "$SCRIPT_DIR/AGENTS.md" "$AGENTS_TARGET"
            ;;
        herdr)
            copy_file "$SCRIPT_DIR/herdr/SKILL.md" "$SKILLS_TARGET/herdr/SKILL.md"
            install_herdr_plugins
            ;;
        terminal-browser)
            copy_directory_contents "$SCRIPT_DIR/terminal-browser" "$SKILLS_TARGET/terminal-browser"
            ;;
        vera)
            copy_directory_contents "$SCRIPT_DIR/vera" "$SKILLS_TARGET/vera"
            ;;
    esac
}

usage() {
    cat <<'EOF'
Usage: install.sh [--interactive] [--all | component ...]

Install selected AI configuration components. With no arguments, open an
interactive multi-select picker when fzf is available; otherwise prompt for
component names or numbers separated by spaces or commas.

Components:
  agents           AGENTS.md -> ~/.omp/agent/AGENTS.md
  herdr            herdr skill -> ~/.agents/skills/herdr; install listed plugins
  terminal-browser terminal-browser skill -> ~/.agents/skills/terminal-browser
  vera             Vera skill -> ~/.agents/skills/vera

Options:
  -i, --interactive  Prompt for components explicitly
  --all              Install every component present in this checkout
  -h, --help         Show this help
EOF
}

print_components() {
    printf 'Available components:\n'
    printf '  1) agents           AGENTS.md\n'
    printf '  2) herdr            herdr skill; install listed plugins\n'
    printf '  3) terminal-browser terminal-browser skill\n'
    printf '  4) vera             Vera skill\n'
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
        1|agents|agent)
            components+=(agents)
            ;;
        2|herdr)
            components+=(herdr)
            ;;
        3|terminal-browser|terminal_browser|terminalbrowser)
            components+=(terminal-browser)
            ;;
        4|vera)
            components+=(vera)
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
