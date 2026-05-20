#!/usr/bin/env bash
# =============================================================================
# Git Create Branch — Shell Function
# =============================================================================
#
# Simplifies the creation of a branch with a standardized naming convention.
#
# USAGE
# -----
#   gcb [prefix] <ticket> <description>
#
#   prefix:      optional, one of: fix, feature, refacto (default: feature)
#   ticket:      4-digit JIRA ticket number
#   description: branch description
#
#   e.g. gcb 1234 myBranchName
#        gcb fix 1234 hotfix-login
#
# =============================================================================

gcb() {
    local prefix="feature"

    if [[ "$1" = "fix" || "$1" = "feature" || "$1" = "refacto" ]]; then
        prefix="$1"
        shift
    fi

    local ticket_number="$1"
    if ! echo "$ticket_number" | grep -qE '^[0-9]{4}$'; then
        echo "Error: Ticket number must be a 4-digit number."
        return 1
    fi

    local description="$2"
    if [[ -z "$description" ]]; then
        echo "Error: Description cannot be empty."
        return 1
    fi

    local branch_name="${prefix}/CALLBOTEIC-${ticket_number}/${description}"
    git checkout -b "$branch_name"
}
