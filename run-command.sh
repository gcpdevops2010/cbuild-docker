#!/bin/sh
 
# Check if at least two arguments were passed
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 {git|mvn|cx|sonar-scanner|twistcli|docker} [arguments...]"
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
    cx)
        echo "Running Checkmarx scan..."
        cx "$@"
        ;;

    sonar-scanner)
        echo "Running SonarQube scan..."
        sonar-scanner "$@"
        ;;

	twistcli)
		echo "Running twistcli scan..."
        twistcli "$@"
        ;;

	docker)
		echo "Running docker scan..."
        docker "$@"
        ;;	
		
    *)
        echo "Invalid command: $COMMAND"
        echo "Usage: $0 {git|mvn|cx|sonarscan|twistcli|docker} [arguments...]"
        exit 1
        ;;
esac
