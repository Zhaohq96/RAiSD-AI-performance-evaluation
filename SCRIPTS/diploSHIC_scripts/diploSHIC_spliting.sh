#!/bin/bash

echo split training sets
split_pointN=$(cat $1/temp/temp1.txt | wc -l);
a=$[($((split_pointN))-1)/5];
echo $a
head -1 $1/temp/temp1.txt >> head1.txt;
sed -i '1d' $1/temp/temp1.txt;
split -l $a $1/temp/temp1.txt -d -a 1 neut_;
cat head1.txt neut_0 neut_1 neut_2 neut_3 >> $1/training/neut.fvec;
cat head1.txt neut_4 >> $1/testing/neut.fvec;

split_pointH=$(cat $1/temp/temp2.txt | wc -l);
b=$[($((split_pointH))-1)/5];
echo $b
head -1 $1/temp/temp2.txt >> head2.txt;
sed -i '1d' $1/temp/temp2.txt;
split -l $b $1/temp/temp2.txt -d -a 1 hard_;
cat head2.txt hard_0 hard_1 hard_2 hard_3 >> $1/training/hard.fvec;
cat head2.txt hard_4 >> $1/testing/hard.fvec;

rm neut_*;
rm head1.txt;
rm hard_*;
rm head2.txt;
echo done
