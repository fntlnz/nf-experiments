size_in_gb = 150
size_in_bytes = size_in_gb * (1024**3)

try:
    large_list = [0] * (size_in_bytes // 8)
    print("Successfully allocated 150 GB of memory.")

    while True:
        pass

except MemoryError:
    print("Memory allocation failed. Not enough memory available.")
except KeyboardInterrupt:
    print("Program interrupted by user.")
