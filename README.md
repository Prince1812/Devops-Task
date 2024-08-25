The security_audit.sh script is a comprehensive tool designed to perform various security checks on a Linux system. It identifies potential security vulnerabilities, such as weak or missing passwords, world-writable files, and files with SUID/SGID bits set. The script also makes necessary adjustments to system configurations to enhance security, logging all activities to a specified log file.

**Prerequisites**

**System Requirements**

  •	**Operating System**: The script is intended for Linux systems.

  •	**Root Privileges**: Since the script performs operations that require elevated privileges (e.g., modifying system files, reloading  services), it must be executed with sudo.

**Necessary Installations**

Before running the script, ensure the following tools are installed:

1.	**bash**: The script is written in Bash, which is typically available on most Linux distributions.

        sudo apt-get install bash

2.	**find**: The find command is used to search the filesystem. It is usually pre-installed on most Linux distributions. If not, you can install it with:

        sudo apt-get install findutils

3.	**grep**: The grep command is used for pattern matching in text. It is typically pre-installed, but if needed, install it with:

        sudo apt-get install grep

4.	**passwd**: The passwd command is used to check user password statuses. It is also usually pre-installed on most Linux systems.

5.	**systemctl**: This command is used to control system services, including reloading services after configuration changes. Ensure systemd is installed, which provides systemctl

        sudo apt-get install systemd

**Usage Instructions**

**Running the Script**

To execute the script, use the following command:

    sudo ./security_audit.sh

Running the script with sudo is essential for the script to perform operations that require root access, such as modifying files in the /etc directory or reloading system services.

**Log File**

The script logs all operations to a log file, which can be customized within the script. By default, the log file is located at /var/log/security_audit.log.

You can change the log file path by editing the LOG_FILE variable at the beginning of the script.

**Example**

To run the script and log its output to the default log file:

    sudo ./security_audit.sh

You can also specify a different log file:

    sudo ./security_audit.sh /path/to/your/logfile.log

**Script Features**

  **1. User Account Integrity Check**

  **Purpose**: This feature checks for users who either have no password set or have weak passwords. It identifies these users by scanning the /etc/passwd file and checking the status of their passwords.

**2. World-Writable Files Scan**

  •	**Purpose**: The script scans the filesystem for world-writable files, which can pose a security risk if not properly managed.

  •	**Limiting the Search Scope**: To optimize performance and avoid excessively long scan times, the script limits the search to key directories, specifically /home, /var, and /etc. This can be modified based on your specific environment and security requirements.

**3. SUID/SGID Files Check**

•	**Purpose**: The script checks for files with SUID (Set User ID) and SGID (Set Group ID) bits set, which can be potential security risks if improperly configured.

  •	**Limiting the Search Scope**: To reduce scan times and focus on critical areas, the script restricts the search to essential directories: /usr, /bin, /sbin, and /etc.

**4. Modifying System Files**

  **•	Purpose**: The script modifies system files like /etc/sysctl.conf to apply security enhancements.

  **•	Using sudo**: Commands that modify these files are prefixed with sudo to ensure the script has the necessary permissions. This prevents permission denied errors and ensures the changes are applied correctly.

  **•	Applying Changes**: After making modifications, the script reloads the system settings using sysctl

**5. Reloading Services**

  •	**Purpose**: The script reloads services like SSH after making configuration changes to apply the new settings.

  •	**Error Handling**: The script checks if the service reload command is successful and logs any errors for further troubleshooting.

**Additional Notes**

  •	**Timeouts**: The script includes measures to avoid hanging during long-running operations by using background execution options or limiting the scope of searches.

  •	**Error Handling**: Basic error handling is included to log any issues that occur during execution, particularly when modifying system files or reloading services.

**Contributing**

If you have improvements or additional features you'd like to contribute, feel free to fork the project and submit a pull request.

**License**

This script is free to use, modify, and distribute it as you see fit.
