#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;

my $boss_file = shift or help();
my $age_file = shift or help();
my %data_1 		= ();
my @out_data	= ();
my @label = ('', '1st', '2nd', '3rd', '4th', '5th');

&read_boss($boss_file);

&totaling($age_file);

sub totaling {
	my ($f_name, $depth, $name, $boss_name, $age, $flg);
	my @ary = ();
	my %bosses = ();

	($f_name) = @_;

	unless (-e $f_name) {
	    die "$f_name not found";
	}

	open(FILE, $f_name) || die "can't open $f_name";
	while (<FILE>) {
		s/\r?\n$//;

		if (length > 1) {
			my ($name, $age) = split(/\t/, $_);
			
			if ($name ne '' && $age ne '') {
				if (exists($data_1{$name})) {
					$depth = $data_1{$name}{'depth'};
					$boss_name = $data_1{$name}{'boss'}
				} else {
					$depth = 0;
					$boss_name = '';
				}
				push(@ary, [ $name, $age, $boss_name, $depth]);
			}
		}
	}
	close(FILE);
	
	my @ary2 = sort { $b->[3] <=> $a->[3]} @ary;

	for (my $i=0; $i <= $#ary2; $i++) {
		$name = $ary2[$i][0];
		$boss_name = $ary2[$i][2];
		$age = $ary2[$i][1];
		
		if ($boss_name ne '') {
			my $child_total = 0;
			my $child_cnt = 0;
			if (exists($bosses{$name})) {
				if (exists($bosses{$name}[1])) {
					$child_cnt = $bosses{$name}[0];
					$child_total = $bosses{$name}[1];
				}
			}
			if (exists($bosses{$boss_name})) {
				$bosses{$boss_name}[0] = $bosses{$boss_name}[0] + 1 + $child_cnt;
				$bosses{$boss_name}[1] = $bosses{$boss_name}[1] + $age + $child_total;
				
			} else {
				$bosses{$boss_name}[0] = 1 + $child_cnt;
				$bosses{$boss_name}[1] = $age + $child_total;
				$bosses{$boss_name}[2] = 0;
			}
			
		}
		if (exists($bosses{$name})) {
			$bosses{$name}[2] = $age;
		}
	}
	while ( my ($key, $value) = each(%bosses) ) {
		$bosses{$key}[3] = $bosses{$key}[1] / $bosses{$key}[0];
	}
	
 	my @sorted_key = sort { 
 						$bosses{$b}[3] <=> $bosses{$a}[3] or 
 						$bosses{$b}[2] <=> $bosses{$a}[2] or 
 						$a cmp $b
 						} keys %bosses;
 	
 	my $num = 1;
 	for my $sorted_key (@sorted_key) {
 		next unless $num < 6; 
 		print $label[$num]. " ";
 		print $sorted_key;
		print "\n";
		$num++;
	}
}

sub read_boss {
	my $f_name;
	my %ary = ();

	($f_name) = @_;
	unless (-e $f_name) {
	    die "$f_name not found";
	}

	open(FILE, $f_name) || die "can't open $f_name";
	while (<FILE>) {
		s/\r?\n$//;

		if (length > 1) {
			my ($name, $boss) = split(/\t/, $_);
			
			if ($name ne '' && $boss ne '') {
				$ary{$name}{'boss'}	= $boss;
				$ary{$name}{'depth'} = 0;
			}
		}
	}
	close(FILE);

	%data_1 = %ary;
	
	while ( my ($key, $value) = each(%ary) ) {
		my $boss_name = $ary{$key}{'boss'};
 			my $depth = search_depth($boss_name);	
			$ary{$key}{'depth'} = $depth;
	}
}

sub search_depth {
	my $depth = 0;
	my ($name) = @_;
	
	if (exists($data_1{$name})) {
		my $boss_name = $data_1{$name}{'boss'};
		$depth = search_depth($boss_name) + 1;
	
	} else {
		$depth = 1;
	}
	
	return $depth;
}

sub help{
    die "$0 boss_file age_file\n";
}
