#!/bin/bash

#pdflatex=/c/Progs/texlive/2015/bin/win32/pdflatex.exe
pdflatex=/usr/bin/pdflatex

# By default: use CV.xlsx in local directory
MYCV_XL=CV.xlsx

########################################
# Functions:
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

########################################
# Args:

while [ ! -z "$1" ];do
    case $1 in
        -xl) shift; MYCV_XL=$1;;
    esac
    shift
done

########################################
# Main:

cd ${0%/*}

## Check $MYCV_XL file exists:
[ ! -f $MYCV_XL ] && die "No such Excel file: '$MYCV_XL'"

## Create CSV file from XL:
echo; echo "-- Creating csv from xlsx file [$MYCV_XL - Worksheet 'CV']"
./xsl2csv.py $MYCV_XL CV op.csv

## Create YAML file from CSV:
echo; echo "-- Creating yaml from csv file"
./csv2yaml.py op.csv cv.yaml
res=$?

ls -altr cv.yaml
[ $res -ne 0 ] && die "Failed to create yaml file"

## Create LATEX file from YAML:
echo; echo "-- Creating latex from yaml file"
./cv_tex.py cv.yaml resume.tmpl.tex resume-section.tmpl.tex result/cv.tex
res=$?

ls -altr result/cv.tex
[ $res -ne 0 ] && die "Failed to create latex file"


## Create PDF file from LATEX:
echo; echo "-- Creating pdf from latex file"
cd result
[ -f ./cv.pdf ] && mv -v ./cv.pdf ./cv.old.pdf

DT=$(date +'%G-%m-%d_%Hh%Mm')

BASE=cv_${DT}
cp cv.tex ${BASE}.tex

$pdflatex ${BASE} 
res=$?

ls -altr $PWD/${BASE}.pdf
[ $res -ne 0 ] && die "Failed to create pdf file"

cp -a $PWD/${BASE}.pdf $PWD/cv.pdf





