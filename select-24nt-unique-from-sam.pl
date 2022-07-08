#! usr/bin/perl 
#usage:perl scripts.pl file_rm.sam 
#ÊäÈëÎÄ¼þ1£ºfile_rm.sam
#   0									1	 2		 3		4	5	6	7	8					9										10
#K00137:241:H7T3KBBXX:1:1101:5467:1332	0	Chr9	8450	255	44M	*	0	0	CTTTGTGAAATGACTTGAGAGGTGTAGGATAAGTTGGAGCCCTC	A<FAFJJJFJF<FFAFFJJJJJAAFJFFAA---7-7A<77<F)7	X
#A:i:1	MD:Z:34G9	NM:i:1
##############################################################################
%hash=();
open(F1,$ARGV[0]) or die "$!";
while(my $line=<F1>){
	chomp $line;
	my @arr=split/\t/,$line;
	$hash{$arr[0]}+=1;
	}
	close F1;
######################################################################################
open(F1,$ARGV[0]) or die "$!";
@name=split/\_/,$ARGV[0];
open(OUT,">$name[0]_24_unique.sam") or die "$!";
while(my $line=<F1>){
	chomp $line;
	my @arr=split/\t/,$line;
		if($arr[0]=~/@/){
			print OUT $line,"\n";
				}else{
					if(($hash{$arr[0]}==1)&& (length$arr[9]==24)){
						print OUT $line,"\n";
				}
			}
		}
	close F1;
	close OUT;