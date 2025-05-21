process SAY_HELLO {
    script:
    """
    echo "hello world" && sleep 2h
    """
}

workflow {
    SAY_HELLO()
}
