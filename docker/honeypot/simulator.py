import time
import random
import threading
import math
import os

print("Starting TermiOS Honeypot Load Simulator...")

def cpu_load():
    while True:
        # Simulate CPU spikes
        duration = random.uniform(0.1, 2.0)
        end_time = time.time() + duration
        
        # Burn CPU
        while time.time() < end_time:
            _ = math.sqrt(random.randint(1, 10000)) * random.random()
        
        # Random sleep to allow 'idle' times and make it look natural
        time.sleep(random.uniform(0.1, 3.0))

def memory_load():
    data = []
    while True:
        try:
            # Randomly allocate or deallocate memory
            action = random.choice(['alloc', 'free', 'hold'])
            
            if action == 'alloc':
                # Allocate 10MB - 100MB chunk
                size_mb = random.randint(10, 100)
                chunk = bytearray(size_mb * 1024 * 1024)
                data.append(chunk)
                # Cap at ~2GB usage to stay safe within limits
                if len(data) * 50 > 2000: 
                    data.clear()
            
            elif action == 'free' and data:
                # Free a random chunk
                data.pop(random.randint(0, len(data)-1))
            
            # Sleep to stabilize memory usage for a bit
            time.sleep(random.uniform(5.0, 30.0))
            
        except MemoryError:
            data.clear()
            time.sleep(1)

# Start background threads
cpu_threads = []
# Launch 2-4 threads to simulate multi-core load
for i in range(random.randint(2, 4)):
    t = threading.Thread(target=cpu_load)
    t.daemon = True
    t.start()
    cpu_threads.append(t)

mem_thread = threading.Thread(target=memory_load)
mem_thread.daemon = True
mem_thread.start()

# Keep main process alive
while True:
    time.sleep(60)
