# zb - fuzzy open files across your projects (zoxide + ripgrep + fzf + bat)
#   config: ~/.config/shell/common/zb.conf  (per-machine, gitignored) - see zb.conf.example
#   run 'zb --init' to create the config from the template

ZB_CONFIG="${ZB_CONFIG:-$HOME/.config/shell/common/zb.conf}"
if command -v batcat >/dev/null 2>&1; then
    ZB_BAT=batcat
elif command -v bat >/dev/null 2>&1; then
    ZB_BAT=bat
else
    ZB_BAT=cat
fi

_zb_usage() {
    cat <<'EOF'
usage: zb [-g] [project] <query>

  zb <query>              search ALL projects (filename match), pick + open
  zb <project> <query>    scope to one project (config -> zoxide -> path)
  zb <project>            list/open all files in one project
  zb -g <query>           content search (rg) across ALL projects, live
  zb -g <project> <query> content search in one project
  zb                      interactive project picker
  zb --init               create zb.conf from the template
  zb -h                   this help
EOF
}

# print "name<TAB>path" for every valid project in the config
_zb_project_entries() {
    local line name path
    while IFS= read -r line || [[ -n "$line" ]]; do
        case "$line" in
            '' | \#*) continue ;;
        esac
        name="${line%%=*}"
        path="${line#*=}"
        path="${path//\~/$HOME}"
        [[ -n "$name" && -d "$path" ]] && printf '%s\t%s\n' "$name" "$path"
    done < "$ZB_CONFIG"
}

# is $1 a known project (config entry, zoxide match, or existing directory)?
_zb_is_project() {
    local line name
    while IFS= read -r line || [[ -n "$line" ]]; do
        case "$line" in
            '' | \#*) continue ;;
        esac
        name="${line%%=*}"
        [[ "$name" == "$1" ]] && return 0
    done < "$ZB_CONFIG"
    if command -v zoxide >/dev/null 2>&1 && zoxide query "$1" >/dev/null 2>&1; then
        return 0
    fi
    [[ -d "$1" ]]
}

# resolve $1 to "name<TAB>path": config first, then zoxide, then raw path
_zb_resolve_entry() {
    local name="$1" line fname fpath
    while IFS= read -r line || [[ -n "$line" ]]; do
        case "$line" in
            '' | \#*) continue ;;
        esac
        fname="${line%%=*}"
        if [[ "$fname" == "$name" ]]; then
            fpath="${line#*=}"
            fpath="${fpath//\~/$HOME}"
            if [[ ! -d "$fpath" ]]; then
                echo "zb: '$fname' -> '$fpath' is not a directory" >&2
                return 1
            fi
            printf '%s\t%s\n' "$fname" "$fpath"
            return 0
        fi
    done < "$ZB_CONFIG"
    if command -v zoxide >/dev/null 2>&1; then
        if fpath="$(zoxide query "$name" 2>/dev/null)" && [[ -n "$fpath" ]]; then
            printf '%s\t%s\n' "$name" "$fpath"
            return 0
        fi
    fi
    if [[ -d "$name" ]]; then
        printf '%s\t%s\n' "$(basename "$name")" "$name"
        return 0
    fi
    echo "zb: unknown project '$name' (not in $ZB_CONFIG, not in zoxide, not a dir)" >&2
    return 1
}

_zb_init() {
    local src="${ZB_CONFIG%.conf}.conf.example"
    if [[ -f "$ZB_CONFIG" ]]; then
        echo "zb: config already exists at $ZB_CONFIG"
        return 0
    fi
    if [[ ! -f "$src" ]]; then
        echo "zb: template not found at $src" >&2
        return 1
    fi
    cp "$src" "$ZB_CONFIG"
    echo "zb: created $ZB_CONFIG - edit it to set your project paths"
}

# filename search: rows are "name<TAB>abspath", fzf picker with bat preview
_zb_search_files() {
    local query="$1"
    shift
    local ent name path f
    local -a rows=()
    for ent in "$@"; do
        name="${ent%%$'\t'*}"
        path="${ent#*$'\t'}"
        while IFS= read -r f; do
            [[ -n "$f" ]] && rows+=("$name"$'\t'"$f")
        done < <(cd "$path" 2>/dev/null && rg --files 2>/dev/null | rg -i -F -- "$query" | sed "s|^|$path/|")
    done
    if [[ ${#rows[@]} -eq 0 ]]; then
        echo "zb: no files matching '$query'" >&2
        return 1
    fi
    if [[ ${#rows[@]} -eq 1 ]]; then
        "$ZB_BAT" --paging=never "${rows[0]#*$'\t'}"
        return 0
    fi
    printf '%s\n' "${rows[@]}" | fzf --query "$query" \
        --delimiter $'\t' \
        --scheme path \
        --header "zb: ${#rows[@]} files matching '$query'" \
        --preview "$ZB_BAT --color=always --style=numbers --line-range :300 {2}" \
        --bind "enter:become($ZB_BAT --paging=never {2})"
}

# content search: fzf with live rg reload, bat preview
_zb_search_content() {
    local query="$1"
    shift
    local ent name path
    local reload=""
    for ent in "$@"; do
        name="${ent%%$'\t'*}"
        path="${ent#*$'\t'}"
        reload+="rg -il --hidden --glob '!.git' --glob '!node_modules' -e {q} \"$path\" | sed \"s|^|$name\t|\"; "
    done
    if [[ -z "$reload" ]]; then
        echo "zb: no projects to search" >&2
        return 1
    fi
    fzf --disabled --query "$query" \
        --delimiter $'\t' \
        --scheme path \
        --header "zb: content search in $# project(s) - type to refine, Enter opens" \
        --bind "start:reload($reload)" \
        --bind "change:reload($reload)" \
        --bind "enter:become($ZB_BAT --paging=never {2})" \
        --preview "$ZB_BAT --color=always --line-range :300 {2}"
}

# no args: pick a project (config entries + zoxide dirs, deduped)
_zb_pick() {
    local sel
    sel="$({ _zb_project_entries; command -v zoxide >/dev/null 2>&1 && zoxide query --list 2>/dev/null | while IFS= read -r z; do
        printf '%s\t%s\n' "$(basename "$z")" "$z"
    done; } | awk -F '\t' '!seen[$2]++' | fzf --delimiter $'\t' --scheme path \
        --header 'pick a project' \
        --preview 'ls -la {2} 2>/dev/null | head -20')"
    [[ -z "$sel" ]] && return 0
    _zb_search_files "" "$sel"
}

zb() {
    local mode=file project query
    local OPTIND opt
    while getopts ":gh" opt; do
        case "$opt" in
            g) mode=content ;;
            h) _zb_usage; return 0 ;;
            *) echo "zb: unknown option -$OPTARG"; _zb_usage; return 2 ;;
        esac
    done
    shift $((OPTIND - 1))

    [[ "$1" == "--init" ]] && { _zb_init; return $?; }

    if ! command -v fzf >/dev/null 2>&1; then
        echo "zb: fzf is not installed" >&2
        return 1
    fi
    if ! command -v rg >/dev/null 2>&1; then
        echo "zb: ripgrep (rg) is not installed" >&2
        return 1
    fi

    local -a args=("$@")
    if [[ ${#args[@]} -ge 2 ]]; then
        project="${args[0]}"
        query="${args[*]:1}"
    elif [[ ${#args[@]} -eq 1 ]]; then
        if _zb_is_project "$1"; then
            project="$1"
        else
            query="$1"
        fi
    else
        _zb_pick
        return $?
    fi

    local ent
    local -a entries=()
    if [[ -n "$project" ]]; then
        ent="$(_zb_resolve_entry "$project")" || return 1
        entries=("$ent")
    else
        if [[ ! -f "$ZB_CONFIG" ]]; then
            echo "zb: no config at $ZB_CONFIG - run 'zb --init' or edit it" >&2
            return 1
        fi
        while IFS= read -r ent; do
            entries+=("$ent")
        done < <(_zb_project_entries)
        if [[ ${#entries[@]} -eq 0 ]]; then
            echo "zb: no projects configured in $ZB_CONFIG" >&2
            return 1
        fi
    fi

    if [[ "$mode" == content ]]; then
        _zb_search_content "$query" "${entries[@]}"
    else
        _zb_search_files "$query" "${entries[@]}"
    fi
}