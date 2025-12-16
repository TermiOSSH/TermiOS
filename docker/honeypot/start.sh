#!/bin/bash

# Start the load simulator in background
python3 /opt/simulator.py &

# Start SSH Daemon (Foreground)
/usr/sbin/sshd -D
