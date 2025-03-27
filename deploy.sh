#!/bin/bash

# Configuration
LOCAL_JAR_PATH="build/libs/spring-ollama-0.0.1-SNAPSHOT-plain.jar"
REMOTE_HOST="172.27.184.67"
REMOTE_USER="lsb"
REMOTE_PATH="/home/lsb/spring-ollama/spring-ollama-0.0.1-SNAPSHOT-plain.jar"
SSH_PORT="22"  # New SSH port
SSH_PASSWORD="lsb"


# Function to execute SSH commands
execute_ssh_command() {
    sshpass -p "$SSH_PASSWORD" ssh -p $SSH_PORT -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} "$1"
}

# Upload the JAR file
echo "Uploading JAR file..."
sshpass -p "$SSH_PASSWORD" scp -P $SSH_PORT -o StrictHostKeyChecking=no "$LOCAL_JAR_PATH" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}"

if [ $? -ne 0 ]; then
    echo "Error uploading file. Exiting."
    exit 1
fi

echo "JAR file uploaded successfully."

# Stop the previous process
echo "Stopping previous process..."
execute_ssh_command "pid=\$(pgrep -f \"java -jar ${REMOTE_PATH}\"); if [ ! -z \"\$pid\" ]; then kill \$pid; echo \"Process \$pid stopped\"; else echo \"No previous process found\"; fi"

# Wait a moment to ensure the process has stopped
sleep 2

# Execute the JAR file on the server
echo "Executing JAR file on the server..."

# Use nohup to keep the process running after SSH disconnects,
# redirect output to a log file, and run in the background
SSH_COMMAND="nohup java -jar ${REMOTE_PATH} > app_output.log 2>&1 &"

execute_ssh_command "$SSH_COMMAND"

if [ $? -ne 0 ]; then
    echo "Error executing JAR file. Check the server logs."
    exit 1
fi

echo "JAR file execution initiated on the server."
echo "You can check the app_output.log file on the server for application output."

# Optionally, you can tail the log file to see the output
echo "Tailing the log file (press Ctrl+C to stop):"
execute_ssh_command "tail -f app_output.log"