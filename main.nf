process WAIT_FOR_SIGNAL {
    script:
    """
    #!/usr/bin/env bash

    # Variable to track which signal was received
    RECEIVED_SIGNAL=""

    # Signal handler function
    handle_signal() {
        RECEIVED_SIGNAL=\$1
        echo "Received signal: \$RECEIVED_SIGNAL"
        exit 0
    }

    # Set up signal handlers for common signals
    trap 'handle_signal SIGTERM' TERM
    trap 'handle_signal SIGINT' INT
    trap 'handle_signal SIGHUP' HUP
    trap 'handle_signal SIGUSR1' USR1
    trap 'handle_signal SIGUSR2' USR2

    echo "Process \$\$ waiting for signal..."
    echo "Timeout: 10 minutes"

    # Wait for 10 minutes (600 seconds) or until a signal is received
    sleep 600 &
    SLEEP_PID=\$!

    wait \$SLEEP_PID 2>/dev/null
    EXIT_CODE=\$?

    # If wait exits normally (not interrupted by signal), it means timeout occurred
    if [ \$EXIT_CODE -eq 0 ] && [ -z "\$RECEIVED_SIGNAL" ]; then
        echo "Timeout: No signal received within 10 minutes"
        exit 0
    fi
    """
}

workflow {
    WAIT_FOR_SIGNAL()
}
