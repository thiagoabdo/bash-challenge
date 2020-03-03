#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $filename = '/tmp/output_1.txt';

open(FH, '<', $filename) or die $!;
my @o_lines;
my $max_ip_size = 0;
my $max_host_size = 0;
while(<FH>){
	my $line = $_;
	$line =~ s/\t/ /g;
	$line =~ s/\r//g;
	if ($line =~ /^\d/){
		$line =~ s/ +/ /g;

		my @split_line = split ' ', $line;
		my $length = length $split_line[0];
		if ($length > $max_ip_size){
			$max_ip_size = $length;
		}
		$length = length $split_line[1];
		if ($length > $max_host_size){
			$max_host_size = $length;
		}
	}
	push @o_lines, $line;
}
close(FH);

open(FH, '>', '/tmp/output_2.txt');
foreach(@o_lines){
	my $line = $_;
	if ($line =~ /^[\d\-]/){
		chomp($line);
		my @first_split = split '#', $line, 2;
		my @split_line = split ' ', $first_split[0]; 
		my $length = length $split_line[0];
		$split_line[0] .= (" " x ($max_ip_size - length($split_line[0])));
		$split_line[1] .= (" " x ($max_host_size - length($split_line[1])));
		$first_split[0] = join("   ", @split_line);
		$line = join('    #', @first_split);
		$line .= "\n"
	}
	print FH $line;
}
close(FH);
