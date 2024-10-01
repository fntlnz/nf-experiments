process GENERATE_NUMBERS {
    output:
    path 'numbers.txt'

    script:
    """
    #!/usr/bin/env bash
    touch numbers.txt

    for i in {1..1000}; do
        echo "Number: \$i"
        echo \$i >> numbers.txt
        sleep 1
    done
    """
}

workflow {
    GENERATE_NUMBERS()
}
