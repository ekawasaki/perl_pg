#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;

my $file1 = shift or help();
my $file2 = shift or help();
my %data_1 		= ();
my @out_data	= ();

&read_file1($file1);
&file_match($file2);

#print Dumper(\@out_data);

&dsp_out(*out_data);

sub dsp_out {
	(*out_data) = @_;

	my $fmt = "%s\t%s\t%s\t%s\t%s\t%s\t%s\n";

	printf($fmt, 'id', 'name', 'email', 'address', 'gender', 'age','order');

	for (my $i=0; $i <= $#out_data; $i++) {
		printf($fmt,
					$out_data[$i][0],
					$out_data[$i][1],
					$out_data[$i][2],
					$out_data[$i][3],
					$out_data[$i][4],
					$out_data[$i][5],
					$out_data[$i][6]
					);
	}
}

sub read_file1 {
	my ($f_name, $line);
	($f_name) = @_;
	$line = 0;

	unless (-e $f_name) {
	    die "$f_name not found";
	}

	open(FILE, $f_name) || die "can't open $f_name";
	while (<FILE>) {
		# コード除去
		s/\r?\n$//;

		if (length > 1) {
			my ($id, $name, $email, $address) = split(/\t/, $_);
			if ($line > 0) {
				$data_1{$id}{'name'}	= $name; 
				$data_1{$id}{'email'}	= $email;
				$data_1{$id}{'address'}	= $address;
			}
		}
		$line++;
	}
	close(FILE);
}

sub file_match {
	my $f_name;
	my $line = 0;
	my @ary = ();

	($f_name) = @_;

	unless (-e $f_name) {
	    die "$f_name not found";
	}


	open(FILE, $f_name) || die "can't open $f_name";
	while (<FILE>) {
		# コード除去
		s/\r?\n$//;

		if (length > 1) {
			my ($id, $gender, $age, $order) = split(/\t/, $_);
			if ($line > 0) {
				if ($order =~ /^[1-9][0-9]*$/) {
					if (exists($data_1{$id})) {
						push(@ary, [
							$id,
							$data_1{$id}{'name'},
							$data_1{$id}{'email'},
							$data_1{$id}{'address'},
							$gender,
							$age,
							$order
						]
					);
					};
				} else {
					my $l_num = $line + 1;
					die "$id, $l_num\n";
				}
			}
		}
		$line++;
	}
	close(FILE);
	
	@out_data = sort { $b->[6] <=> $a->[6] or $a->[0] <=> $b->[0]} @ary;
}

sub help{
    die "$0 file1 file2\n";
}
