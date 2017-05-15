#!/bin/bash

[ "$1" = "-x" ] && { set -x; shift; }
# set -x

ls -altr /

tree /scripts/

ls -altr /cv/
tree /cv/

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

CSV=/cv/result/cv.csv
YAML=/cv/result/cv.yml

function run_cmd {
    CMD="$*"

    echo "[$PWD] $CMD"
    $CMD
    res=$?
    #[ $res -ne 0 ] && die "Failed to create csv file"
    #[ $res -ne 0 ] && die "Failed last step"
}

## Check $MYCV_XL file exists:
[ ! -f $MYCV_XL ] && die "No such Excel file: '$MYCV_XL'"

## Create CSV file from XL:
echo; echo "-- Creating csv from xlsx file [$MYCV_XL - Worksheet 'CV']"
run_cmd "./xsl2csv.py $MYCV_XL CV $CSV"
[ $res -ne 0 ] && die "Failed to create csv file"

## Create YAML file from CSV:
echo; echo "-- Creating yaml from csv file"
run_cmd "./csv2yaml.py $CSV $YAML"
ls -altr $CSV $YAML
[ $res -ne 0 ] && die "Failed to create yaml file"

## Create LATEX file from YAML:
echo; echo "-- Creating latex from yaml file"
ls -altr /cv/template/
#ARGS="$YAML /cv/template/resume.tmpl.tex /cv/template/resume-section.tmpl.tex /cv/result/cv.tex"
ARGS="$YAML resume.tmpl.tex resume-section.tmpl.tex /cv/result/cv.tex"
ls -altr $ARGS
run_cmd "./cv_tex.py $ARGS"
ls -altr /cv/result/cv.tex
[ $res -ne 0 ] && die "Failed to create tex file"

## Create PDF file from LATEX:
echo; echo "-- Creating pdf from latex file"
cd /cv/result
[ -f ./cv.pdf ] && mv -v ./cv.pdf ./cv.old.pdf

DT=$(date +'%G-%m-%d_%Hh%Mm')

BASE=cv_${DT}
cp cv.tex ${BASE}.tex

run_cmd "$pdflatex ${BASE} "
ls -altr $PWD/${BASE}.pdf
[ $res -ne 0 ] && die "Failed to create pdf file"

run_cmd "cp -a $PWD/${BASE}.pdf $PWD/cv.pdf"
echo "$CMD"
$CMD





