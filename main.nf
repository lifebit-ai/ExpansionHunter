params.genome = "s3://repeat-expansion/Reference/hs37d5.fa"
params.bam = "s3://repeat-expansion/Bams/HG00457.mapped.ILLUMINA.bwa.CHS.exome.20121211.bam"
params.repeats= "s3://repeat-expansion/ExpansionHunter/repeat-specs/grch37"
params.depth = "30"

genome_file = file(params.genome)
genome_index = file(params.genome+".fai")
bam_file = file(params.bam)
bai_file = file(params.bam+".bai")
repeats_dir = file(params.repeats)
depth = params.depth

process expansionhunter {
	publishDir 'results'

	input:
	file('aln.bam') from bam_file
	file('aln.bam.bai') from bai_file
	file('genome.fa') from genome_file
	file('genome.fa.fai') from genome_index
	file('repeats') from repeats_dir
	val(depth) from depth

	output:
	file('output.*') into results
	
	script:
	"""	
	ExpansionHunter \
	--bam aln.bam \
	--ref-fasta genome.fa \
	--repeat-specs repeats \
	--vcf output.vcf \
	--json output.json \
	--log output.log \
	--read-depth $depth
	"""
}

workflow.onComplete {
	println ( workflow.success ? "\nExpansionHunter is done!" : "Oops .. something went wrong" )
}