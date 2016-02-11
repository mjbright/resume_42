#!/bin/bash

pdflatex=/c/Progs/texlive/2015/bin/win32/pdflatex.exe

press() {
    echo $*
    echo "Press <return> to continue"
    read _DUMMY

    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

die() {
    echo "$0: die - $*" >&2
    exit 1
}

#echo ${0%/*}

cd ${0%/*}

echo; echo "-- Creating csv from xlsx file"
./xsl2csv.py d:/z/Dropbox/z/Planning/2016/2016-02.xlsx CV op.csv

echo; echo "-- Creating yaml from csv file"
./csv2yaml.py op.csv cv.yaml
res=$?
ls -altr cv.yaml
[ $res -ne 0 ] && die "Failed"
#echo "-- exit 0 "
#exit 0

echo; echo "-- Creating latex from yaml file"
./cv_tex.py 
res=$?
ls -altr result/cv.tex
[ $res -ne 0 ] && die "Failed"


echo; echo "-- Creating pdf from latex file"
cd result
[ -f ./cv.pdf ] && mv -v ./cv.pdf ./cv.old.pdf

DT=$(date +'%G-%m-%d_%Hh%Mm')

BASE=cv_${DT}
cp cv.tex ${BASE}.tex

$pdflatex ${BASE} 
res=$?
ls -altr $PWD/${BASE}.pdf
[ $res -ne 0 ] && die "Failed"

#press "About to 'open cv.pdf'"
#open cv.pdf




