#!/usr/bin/env nextflow

/*
 * SET UP CONFIGURATION VARIABLES
 */
bam = Channel
		.fromPath(params.bam)
		.ifEmpty { exit 1, "${params.bam} not found.\nPlease specify --bam option (--bam bamfile)"}

// if(params.bai) {
// 	bai = Channel
// 		.fromPath(params.bai)
// 		.ifEmpty { exit 1, "${params.bai} not found.\nYou can remove your --bai option (--bai baifile) and it will be produced for you automatically"}
// }

fasta = Channel
		.fromPath(params.genome)
		.ifEmpty { exit 1, "${params.genome} not found.\nPlease specify --genome option (--genome fastafile)"}

// if(params.fai) {
// 	fai = Channel
// 			.fromPath(params.fai)
// 			.ifEmpty { exit 1, "${params.fai} not found.\nYou can remove your --fai option (--fai faifile) and it will be produced for you automatically"}
// }

repeat_specs = Channel
		.fromPath(params.repeats, type: 'dir' )
		.ifEmpty { exit 1, "${params.repeats} not found.\nPlease specify --repeats option (--repeats repeatSpecsFolder)"}

if(params.depth) {
	extraflags = "--read-depth ${params.depth}"
} else { extraflags = "" }


// Header log info
log.info """=======================================================
		ExpansionHunter
======================================================="""
def summary = [:]
summary['Pipeline Name']    = 'ExpansionHunter'
summary['Bam file']         = params.bam
summary['Reference genome'] = params.genome
summary['Repeat Specs']			= params.repeats
summary['Output dir']       = params.outdir
summary['Working dir']      = workflow.workDir
log.info summary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "========================================="

process preprocess_bam{

  tag "${bam}"
	container 'lifebitai/samtools'

  input:
  file bam from bam

  output:
  set file("ready/${bam}"), file("ready/${bam}.bai") into completeChannel

  script:
  """
  mkdir ready
  [[ `samtools view -H ${bam} | grep '@RG' | wc -l`   > 0 ]] && { mv $bam ready;}|| { java -jar /picard.jar AddOrReplaceReadGroups \
  I=${bam} \
  O=ready/${bam} \
  RGID=${params.rgid} \
  RGLB=${params.rglb} \
  RGPL=${params.rgpl} \
  RGPU=${params.rgpu} \
  RGSM=${params.rgsm};}
  cd ready ;samtools index ${bam};
  """
}

process expansion_hunter {
	publishDir "${params.outdir}", mode: 'copy'
	container 'lifebitai/expansionhunter'

	input:
	set file(bam), file(bai) from completeChannel
	file fasta from fasta
	file repeat_specs from repeat_specs

	output:
	file('output.*') into results

	script:
	"""
	ExpansionHunter \
	--bam ${bam} \
	--ref-fasta ${fasta}\
	--repeat-specs ${repeat_specs} \
	--vcf output.vcf \
	--json output.json \
	--log output.log $extraflags
	"""
}

workflow.onComplete {
	println ( workflow.success ? "\nExpansionHunter is done!" : "Oops .. something went wrong" )
}
