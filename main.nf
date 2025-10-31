process MEMFILLER {
    container 'python:3.11'
    memory '160.GB'

    input:
    path script_file

    output:
    stdout

    script:
    """
    python3 ${script_file}
    """
}

workflow {
    script_ch = Channel.fromPath("${projectDir}/memfiller.py")
    MEMFILLER(script_ch)
}
