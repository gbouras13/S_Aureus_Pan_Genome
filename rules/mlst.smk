#### if you want to only look at the unmapped READS
#### I have decided to look at them all for now

rule mlst:
    """Run mlst."""
    input:
        expand(os.path.join(ASSEMBLIES, "{sample}.fasta"), sample = SAMPLES)
    output:
        os.path.join(RESULTS,"mlst.txt" )
    conda:
        os.path.join('..', 'envs','mlst.yaml')
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        mlst --scheme saureus {input} > {output} 
        """
