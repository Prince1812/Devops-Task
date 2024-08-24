# Monitoring script
This Bash script is designed to monitor various system resources on a proxy server and present the information in a dashboard format. The script allows you to view specific parts of the dashboard by using command-line switches.
**Features**
    •	Top 10 Most Used Applications: Displays the top 10 applications consuming the most CPU and memory.
    •	Network Monitoring: Provides information on concurrent connections, packet drops, and network traffic.
    •	Disk Usage: Shows disk space usage by mounted partitions and highlights partitions using more than 80% of the space.
    •	System Load: Displays the current load average and CPU usage breakdown.
    •	Memory Usage: Shows total, used, and free memory, as well as swap memory usage.
    •	Process Monitoring: Displays the number of active processes and the top 5 processes in terms of CPU and memory usage.
    •	Service Monitoring: Monitors the status of essential services like sshd, nginx/apache, iptables.
    •	Custom Dashboard: Allows you to view specific parts of the dashboard using command-line switches.

**Prerequisites**
    Before running the script, ensure that your system has the following tools installed:
    •	awk
    •	ps
    •	ss or netstat
    •	df
    •	mpstat
    •	free
    •	systemctl
    You may need to install some of these utilities using your package manager (e.g., apt, yum). You can use this command to install these tools using your packet      manager for example:
    •	sudo apt install awk


**Installation**
    1.	Save the script as monitoring_script.sh.
    2.	Make sure all the prerequisites are installed on the first hand before executing the script.
    3.	Make the script executable by running the following command:
        •	chmod +x monitoring_script.sh

**Usage**
**Running the Script**
  You can run the script with various command-line switches to view specific monitoring information. Below are some examples:
  Display All Information
  To display all available monitoring information, use the -all switch:
    •	./monitoring_script.sh -all 

**Display Specific Information** 
1.	Display Top 10 Applications by CPU and Memory Usage
    •	./monitoring_script.sh -all
    The -all switch will include top applications since there's no separate switch for this specific feature in the provided script.

2.	Display Memory Usage
    •	./monitoring_script.sh -memory
    It displays the information regarding memory usage of the system.

3.	Display Network Statistics
    •	./monitoring_script.sh -network
    It displays the information regarding network statistics


4.	Display Disk Usage and Partitions Over 80% Usage
    •	./monitoring_script.sh -disk
    It displays information regarding disk usage and partitions.

5.	Display CPU Load and Usage Breakdown
    •	./monitoring_script.sh -cpu
    It displays information regarding CPU load and Usage breakdown

6.	Display Process Monitoring Information
    •	./monitoring_script.sh -all
    The -all switch will include process monitoring since there's no separate switch for this specific feature in the provided script.


**Combining Options**
You can combine multiple options to display specific parts of the dashboard:
    •	./monitoring_script.sh -cpu -memory
    This command will display both CPU load/usage breakdown and memory usage.
    
**Help**
To see a list of available options and usage instructions, run:
    •	./monitoring_script.sh -help

**Customization**
If you need to customize the script, such as changing the network interface name or adding additional monitoring features, you can edit the script directly. Look for sections labelled with comments like # Function to ... for easy navigation.

**License**
This script is free to use, modify, and distribute it as you see fit. You can use this script as you like.



