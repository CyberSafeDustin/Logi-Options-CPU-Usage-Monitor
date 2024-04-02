#!/bin/bash

# File to store the status of the last check
status_file="/tmp/logi_options_plus_cpu_check_status.txt"

# Initialize status file if it does not exist
if [ ! -f "$status_file" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Initialization" > "$status_file"
fi

while true; do
    # Use pgrep to find the PIDs of the target process
    pids=$(pgrep -f "logioptionsplus_agent")

    if [ -z "$pids" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Logi Options+ process not found." >> "$status_file"
        sleep 600  # 10 minutes
        continue
    fi

    high_usage="0"
    for pid in $pids; do
        # Get the CPU usage for the process, discard decimals
        cpu_usage=$(ps -p $pid -o %cpu= | awk '{print int($1)}')

        echo "$(date '+%Y-%m-%d %H:%M:%S') - Checking PID $pid: CPU Usage = $cpu_usage" >> "$status_file"

        # Direct integer comparison without bc
        if [ "$cpu_usage" -gt 50 ]; then
            high_usage="1"
            break # No need to check other PIDs once high usage is found
        fi
    done

    last_check=$(cat "$status_file" | tail -n 1 | cut -d " " -f 5) # Assuming last status is always the 5th word

    if [ "$high_usage" -eq "1" ]; then
        if [[ "$last_check" == "1" ]]; then
            # Kill the process if this is the second consecutive check over 50%
            for pid in $pids; do
                echo "$(date '+%Y-%m-%d %H:%M:%S') - Killing PID $pid due to high CPU usage." >> "$status_file"
                kill "$pid"
                sleep 1
            done
        fi
        echo "$(date '+%Y-%m-%d %H:%M:%S') - 1" >> "$status_file" # Mark this check as high usage
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - 0" >> "$status_file" # Reset status if usage is normal
    fi

    # Wait for 10 minutes before checking again
    sleep 600
done
