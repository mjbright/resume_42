#!/bin/bash

#pdflatex=/c/Progs/texlive/2015/bin/win32/pdflatex.exe

# By default: use CV.xlsx in local directory
## MYCV_XL=CV.xlsx
## MONTH=$(date +%04Y-%02m)
## PLANNING_DIR='d:/z/Dropbox/z/Planning/2016/'
## MYCV_XL="${PLANNING_DIR}/${MONTH}.xlsx"
MYCV_XL=/vagrant/CV.xlsx

./create_cv.sh -xl $MYCV_XL

