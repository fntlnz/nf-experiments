process MEMFILLER {
    memory '160.GB'

    output:
    stdout

    script:
    """
    python3 ${projectDir}/memfiller.py
    """
}

workflow {
    MEMFILLER()
}
