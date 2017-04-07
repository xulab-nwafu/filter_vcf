#!/usr/bin/perl

use strict;
use warnings;

my $vcf_file = $ARGV[0];
my $dp = $ARGV[1] || 20;
my $af1 = $ARGV[2] || 0.9;

filter_vcf($vcf_file, $dp, $af1);

sub filter_vcf {
	my ($file, $dp, $af1) = @_;
	open (VCF, $file) or die $!;
	while (<VCF>) {
		chomp;
		next if /^\#/;
		my @w = split /\t/;
		my @f = split /\;/, $w[7];
		my $this_dp = 0;
		my $this_af1 = 0;
		my $this_dp4 = undef;
		foreach my $item (@f) {
			if ($item =~ /DP\=(\S+)/) {
				$this_dp = $1;
			}
			if ($item =~ /AF1\=(\S+)/) {
				$this_af1 = $1;
			}
			if ($item =~ /DP4\=(\S+)/) {
				$this_dp4 = $1;
			}
		}
		if ($this_dp >= $dp and $this_af1 >= $af1) {
			$w[7] = 'DP=' . $this_dp . ';AF1=' . $this_af1 . ';DP4=' . $this_dp4;
			my $vcf_line = join "\t", @w;
			print $vcf_line . "\n";
		}
	}
	return 1;
}
