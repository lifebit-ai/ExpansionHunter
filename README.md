# ExpansionHunter

NB: **Many of the inputs/flags in the original ExpansionHunter documentation will not work.** Instead use the paramters used in the example below. If any paramters from the original ExpansionHunter documentation (which is included below the example) are required they can be implemented by modifying the main.nf script. For any queries about implementing more paramters or anything else you can email me at: phil@lifebit.ai.

## Example command that can be run over Deploit
Example/test command that can be run on [Deploit](https://deploit.lifebit.ai/) using publically available test data. The data can be imported from the AWS S3 bucket [s3://lifebit-featured-datasets/](https://s3.console.aws.amazon.com/s3/buckets/lifebit-featured-datasets/pipelines/RepeatExpansion/?region=eu-west-1&tab=overview) 
```        
nextflow run lifebit-ai/ExpansionHunter --genome RepeatExpansion/Reference/hg19.fa \
                                        --bam RepeatExpansion/ExpansionHunter/small/bam/bamlet.bam \
                                        --repeats RepeatExpansion/ExpansionHunter/repeat-specs/hg19 \
                                        --depth 30
```

* Please ensure the index file (.bam.bai) is located within the same folder. For example, for the test data the index file HG00472.mapped.ILLUMINA.bwa.CHS.exome.20121211.bam.bai is already located within RepeatExpansion/RepeatExpansion/Bams folder and so nothing more needs to be done.
* **--depth 30** was used due to the small bam file and may not need to be speicified for larger bam files
* **--repeats** while already generated for the test data a [custom repeat specs file](https://github.com/Illumina/ExpansionHunter/wiki/Inputs) may need to be made to analyse other data
* The execution time was 10mins on a m2.2xlarge (medium cost saving spot instance) (much quicker than GangSTR/HipSTR due to the repeat-specs specifiying a smaller target reigon)
* The output should be found in the format of output.vcf, output.json and output.log 

<br />
<br />
<br />
<br />
<br />



# [Original ExpansionHunter Documentation](https://github.com/Illumina/ExpansionHunter/wiki)

Expansion Hunter: a tool for estimating repeat sizes
----------------------------------------------------

There are a number of regions in the human genome consisting of repetitions of short unit sequence (commonly a trimer). Such repeat regions can expand to a size much larger than the read length and thereby cause a disease. [Fragile X Syndrome](https://en.wikipedia.org/wiki/Fragile_X_syndrome), [ALS](https://en.wikipedia.org/wiki/Amyotrophic_lateral_sclerosis), and [Huntington's Disease](https://en.wikipedia.org/wiki/Huntington%27s_disease) are well known examples.

Expansion Hunter aims to estimate sizes of such repeats by performing a targeted search through a BAM/CRAM file for reads that span, flank, and are fully contained in each repeat.

Linux and macOS operating systems are currently supported.

License
-------

Expansion Hunter is provided under the terms and conditions of the [GPLv3 license](LICENSE.txt). It relies on several third party packages provided under other open source licenses, please see [COPYRIGHT.txt](COPYRIGHT.txt) for additional details.

Documentation
-------------

Installation instructions, usage guide, and description of file formats are available on [wiki](https://github.com/Illumina/ExpansionHunter/wiki).


Method
------

The detailed description of the method can be found here:

Dolzhenko et al., [Detection of long repeat expansions from PCR-free whole-genome sequence data](http://genome.cshlp.org/content/27/11/1895), Genome Research 2017
