#!/bin/bash

# Set variables
log_group_name="shell-log"
log_stream_name=$(date "+%Y/%m/%d") # Use today's date as the log stream name
log_message="This is a test log message"

# Check if log stream exists
log_stream_exists=$(aws logs describe-log-streams \
    --log-group-name $log_group_name \
    --log-stream-name-prefix $log_stream_name \
    --query 'logStreams[*].logStreamName' \
    --output text)

if [[ -z "$log_stream_exists" ]]; then
    echo "Log stream does not exist. Creating log stream..."
    aws logs create-log-stream --log-group-name $log_group_name --log-stream-name $log_stream_name
fi

# Publish log message
aws logs put-log-events \
    --log-group-name $log_group_name \
    --log-stream-name $log_stream_name \
    --log-events timestamp=$(date +%s000),message="$log_message"