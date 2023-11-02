#!/bin/bash

# Check if at least two arguments were passed
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 {git|mvn|cxscan|sonarscan} [arguments...]"
    exit 1
fi

# Extract the command and shift the arguments to pass the rest to the respective tool
COMMAND="$1"
shift
 
# Case statement to handle different commands
case "$COMMAND" in
    git)
        echo "Running Git command..."
        git "$@"
        ;;
    mvn)
        echo "Running Maven build..."
        mvn "$@"
        ;;
    cxscan)
        echo "Running Checkmarx scan..."
        cxscan "$@"
        ;;
    sonarscan)
        echo "Running SonarQube scan..."
        sonarscan "$@"
        ;;
    *)
        echo "Invalid command: $COMMAND"
        echo "Usage: $0 {git|mvn|cxscan|sonarscan} [arguments...]"
        exit 1
        ;;
esac
