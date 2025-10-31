process MEMFILLER {
    container 'python:3.11-slim'
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
