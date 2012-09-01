#!/usr/bin/perl

use strict;
use warnings;

my $result;

$result = &numchk("0.001");
print "結果は$result\n";

sub numchk {
	my ($item, $item_s, $ret);	
	
	($item) = @_;
	$item_s = $item;
	$ret = 1;
	
	unless($item eq '') {
		
		# カンマを除去
		$item_s =~ s/,//g;
		# print $item_s. "\n";
		
		# 頭文字チェック
		if ($item_s =~ /^([1-9+-][0-9]|[0-9][.])/) {
			#位取りチェック
			if ($item =~ /,/) {
				$item =~ s/^[+-]//;
				if ($item =~ /^\d{1,3}(?:,\d{3})+/) {
				} else {
					$ret = 0;
				}
			}
		} else {
			$ret = 0;
		}
	}
	
	return $ret;
}