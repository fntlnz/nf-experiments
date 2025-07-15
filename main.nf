#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.outdir = './results'
params.duration = 60

process GPU {
    label 'gpu'
    
    container 'nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04'
    
    accelerator 1


    script:
    """
    echo "starting word_printer"
    /fusion/s3/nf-lore/binaries/word_printer
    echo "word_printer complete"
    """
}

workflow {
    GPU()
}
