#!/usr/bin/perl

use strict;
use warnings;

my $vcf_file = $ARGV[0];
my $dp = $ARGV[1] || 20;
my $imf = $ARGV[2] || 0.85;
my $af1 = $ARGV[3] || 0.90;
my $rdp4 = $ARGV[4] || 0.80;

filter_vcf($vcf_file, $dp, $imf, $af1, $rdp4);

sub filter_vcf {
	my ($file, $dp, $af1) = @_;
	open (VCF, $file) or die $!;
	while (<VCF>) {
		chomp;
		next if /^\#/;
		my @w = split /\t/;
		my $info = $w[7];
		my $var = undef;
		$w[7] = '';
		if (is_indel($info)) {
			$var = parse_indel($info);
			next if ($var->{'DP'} < $dp);
			next if ($var->{'IMF'} < $imf);
			$w[7] = 'INDEL;IDV=' . $var->{'IDV'} . ';IMF=' . $var->{'IMF'} . ';';
		} else {
			$var = parse_snv($info);
			next if ($var->{'DP'} < $dp);
			next if ($var->{'AF1'} < $af1);
			my @dp4 = split /\,/, $var->{'DP4'};
			my $ratio = sum(@dp4)/$var->{'DP'};
			next if ($ratio < $rdp4);
		}
		$w[7] .= 'DP=' . $var->{'DP'} . ';AF1=' . $var->{'AF1'} . ';DP4=' . $var->{'DP4'};
		my $vcf_line = join "\t", @w;
		print $vcf_line . "\n";
	}
	return 1;
}

sub is_indel {
	my $info = shift;
	if ($info =~ /INDEL/) {
		return 1;
	} else {
		return 0;
	}
}

sub parse_indel {
	my $info =  shift;
	my %indel = ();
	my @f = split /\;/, $info;
	$indel{'IDV'} = 0;
	$indel{'IMF'} = 0;
	$indel{'DP'} = 0;
	$indel{'AF1'} = 0;
	$indel{'DP4'} = undef;
	foreach my $item (@f) {
		if ($item =~ /IDV\=(\S+)/) {
			$indel{'IDV'} = $1;
		}
		if ($item =~ /IMF\=(\S+)/) {
			$indel{'IMF'} = $1;
		}
		if ($item =~ /DP\=(\S+)/) {
			$indel{'DP'} = $1;
		}
		if ($item =~ /AF1\=(\S+)/) {
			$indel{'AF1'} = $1;
		}
		if ($item =~ /DP4\=(\S+)/) {
			$indel{'DP4'} = $1;
		}
	}
	return \%indel;
}

sub parse_snv {
	my $info =  shift;
	my %snv = ();
	my @f = split /\;/, $info;
	$snv{'DP'} = 0;
	$snv{'AF1'} = 0;
	$snv{'DP4'} = undef;
	foreach my $item (@f) {
		if ($item =~ /DP\=(\S+)/) {
			$snv{'DP'} = $1;
		}
		if ($item =~ /AF1\=(\S+)/) {
			$snv{'AF1'} = $1;
		}
		if ($item =~ /DP4\=(\S+)/) {
			$snv{'DP4'} = $1;
		}
	}
	return \%snv;
}

sub sum {
	my @array = @_;
	my $sum = 0;
	foreach my $num (@array) {
		$sum += $num;
	}
	return $sum;
}
