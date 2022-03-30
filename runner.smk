"""
The snakefile that runs the pipeline.
Manual launch example:

snakemake -c 1 -s runner.smk --use-conda --config Assemblies=Fastas/  --conda-create-envs-only --conda-frontend conda
compute node
snakemake -c 16 -s runner.smk --use-conda --config Assemblies=Fastas/ Output=out/ 
snakemake -c 16 -s runner.smk --use-conda --config Assemblies=/Users/a1667917/Documents/Total_Staph/final_fastas Output=/Users/a1667917/Documents/Total_Staph/mlst


"""


### DEFAULT CONFIG FILE
configfile: os.path.join(workflow.basedir,  'config', 'config.yaml')

BigJobMem = config["BigJobMem"]
BigJobCpu = config["BigJobCpu"]

### DIRECTORIES

include: "rules/directories.smk"

# get if needed
ASSEMBLIES = config['Assemblies']
OUTPUT = config['Output']

# Parse the samples and read files
include: "rules/samples.smk"
sampleAssemblies = parseSamples(ASSEMBLIES)
SAMPLES = sampleAssemblies.keys()

# Import rules and functions
include: "rules/targets.smk"
include: "rules/mlst.smk"


rule all:
    input:
        TargetFiles
