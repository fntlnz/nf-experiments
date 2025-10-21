process SAY_HELLO {
    script:
    """
    echo "hello world"
    """
}

workflow {
    SAY_HELLO()
}
