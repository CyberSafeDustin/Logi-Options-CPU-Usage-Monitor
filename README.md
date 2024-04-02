# Logi-Options-CPU-Usage-Monitor
A bash script designed to monitor the CPU usage of the Logi Options+ application on Apple Silicon Macs. 

The script aims to address issues with Logi Options+ occasionally consuming excessive CPU resources, potentially affecting system performance. When high CPU usage is detected consistently over two checks, the script will automatically terminate the process to mitigate any negative impact on system performance.

Purpose
The primary goal of this script is to keep the Logi Options+ application in check by monitoring its CPU usage and automatically taking corrective action if excessive usage is detected. This ensures that your Mac maintains optimal performance without manual intervention.

How It Works
The script uses pgrep to find the process IDs (PIDs) of the Logi Options+ application and checks their CPU usage using ps. If the CPU usage exceeds a defined threshold for two consecutive checks, the script will terminate the process(es) to alleviate unnecessary load on the CPU.

Usage
Clone the Repository:

sh
Copy code
git clone https://github.com/CyberSafeDustin/Logi-Options-CPU-Usage-Monitor
cd Logi-Options-CPU-Usage-Monitor
Make the Script Executable:

sh
Copy code
chmod +x logi_cpu_watcher.sh
Run the Script:

Manually run the script in the terminal:

sh
Copy code
./logi_cpu_watcher.sh
To stop the script, use Ctrl + C.

Modifying for Other Processes
To adapt this script for monitoring other applications:

Update the Process Name: Modify the pgrep -f "logioptionsplus_agent" line in the script to match the new target application's process name.

Adjust the CPU Usage Threshold: Change the value in the comparison if [ "$cpu_usage" -gt 50 ]; then to suit the acceptable CPU usage threshold for the new application.

Setting Up Persistence
To ensure the script runs continuously, even after reboots:

Create a LaunchAgent:

Save a .plist file in ~/Library/LaunchAgents/. Example: com.user.logioptionspluscpuwatcher.plist. Update the ProgramArguments section with the path to your script.

xml
Copy code
<key>ProgramArguments</key>
<array>
    <string>/path/to/your_script.sh</string>
</array>
Load the LaunchAgent:

sh
Copy code
launchctl load ~/Library/LaunchAgents/com.user.logioptionspluscpuwatcher.plist
This will automatically start the script at login.

Original Intent
Developed specifically for Apple Silicon Macs, this script is a response to the Logi Options+ application's tendency to consume excessive CPU resources at times. By monitoring and managing this behavior automatically, users can maintain their system's performance and reliability without needing to manually intervene.
