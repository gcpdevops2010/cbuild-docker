# Use a base image that includes Java and Maven
FROM maven:3.8.4-openjdk-11

# Update the package list and install git
RUN apt-get update && \
    apt-get install -y git && \
    # Clean up to keep the docker image as small as possible
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Assume that cxscan and sonarscan tools are already installed and available in the PATH
# Otherwise, you would add the installation steps for these tools here

# Create a directory for the script
WORKDIR /usr/src/app

# Copy the script into the container
COPY run-command.sh .

# Ensure the script has Unix line endings and give execute permission
RUN sed -i 's/\r$//' run-command.sh && chmod +x run-command.sh

# List files in the current directory to debug
RUN ls -al

# Set the entry point to the script
ENTRYPOINT ["/usr/src/app/run-command.sh"]

# Default to showing the usage message if no command is provided
CMD ["help"]
