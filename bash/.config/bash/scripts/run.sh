#!/bin/bash

# Function to dynamically retrieve project names
get_projects() {
    local base_dir=${CALLBOT_SOURCE}
    local projects=()
    for dir in "$base_dir"/*; do
        if [ -d "$dir" ] && [ -f "$dir/run.sh" ]; then
            # Get the directory name
            local project_name=$(basename "$dir")
            # Remove 'cb-' prefix if present
            project_name=${project_name#cb-}
            projects+=("$project_name")
        fi
    done
    echo "${projects[@]}"
}

# Function to run the selected project with optional 'test' parameter
function run_project {
    local project=$1
    local option=$2
    local base_dir=~/git/callbot/src

    # Reconstruct the directory name by adding 'cb-' prefix if necessary
    local project_dir="$base_dir/$project"
    if [ ! -d "$project_dir" ]; then
        project_dir="$base_dir/cb-$project"
    fi

    # Check if the directory exists and contains a run.sh script
    if [ -d "$project_dir" ] && [ -f "$project_dir/run.sh" ]; then
        echo "$project called"
        cd "$project_dir"

        # Check if the 'test' option is provided
        if [[ "$option" == "test" ]]; then
            echo "$project with --mocha"
            ./run.sh --mocha
        else
            ./run.sh
        fi
    else
        echo "Invalid option. Use one of: $(get_projects)."
    fi
}

if [ -f "./run.sh" ]; then
    ./run.sh "$@"
else
    projects=($(get_projects))
    if [ -z "$1" ]; then
        echo "Select your project:"
        select choice in "${projects[@]}"; do
            run_project "$choice"
            break
        done
    else
        run_project "$@"
    fi
fi
