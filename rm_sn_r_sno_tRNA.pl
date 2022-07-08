#! usr/bin/perl 
#在利用bowtie进行比对产生SAM文件后，去除snRNA、rRNA、snoRNA和tRNA
#usage:perl scripts.pl file_all_con.sam 
#运行时自动调用四个文件file_snRNA.sam file_rRNA.sam file_snoRNA.sam file_tRNA.sam
#######################################################################################################################
my @name=split/\_all/,$ARGV[0]; #
$ARGV[1]=$name[0]."_rRNA.sam";
$ARGV[2]=$name[0]."_tRNA.sam";
$ARGV[3]=$name[0]."_snRNA.sam";
$ARGV[4]=$name[0]."_snoRNA.sam";
$i=1;%hash=();
while($i<=$#ARGV){
	open (F1,$ARGV[$i]) or die "$!";
	while(my $line=<F1>){
		chomp $line;
		my @arr=split/\t/,$line;
		if ($arr[1]==0){
			$hash{$arr[0]}=1;
		}
	}
	close F1;
	$i+=1;
}
######################################################################################################################
$name_1=$name[0]."_rm.sam";                      
$name_2=$name[0]."_rm_report.txt";             
$warm=$name[0]."_warm.txt";                      
######################################################################################################################
open (F0,$ARGV[0]) or die "$!";
open (OUTPUT,">$name_1");  
while(my $line=<F0>){
	chomp $line;
	if ($line=~/\A@/){
		print OUTPUT $line,"\n";
	}else{
		my @arr=split/\t/,$line;
		if($arr[1]!=4){            
			$map{$arr[0]}=0;
			if(!(exists $hash{$arr[0]})){
				print OUTPUT $line,"\n";
				$retain{$arr[0]}=0;  
				$length{$arr[0]}=length($arr[9]);   
				$count{length($arr[9])}=0;
			}
		}	
	}
}	
close OUTPUT;
close F0;
######################################################################################################################
open (REPORT,">$name_2");
@map=keys %map;            
@retain=keys %retain;     
$map=$#map+1; 
$retain=$#retain+1;
print REPORT "perl rm_sn_r_sno_tRNA.pl ",$ARGV[0]," ",$ARGV[1]," ",$ARGV[2]," ",$ARGV[3]," ",$ARGV[4],"\n";
print REPORT "total reads mapped to the genome:","	",$map,"\n";
print REPORT "total reads removed:","	",$map-$retain,"\n";
print REPORT "total reads reported to the output .sam file:","	",$retain,"\n";
######################################################################################################################
$total=0;
@key=sort(keys %count);
@value=sort(values %length);
print REPORT "\n";
print REPORT "Reads length distribution:","\n";
print REPORT "length	read_number","\n";  
foreach $key(@key){
	$count=0;
	foreach $value(@value){
		if ($value==$key){
			$count+=1;
		}
	}
	print REPORT $key,"	",$count,"	",$count/$retain,"\n";
	$total+=$count;
}
print REPORT "total","	",$total,"	","1","\n";
close REPORT;
########################################################################################################################
if ($total !=$retain){
	open (WARM,">$warm");
	print WARM "Please pay attention to reads count,there may be something wrong","\n";
	close WARM;
}
########################################################################################################################