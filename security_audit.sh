#!/bin/bash
# Script to automate security audits and server hardening on Linux servers

# Initialize variables
LOG_FILE="security_audit.log"
CONFIG_FILE="custom_checks.conf"

# Start logging
echo "Security Audit and Server Hardening Script" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE

# Function to list users and groups on the server
list_users_and_groups() {
    echo "Listing all users and groups on the server..." | tee -a $LOG_FILE
    echo "Users:" >> $LOG_FILE
    getent passwd | tee -a $LOG_FILE

    echo "Groups:" >> $LOG_FILE
    getent group >> $LOG_FILE
    echo "User and Group audit complete." >> $LOG_FILE
}

# Function to check for users with root privileges (UID 0)
check_root_users() {
    echo "Checking for users with UID 0..." | tee -a $LOG_FILE
    ROOT_USERS=$(awk -F: '($3 == 0) {print}' /etc/passwd)
    echo "Root Users: $ROOT_USERS" >> $LOG_FILE
}

# Function to check for weak or no passwords
check_weak_passwords() {
    echo "Checking for users without passwords or with weak passwords..." | tee -a $LOG_FILE
    for user in $(awk -F: '($3 >= 1000) {print $1}' /etc/passwd); do
        echo "Processing user: $user" | tee -a $LOG_FILE
        passwd_output=$(timeout 5s passwd -S $user 2>&1)  # Timeout after 5 seconds
        echo "Output for $user: $passwd_output" | tee -a $LOG_FILE
        if [[ "$passwd_output" != *"may not view or modify"* ]]; then
            echo "$passwd_output" | grep -E "NP|LK" && echo "User $user has no password or is locked." | tee -a $LOG_FILE
        fi
    done

    echo "Weak password check complete." >> $LOG_FILE
}

# Function to check for world-writable files
check_world_writable_files() {
    echo "Scanning for world-writable files in /home, /var, and /etc..." >> $LOG_FILE
    find /home /var /etc -perm -2 ! -type l -ls >> $LOG_FILE 2>/dev/null
    echo "World-writable files scan complete." >> $LOG_FILE
}

# Function to check SSH directory permissions
check_ssh_directories() {
    echo "Checking permissions on .ssh directories..." >> $LOG_FILE
    find /home -name ".ssh" -exec ls -ld {} \; >> $LOG_FILE 2>/dev/null
    echo "SSH directory permissions check complete." >> $LOG_FILE
}

# Function to check for SUID/SGID files
check_suid_sgid_files() {
    echo "Checking for files with SUID or SGID bits set in /usr, /bin, /sbin, and /etc..." >> $LOG_FILE
    find /usr /bin /sbin /etc -perm /6000 -type f -exec ls -ld {} \; >> $LOG_FILE 2>/dev/null
    echo "SUID/SGID files check complete." >> $LOG_FILE
}


# Function to list all running services
list_running_services() {
    echo "Listing all running services..." >> $LOG_FILE
    systemctl list-units --type=service --state=running >> $LOG_FILE
    echo "Running services listed." >> $LOG_FILE
}

# Function to check critical services like SSH and firewall
check_critical_services() {
    echo "Checking critical services..." >> $LOG_FILE
    for service in sshd iptables; do
        systemctl is-active --quiet $service && echo "$service is running" >> $LOG_FILE || echo "$service is NOT running" >> $LOG_FILE
    done
    echo "Critical services check complete." >> $LOG_FILE
}

# Function to check listening ports
check_listening_ports() {
    echo "Checking listening ports..." >> $LOG_FILE
    ss -tuln >> $LOG_FILE
    echo "Listening ports check complete." >> $LOG_FILE
}

# Function to check open ports and associated services
check_open_ports() {
    echo "Checking for open ports and services..." >> $LOG_FILE
    ss -tuln >> $LOG_FILE
    echo "Open ports check complete." >> $LOG_FILE
}

# Function to check IP forwarding status
check_ip_forwarding() {
    echo "Checking IP forwarding status..." >> $LOG_FILE
    sysctl net.ipv4.ip_forward >> $LOG_FILE
    echo "IP forwarding check complete." >> $LOG_FILE
}

# Function to check public vs. private IP addresses
check_ip_addresses() {
    echo "Checking public vs. private IP addresses..." >> $LOG_FILE
    ip a >> $LOG_FILE
    echo "IP address check complete." >> $LOG_FILE
}

# Function to check if sensitive services are exposed on public IPs
check_sensitive_services() {
    echo "Checking if sensitive services are exposed on public IPs..." >> $LOG_FILE
    # Example: Checking if SSH is listening on public IPs
    ss -tuln | grep -q ":22" && echo "SSH is listening on a public IP" >> $LOG_FILE || echo "SSH is not exposed to the public" >> $LOG_FILE
    echo "Sensitive service exposure check complete." >> $LOG_FILE
}

# Function to check for available security updates
check_security_updates() {
    echo "Checking for available security updates..." >> $LOG_FILE
    apt list --upgradable >> $LOG_FILE
    echo "Security updates check complete." >> $LOG_FILE
}

# Function to monitor logs for suspicious activity
monitor_logs() {
    echo "Checking logs for suspicious activity..." >> $LOG_FILE
    grep "Failed password" /var/log/auth.log >> $LOG_FILE
    echo "Log monitoring complete." >> $LOG_FILE
}

# Function to harden SSH configuration
harden_ssh() {
    echo "Hardening SSH configuration..." >> $LOG_FILE
    # Disable root login
    sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    # Enforce key-based authentication
    sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl reload sshd
    echo "SSH hardening complete." >> $LOG_FILE
}

# Function to disable IPv6
disable_ipv6() {
    echo "Disabling IPv6..." >> $LOG_FILE
    # Add necessary sysctl configuration
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> sudo tee -a /etc/sysctl.conf > /dev/null
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> sudo tee -a /etc/sysctl.conf > /dev/null
    sysctl -p >> $LOG_FILE
    echo "IPv6 disabled." >> $LOG_FILE
}



# Executing the functions

list_users_and_groups
check_root_users
check_weak_passwords
check_world_writable_files
check_ssh_directories
check_suid_sgid_files
list_running_services
check_critical_services
check_listening_ports
check_open_ports
check_ip_forwarding
check_ip_addresses
check_sensitive_services
check_security_updates
monitor_logs
harden_ssh
disable_ipv6
