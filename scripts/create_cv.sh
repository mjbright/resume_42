#!/bin/bash

set -x

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

CV_LANG=""
LANG_PREFIX=""

while [ ! -z "$1" ];do
    case $1 in
        -x) set -x;;

        -xl) shift; MYCV_XL=$1;;

	-lang) shift; CV_LANG=$1; LANG_PREFIX=".${CV_LANG}";;

	*) die "Unknown option <$1>";;
    esac
    shift
done

CV_BASE=cv${LANG_PREFIX}

DT=$(date +'%G-%m-%d_%Hh%Mm')

mkdir -p /cv/result/dated
CV_BASE_DT=${CV_BASE}.${DT}


# Default: English, values are from Column 'D' of spreadsheet:
VALUE_COL="D"
VALUE_COL_NUM="3"

case $CV_LANG in
    "FR") VALUE_COL="F"; VALUE_COL_NUM="5";;

    "")   VALUE_COL="D"; VALUE_COL_NUM="3";;

    *) die "Unknown language option <$CV_LANG>";;
esac

########################################
# Main:

# set -x

#ls -altr /
tree /scripts/ 

ls -altr /cv/
tree -L 2 /cv/
#tree /cv/ | grep -v results/dated

cd ${0%/*}

CSV=/cv/result/cv.csv
YAML=/cv/result/${CV_BASE}.yml

function RUN {
    CMD="$*"

    echo "[$PWD] ---- $CMD"
    $CMD
    res=$?
    #[ $res -ne 0 ] && die "Failed to create csv file"
    #[ $res -ne 0 ] && die "Failed last step"
}

## Check $MYCV_XL file exists:
[ ! -f $MYCV_XL ] && die "No such Excel file: '$MYCV_XL'"

## Create CSV file from XL:
echo; echo "-- Creating csv(all columns) from xlsx file [$MYCV_XL - Worksheet 'CV']"
RUN "./xsl2csv.py $MYCV_XL CV $CSV"
[ $res -ne 0 ] && die "Failed to create csv file"

## Create YAML file from CSV:
echo; echo "-- [CV_LANG=$CV_LANG] Creating yaml from csv file [values from col $VALUE_COL (# $VALUE_COL_NUM)]"
RUN "./csv2yaml.py $CSV $YAML $VALUE_COL_NUM"

ls -altr $CSV $YAML
[ $res -ne 0 ] && die "Failed to create yaml file"

## Create LATEX file from YAML:
echo; echo "-- [CV_LANG=$CV_LANG] Creating latex from yaml file"
ls -altr /cv/template/
#ARGS="$YAML /cv/template/resume.tmpl.tex /cv/template/resume-section.tmpl.tex /cv/result/cv.tex"
ARGS="$YAML resume.tmpl.tex resume-section.tmpl.tex /cv/result/${CV_BASE}.tex"

#ls -altr $ARGS
ls -altr /cv/template/resume.tmpl.tex /cv/template/resume-section.tmpl.tex /cv/result/${CV_BASE}.tex
RUN "./cv_tex.py $ARGS"

echo "AFTER[PWD=$PWD]: RUN './cv_tex.py $ARGS'"
ls -altr /cv/result/${CV_BASE}.tex
[ $res -ne 0 ] && die "Failed to create tex file"

## Create PDF file from LATEX:
echo; echo "-- [CV_LANG=$CV_LANG] Creating pdf from latex file"
cd /cv/result
[ -f ./${CV_BASE}.pdf ] && mv -v ./${CV_BASE}.pdf ./${CV_BASE}.old.pdf

cp ${CV_BASE}.tex ${CV_BASE_DT}.tex

#RUN "$pdflatex ${CV_BASE_DT}.pdf"
RUN "$pdflatex ${CV_BASE_DT}"
#RUN "$pdflatex ${CV_BASE}"

#echo "AFTER[PWD=$PWD]: RUN '$pdflatex ${CV_BASE}'"
echo "AFTER[PWD=$PWD]: RUN '$pdflatex ${CV_BASE_DT}'"
#echo "AFTER[PWD=$PWD]: RUN '$pdflatex ${CV_BASE_DT}.pdf'"
#echo "AFTER[PWD=$PWD]: RUN '$pdflatex ${CV_BASE_DT}.pdf'"
ls -altr ./${CV_BASE_DT}.pdf
[ $res -ne 0 ] && die "Failed to create pdf file"

#RUN "cp -a ./${CV_BASE_DT}.pdf ./${CV_BASE}.pdf"
RUN "cp -a ./${CV_BASE_DT}.pdf ./${CV_BASE}.pdf"
RUN "mv    ./${CV_BASE_DT}.* dated/"
#echo "$CMD"
#$CMD





