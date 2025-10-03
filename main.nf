process MEMORY_FILL {
    memory '10 GB'

    script:
    """
    #!/usr/bin/env python3
    import time

    # Allocate 8GB of memory (8 * 1024 * 1024 * 1024 bytes)
    print("Allocating 8GB of memory...")
    data = bytearray(8 * 1024 * 1024 * 1024)

    # Fill the memory with data
    print("Filling memory with data...")
    for i in range(0, len(data), 1024 * 1024):
        data[i] = i % 256

    print("Memory filled. Holding for 360 seconds...")
    time.sleep(360)
    print("Done.")
    """
}

workflow {
    MEMORY_FILL()
}
