#! usr/bin/perl
#�õ�bed�ļ��󣬸���fastq�ļ���bed�ļ��������ձ������׼�����map�ļ�
#usage:perl scripts.pl file_sorted.bed file.fastq
#�������1���ļ�file_map.txt
#sRNA�������׼��ΪRPTM

#����ļ���ʽ��
#�ļ�1��file_map.txt
#0��Chr1    1��+    2��1001    3��1023     4��hits=493  
#5��CTAAACCCTAAACCCTAAACCCT(��Ϊ��������ʾ��read_sequence������ID��Ӧԭʼread���еķ��򻥲�����)
#6: 23     7: CTAAACCCTAAACCCTAAACCCT(��ʾ����fastq��ԭʼ��read����) 
#8��read=6   9����׼����ı����
#����ID����ͬ
#####################################################################################
#�����ļ���ʽ��
#�ļ�1��(BED�ļ�ʾ����  �ļ����磺file_sorted.bed
#��ע��0   1       2                      3                               4      5
#Chr1    54263   54287   HWI-ST979:160:D1ABHACXX:3:1101:17711:2278       255     -
#Chr1    82001   82022   HWI-ST979:160:D1ABHACXX:3:1101:10497:4263       255     +
#�ļ�2����fastq�ļ����ļ����磺file.fastq
#@HWI-ST979:160:D1ABHACXX:7:1101:1978:2223 1:N:0:ATCACG
#CCCCGCGTCGCACGGATTCGT
#+
#@@@;DA<@FF6D8D@:@DFG9
#####################################################################################
open (FASTQ,$ARGV[1]) or die "$!";
$i=0;%ID_seq=();%seq_IDnumber=();%seq_ID=();
while (my $line=<FASTQ>){
	chomp $line;
	$i+=1;
	if ($i%4==1){
		my @name=split/\s+/,$line;
		$ID=substr($name[0],1);
	}else{
		if ($i%4==2){
			$ID_seq{$ID}=$line;
			$seq_IDnumber{$line}+=1;
			$seq_ID{$line}=$ID;
		}
	}
}
close FASTQ;
#####################################################################################
%ID_hits=();%hash=();
open (F1,$ARGV[0]) or die "$!";
while (my $line=<F1>){
	chomp $line;
	my @arr=split/\t/,$line;
	$ID_hits{$arr[3]}+=1;
	$hash{$arr[3]}=1;
}
close F1;
@key=keys %hash;
$library_size=$#key+1;
$factor=$library_size/10000000;
%hash=();
#####################################################################################��
@temp=split/sorted/,$ARGV[0];
$map=$temp[0]."map.txt";
######################################################################################
open (F1,$ARGV[0]) or die "$!";
open (MAP,">$map") or die "$!";
while (my $line=<F1>){
	chomp $line;
	my @arr=split/\t/,$line;
	if($seq_ID{$ID_seq{$arr[3]}} eq $arr[3]){
		print MAP $arr[0],"\t",$arr[5],"\t",$arr[1]+1,"\t",$arr[2],"\t","hits=",$ID_hits{$arr[3]},
			"\t";
		if($arr[5] eq "-"){
			print MAP &reverse_complement($ID_seq{$arr[3]}),"\t";
		}else{
			print MAP $ID_seq{$arr[3]},"\t";
		}
		print MAP length($ID_seq{$arr[3]}),"\t",$ID_seq{$arr[3]},"\t","read=",$seq_IDnumber{$ID_seq{$arr[3]}},"\t";
		print MAP $seq_IDnumber{$ID_seq{$arr[3]}}/$ID_hits{$arr[3]}/$factor,"\n";
	}
}
close MAP;
close F1;
######################################################################################
sub reverse_complement{
	my $var=undef;
	$i=length($_[0])-1;
	while($i>=0){
		$var.=substr($_[0],$i,1);
		$i-=1;
	}
	$var=~s/A/X/gi;
	$var=~s/T/Y/gi;
	$var=~s/C/Z/gi;
	$var=~s/G/W/gi;
	$var=~s/X/T/gi;
	$var=~s/Y/A/gi;
	$var=~s/Z/G/gi;
	$var=~s/W/C/gi;
	return $var;
}
######################################################################################