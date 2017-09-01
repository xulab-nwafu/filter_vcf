#!/bin/bash

usage () {
	echo "Usage: $0 ref.vcf var.vcf"
	echo " e.g.: $0 WT.vcf MU.vcf"
	exit 1
}

if [ $# != 2 ] ; then
	usage
fi

if [ $1 == "-h" ] ; then
	usage
fi

ref=$1
var=$2

if [ ! -f $ref ]; then
	echo "Reference VCF file ($ref) does not exist."
	usage
fi

if [ ! -f $var ]; then
	echo "Mutant VCF file ($var) does not exist."
	usage
fi

# Use bcftools to subtract background
bgzip $ref
bgzip $var
bcftools index $ref.gz
bcftools index $var.gz
echo "Removing background variants in wild-type ..."
bcftools isec $ref.gz $var.gz -p filtered
# Restore original VCF file
gunzip $ref.gz $var.gz
rm -rf $ref.gz.csi $var.gz.csi

# Use filter_vcf.ss.pl to filter and annotate VCF file
filter_vcf.ss.pl filtered/0001.vcf
mv ${PWD}/filtered/0001.filtered.ann.vcf ${PWD}/sector.vcf

echo "Done."
echo "Filtered VCF file is available at ${PWD}/sector.vcf"
