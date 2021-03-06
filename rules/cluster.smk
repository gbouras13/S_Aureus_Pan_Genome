rule cluster_each_seq:
    """Run mmseqs."""
    input:
        os.path.join(TMP,"{sample}_isfinder.ffn" )
    output:
        os.path.join(MMSEQS2, "{sample}_all_seqs.fasta"),
        os.path.join(MMSEQS2, "{sample}_cluster.tsv")
    conda:
        os.path.join('..', 'envs','cluster.yaml')
    params:
        os.path.join(MMSEQS2,  "{sample}"),
        os.path.join(MMSEQS2,  "{sample}_mmseqs2")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        mmseqs easy-cluster {input[0]} {params[0]} {params[1]} --min-seq-id 0.95 -c 0.95
        """

rule concat_ffn:
    """concate ffns"""
    input:
        expand(os.path.join(TMP,"{sample}_isfinder.ffn" ), sample = SAMPLES_not_empty)
    output:
        os.path.join(TMP,"all_samples_isfinder.ffn" )
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        cat {input} > {output}
        """


rule cluster_all_seqs:
    """Run on all."""
    input:
        os.path.join(TMP,"all_samples_isfinder.ffn" )
    output:
        os.path.join(MMSEQS2, "total_all_samples_all_seqs.fasta"),
        os.path.join(MMSEQS2, "total_all_samples_cluster.tsv")
    conda:
        os.path.join('..', 'envs','cluster.yaml')
    params:
        os.path.join(MMSEQS2,  "total_all_samples"),
        os.path.join(MMSEQS2,  "total_all_samples_tmp")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        mmseqs easy-cluster {input[0]} {params[0]} {params[1]} --min-seq-id 0.95 -c 0.95
        """

#### aggregation rule

rule aggr_cluster:
    """Aggregate."""
    input:
        expand(os.path.join(MMSEQS2, "{sample}_all_seqs.fasta"), sample = SAMPLES_not_empty),
        os.path.join(MMSEQS2, "total_all_samples_all_seqs.fasta")
    output:
        os.path.join(LOGS, "aggr_cluster.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """
