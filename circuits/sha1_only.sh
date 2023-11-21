#!/bin/bash

# MAKE SURE THAT ./run_experiment_pipe_auto.sh runs the experiments 7 times (* 10000)

if [ -d $1 ]
then
    echo "Directory exists!"
    exit
fi

mkdir -pv $1


./compile.sh

echo 10000 > REP
echo 13 > DELAY

echo "prefetch" > PREFETCH
mkdir -pv $1/SHA1_PREFETCH

./run_experiment_pipe_auto.sh $1/SHA1_PREFETCH 0 sha1 0 $(cat REP)

mkdir -pv $1/SHA1_PREFETCH/RESULT

cat $1/SHA1_PREFETCH/* | grep "SHA1 Acc*" | grep "(.*)" -o | sed "s/(//g" | sed "s/)//g" > $1/SHA1_PREFETCH/RESULT/all.csv
cat $1/SHA1_PREFETCH/RESULT/all.csv | datamash median 1 > $1/SHA1_PREFETCH/RESULT/ALL_MEDIAN
cat $1/SHA1_PREFETCH/RESULT/all.csv | datamash mean 1 > $1/SHA1_PREFETCH/RESULT/ALL_MEAN

cat $1/SHA1_PREFETCH/* | grep "SHA1 Acc*" | grep "(.*)" -o | sed "s/(//g" | sed "s/)//g" | shuf -n 10000 > $1/SHA1_PREFETCH/RESULT/final.csv
cat $1/SHA1_PREFETCH/RESULT/final.csv | datamash median 1 > $1/SHA1_PREFETCH/RESULT/FINAL_MEDIAN
cat $1/SHA1_PREFETCH/RESULT/final.csv | datamash mean 1 > $1/SHA1_PREFETCH/RESULT/FINAL_MEAN
