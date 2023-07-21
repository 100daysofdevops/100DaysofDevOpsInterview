#!/bin/bash
# This script is the quick check to detect whether the performance issue is due to CPU, Memory, Input/Output (I/O), and network error 

function check_cpu() {
  load_avg=$(w | head -n 1 | awk '{print $9}' |cut -f1 -d",")
  num_cores=$(nproc)
  max_load=$(echo "0.7 * $num_cores" | bc)

  if [[ $(echo "$load_avg > $max_load" | bc) -eq 1 ]]; then
    echo -e "\033[1;31m CPU load average is currently $load_avg, which is higher than the maximum of $max_load \033[0m" >&2
    return 1
  else
    echo -e "\033[1;32m CPU load average is currently $load_avg, which is within the acceptable range.\033[0m"
    return 0
  fi
}

function check_memory() {
  THRESHOLD=90

  total_memory=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
  available_memory=$(grep 'MemAvailable' /proc/meminfo | awk '{print $2}')

  memory_utilization=$(echo "scale=2; ($total_memory - $available_memory)/$total_memory * 100" | bc)

  if (( $(echo "$memory_utilization > $THRESHOLD" | bc -l) ))
  then 
      echo -e "\033[1;32m Memory utilization is above the threshold!!! Memory utilization is: $utilization% \033[0m"
      return 1
  else
      echo -e "\033[1;32m Memory utilizationis currently $memory_utilization, which is within the acceptable range.\033[0m"
      return 0
  fi 
}

function check_io() {
  iowait_state=$(top -b -n 1 | head -n +3|awk '{print $10}'|tail -1 |bc)
  if [[ $(echo "$iowait_state > 1" | bc) -eq 1 ]]; then
    echo -e "\033[1;31m IOWAIT is currently $iowait_state, which is higher than the acceptable range \033[0m" >&2
    return 1
  else
    echo -e "\033[1;32m IOWAIT is currently $iowait_state, which is within the acceptable range.\033[0m"
    return 0
  fi
}

function check_network() {
  if ! command -v ifconfig >/dev/null 2>&1; then
    echo "ifconfig command is not present. Installing..."
    if [ -f /etc/centos-release ]; then
      sudo yum install -y net-tools
    elif [ -f /etc/lsb-release ]; then
      sudo apt-get update
      sudo apt-get install -y net-tools
    else
      echo "Unsupported operating system"
      exit 1
    fi
  fi

  interface=$(ifconfig |head -1|awk '{print $1}' |cut -f1 -d:)

  rx_error_count=$(ifconfig $interface | grep "RX errors" |awk '{print $3}')

  tx_error_count=$(ifconfig $interface | grep "TX errors" |awk '{print $3}')

  if [[ $rx_error_count -gt 0 || $tx_error_count -gt 0 ]]; then
    echo -e "\033[1;31m Network Error is currently for Receive Error: $rx_error_count and Transmit Error: $tx_error_count, which is higher than the acceptable range \033[0m" >&2
    return 1
  else
    echo -e "\033[1;32m Network Error is currently for Receive Error: $rx_error_count and Transmit Error: $tx_error_count, which is within the acceptable range.\033[0m"
    return 0
  fi
}

function send_email() {
  # Replace with your email
  recipient="youremail@example.com"
  subject="Alert: System performance issue detected"
  body="One or more performance issues have been detected on the system. Please check the system immediately."
  echo "$body" | mail -s "$subject" $recipient
}

function main() {
  check_cpu || send_email
  check_memory || send_email
  check_io || send_email
  check_network || send_email
}

main
