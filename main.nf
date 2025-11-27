process TEST_LINK_REMAP {
    output:
    path 'result.txt'

    script:
    """
    #!/usr/bin/env bash
    set -e

    TEMP_DIR=\$(mktemp -d -p /tmp fusion_link_remap_XXXXXX)
    ORIGINAL_FILE="\$TEMP_DIR/original.txt"
    HARDLINK_FILE="\$TEMP_DIR/hardlink.txt"

    echo "Temp directory: \$TEMP_DIR"

    # Create file with test data
    for i in {1..100}; do
        echo "Test data line \$i for link-remap" >> "\$ORIGINAL_FILE"
    done
    echo "Created: \$ORIGINAL_FILE"

    # Create hard link (n_link becomes 2)
    ln "\$ORIGINAL_FILE" "\$HARDLINK_FILE"
    echo "Created hardlink: \$HARDLINK_FILE"
    echo "n_link: \$(stat -c %h "\$ORIGINAL_FILE")"

    # Open file descriptor via original path
    exec 3< "\$ORIGINAL_FILE"
    echo "Opened fd 3"

    # Delete original path (n_link becomes 1, not 0)
    # This creates an "invisible file" that requires link-remap for checkpoint/restore
    rm "\$ORIGINAL_FILE"
    echo "Deleted original path, n_link now: \$(stat -c %h "\$HARDLINK_FILE")"

    # Now run a long operation while holding the invisible file open
    # This is the scenario that tests CRIU's link-remap functionality
    touch result.txt
    for i in {1..600}; do
        echo "Iteration: \$i"
        echo "iteration_\$i" >> result.txt

        # Periodically read from the invisible file via fd
        if [ \$((i % 5)) -eq 0 ]; then
            # Seek to beginning and read
            DATA=\$(head -c 50 <&3 2>/dev/null || true)
            exec 3< /proc/self/fd/3 2>/dev/null || true
            echo "Read from invisible file fd: \${#DATA} bytes"
        fi

        sleep 1
    done

    echo "Test completed successfully"
    exec 3<&-
    rm -f "\$HARDLINK_FILE"
    rmdir "\$TEMP_DIR" 2>/dev/null || true
    """
}

workflow {
    TEST_LINK_REMAP()
}
