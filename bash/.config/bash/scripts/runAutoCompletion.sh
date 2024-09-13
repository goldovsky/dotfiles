_run_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Function to dynamically retrieve project names for autocompletion
    get_projects() {
        local base_dir=${CALLBOT_SOURCE}
        local projects=()
        for dir in "$base_dir"/*; do
            if [ -d "$dir" ] && [ -f "$dir/run.sh" ]; then
                local project_name=$(basename "$dir")
                project_name=${project_name#cb-}
                projects+=("$project_name")
            fi
        done
        echo "${projects[@]}"
    }

    # Get the dynamic list of projects
    local projects=($(get_projects))
    local secondary_options=("test")

    # If the previous word is one of the projects, suggest secondary options
    if [[ " ${projects[@]} " =~ " $prev " ]]; then
        COMPREPLY=($(compgen -W "${secondary_options[*]}" -- "$cur"))
    else
        # Otherwise, suggest the project names
        COMPREPLY=($(compgen -W "${projects[*]}" -- "$cur"))
    fi
}

# Register the autocompletion function for the 'run' command
complete -F _run_completion run
