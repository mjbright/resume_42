#!/bin/bash

pdflatex=/c/Progs/texlive/2015/bin/win32/pdflatex.exe

press() {
    echo $*
    echo "Press <return> to continue"
    read _DUMMY

    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}



#echo ${0%/*}

cd ${0%/*}

ls -altr cv.yaml

echo; echo "-- Creating latex from yaml file"
./cv_tex.py 

ls -altr result/cv.tex


echo; echo "-- Creating pdf from latex file"
cd result
$pdflatex cv.tex 

ls -altr $PWD/cv.pdf

#press "About to 'open cv.pdf'"
#open cv.pdf




