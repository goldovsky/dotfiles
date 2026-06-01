# Encode to base64
b64() { echo -n "$1" | base64; }
# Encode to base64 + copy to clipboard
b64c() { echo -n "$1" | base64 | xclip -selection clipboard; }
# Decode from base64 to plain string
b64d() { echo -n "$1" | base64 --decode; }
# Decode from base64 to plain string + copy to clipboard
b64dc() { echo -n "$1" | base64 --decode | xclip -selection clipboard; }

# Tree
printTree() {
    local dir="$1" prefix="$2"
    if [ -z "$dir" ]; then
        echo "$(basename "$(pwd)")/"
        dir="."
    fi
    for entry in "$dir"/*/; do
        [ -d "$entry" ] || continue
        local name=$(basename "$entry")
        [ "$name" = "node_modules" ] && continue
        echo "${prefix}├── $name/"
        if [ -e "$entry/.git" ] || [ -e "$entry/.bare" ]; then
            continue
        fi
        printTree "$entry" "${prefix}│   "
    done
}
