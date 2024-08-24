#!/bin/bash

# Function to display usage information
function usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -cpu          Display system load and CPU usage breakdown"
  echo "  -memory       Display memory usage and swap memory stats"
  echo "  -network      Display network statistics"
  echo "  -disk         Display disk usage and partitions over 80% usage"
  echo "  -services     Monitor essential services like sshd, nginx/apache, iptables"
  echo "  -all          Display all monitoring information"
  echo "  -help         Display this help message"
  echo ""
  echo "Examples:"
  echo "  $0 -cpu -memory           # Display only CPU and memory usage"
  echo "  $0 -all                   # Display all monitoring information"
  echo "  $0 -network -disk         # Display network and disk usage"
}

# Function to display the top 10 applications by CPU and memory usage
function top_apps() {
  echo "----- Top 10 Applications by CPU Usage -----"
  ps aux --sort=-%cpu | head -n 11

  echo -e "\n----- Top 10 Applications by Memory Usage -----"
  ps aux --sort=-%mem | head -n 11
}

# Function to monitor network stats
function network_monitor() {
  echo "----- Network Monitoring -----"
  echo "Number of concurrent connections to the server:"
  ss -tun | wc -l

  echo -e "\nPacket drops:"
  netstat -s | grep "packet loss"

  echo -e "\nNetwork traffic in MB:"
  interface="eth0"  # Change this to your network interface name
  awk -v interface="$interface" '$1 ~ interface {print "In: " $2/1024 " KB, Out: " $10/1024 " KB"}' /proc/net/dev
}

# Function to display disk usage
function disk_usage() {
  echo "----- Disk Usage -----"
  df -h

  echo -e "\nPartitions using more than 80% of space:"
  df -h | awk '$5 >= 80 {print $0}'
}

# Function to display system load
function system_load() {
  echo "----- Current Load Average -----"
  uptime

  echo -e "\nCPU Usage Breakdown:"
  mpstat | grep -A 5 "%idle" | tail -n +2
}

# Function to display memory usage
function memory_usage() {
  echo "----- Memory Usage -----"
  free -h

  echo -e "\nSwap Memory Usage:"
  free -m | awk '/Swap/ {printf "Swap Total: %s MB, Swap Used: %s MB\n", $2, $3}'
}

# Function to monitor processes
function process_monitor() {
  echo "----- Process Monitoring -----"
  echo "Number of Active Processes:"
  ps -e | wc -l

  echo -e "\nTop 5 Processes by CPU Usage:"
  ps aux --sort=-%cpu | head -n 6

  echo -e "\nTop 5 Processes by Memory Usage:"
  ps aux --sort=-%mem | head -n 6
}

# Function to monitor essential services
function service_monitor() {
  echo "----- Monitoring Essential Services -----"
  systemctl status sshd nginx iptables
}

# Function to display the custom dashboard based on user input
function custom_dashboard() {
  for arg in "$@"
  do
    case $arg in
      -cpu)
        system_load
        ;;
      -memory)
        memory_usage
        ;;
      -network)
        network_monitor
        ;;
      -disk)
        disk_usage
        ;;
      -services)
        service_monitor
        ;;
      -all)
        top_apps
        echo -e "\n"
        network_monitor
        echo -e "\n"
        disk_usage
        echo -e "\n"
        system_load
        echo -e "\n"
        memory_usage
        echo -e "\n"
        process_monitor
        echo -e "\n"
        service_monitor
        ;;
      -help)
        usage
        exit 0
        ;;
      *)
        echo "Invalid option: $arg"
        usage
        exit 1
        ;;
    esac
  done
}

# Main script execution starts here
if [ $# -eq 0 ]; then
  echo "No arguments provided. Use -help for usage instructions."
  exit 1
else
  custom_dashboard "$@"
fi

