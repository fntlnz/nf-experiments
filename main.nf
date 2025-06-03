process RUNSAM {
    script:
    """
    wget https://github.com/samtools/samtools/raw/refs/heads/develop/test/bedcov/bedcov.bam
    cat > samtoolsscript.sh << 'EOF'
    #!/bin/bash
    samtools view bedcov.bam
    EOF
    chmod +x samtoolsscript.sh
    mkfifo example.pipe
    bash samtoolsscript.sh > example.pipe 
    wait
    """
}

workflow {
    RUNSAM()
}
