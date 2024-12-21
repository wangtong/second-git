#!/usr/bin/perl 
if (@ARGV !=3) { 
    die "This program is used to get tRNA sequence
    Usage:perl $0  <tRNAScan.out> <genome.fasta> <result>\n";
}

open(A,"$ARGV[1]") ;

while (<A>) {
    chomp;
    $_=~s/[^ACGTNX\d]$//gi;
    if($_=~/^>/){
        @temp=split;

        $temp[0]=~s/^>//;
        $name=$temp[0];

    }else{
        $genome_seq{$name}.=$_;
    }

}
close(A);

open(A,"$ARGV[0]") ;
open O,">$ARGV[2]";
$flag=0;
while (<A>) {
    chomp;
    if($_=~/^\-\-\-\-\-/){
        $flag=1;
    }else{
        if($flag==1){
            @temp=split;

            if($temp[2]<$temp[3]){
                $trna=uc(substr($genome_seq{$temp[0]},$temp[2]-1,$temp[3]-$temp[2]+1));
                $trna=~s/(.{50})/$1\n/g;
                print O ">$temp[0]_tRNA$temp[1] $temp[2] $temp[3] $temp[4] $temp[5]\n$trna\n";

            }else{
                $trna=reverse(uc(substr($genome_seq{$temp[0]},$temp[3]-1,$temp[2]-$temp[3]+1)));
                $trna=~tr/ACGT/TGCA/;
                $trna=~s/(.{50})/$1\n/g;
                print O ">$temp[0]_tRNA$temp[1] $temp[2] $temp[3] $temp[4] $temp[5]\n$trna\n";
            }
        }
    }


}

close(A);
close O;
