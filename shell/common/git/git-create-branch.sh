#!/bin/bash

# This script simplifies the creation of a branch

# - 1st Parameter (optional, 'feature' by default): branch prefix, only ['fix', 'feature', 'refacto'] are allowed, quotes not needed for usage
# - 2nd Parameter : number of the JIRA ticket, only 4 digits allowed
# - 3rd Parameter : description
# ex usage: {alias-for-this-script} 1234 myBranchName

# Set default prefix
prefix="feature"

# Check if a prefix is provided and is valid
if [ "$1" = "fix" ] || [ "$1" = "feature" ] || [ "$1" = "refacto" ]; then
    prefix="$1"
    shift  # Remove the prefix from the arguments
fi

# Validate the ticket number
ticket_number="$1"
if ! echo "$ticket_number" | grep -qE '^[0-9]{4}$'; then
    echo "Error: Ticket number must be a 4-digit number."
    exit 1
fi

# Validate the description
description="$2"
if [ -z "$description" ]; then
    echo "Error: Description cannot be empty."
    exit 1
fi

# Create the branch name
branch_name="${prefix}/CALLBOTEIC-${ticket_number}/${description}"

# Create the branch
git checkout -b "$branch_name"
