FROM docker:latest

ARG TWIST_URL
ARG TWIST_USERNAME
ARG TWIST_PASSWORD
ARG CHECKMARX_VERSION=2.0.60
ARG GCLOUD_CLI_VERSION=454.0.0
ARG SONAR_SCANNER_VERSION=5.0.1.3006
ARG SONAR_SCANNER_HOME=/opt/sonar-scanner
ARG use_embedded_jre=false

RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

# Update the package list and install git
RUN apk --no-cache update && \
     apk --no-cache add git jq unzip curl openjdk17 maven
	 
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Install the Checkmarx AST CLI
RUN curl -L -k -o ast-cli_linux_x64.tar.gz https://github.com/Checkmarx/ast-cli/releases/download/${CHECKMARX_VERSION}/ast-cli_${CHECKMARX_VERSION}_linux_x64.tar.gz
RUN ls -l
RUN gunzip ast-cli_linux_x64.tar.gz
RUN tar -xvf ast-cli_linux_x64.tar
RUN mv cx /usr/local/bin/

# Download and install SonarScanner
RUN curl -L -k -o sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
    && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -d /opt \
    && rm sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
    && mv /opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_SCANNER_HOME} \
    && chmod +x ${SONAR_SCANNER_HOME}/bin/sonar-scanner

# Download and install the Google Cloud CLI
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_CLI_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-cli-${GCLOUD_CLI_VERSION}-linux-x86_64.tar.gz && \
    ./google-cloud-sdk/install.sh

# Remove the downloaded tar file
RUN rm google-cloud-cli-${GCLOUD_CLI_VERSION}-linux-x86_64.tar.gz

# Add SonarScanner to the PATH
ENV PATH="${SONAR_SCANNER_HOME}/bin:/google-cloud-sdk/bin:${PATH}"

# Create a directory for the script
WORKDIR /usr/app

# Copy the script into the container
COPY run-command.sh .
COPY retrieveTwistlockScanner.sh .

# Ensure the script has Unix line endings and give execute permission
RUN sed -i 's/\r$//' run-command.sh && chmod +x run-command.sh
RUN sed -i 's/\r$//' retrieveTwistlockScanner.sh && chmod +x retrieveTwistlockScanner.sh

# List files in the current directory to debug
RUN ls -al
RUN /usr/app/retrieveTwistlockScanner.sh  $TWIST_URL $TWIST_USERNAME $TWIST_PASSWORD

# Set the entry point to the script
ENTRYPOINT ["/usr/app/run-command.sh"]

# Default to showing the usage message if no command is provided
CMD ["help"]
