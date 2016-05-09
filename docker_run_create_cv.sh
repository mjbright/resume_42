#!/bin/bash

die() {
    echo "$0: die - $*" >&2
    exit 1
}

cd ~/src/git/mjbright-resume_42

YEAR=$(date +%Y)

XLSX_DIR=~/z/Planning/$YEAR
XLSX=""

[ -d $XLSX_DIR ] && {
    XLSX=$(ls -tr $XLSX_DIR/*.xlsx | grep $YEAR | tail -1)
}

# Must be in local dir:
[ ! -z "$1" ] && {
    XLSX=$1
    XLSX_DIR=${XLSX%/*}
}

[ -z "$XLSX" ] && die "No Excel file specified/found"

[ ! -f $XLSX ] && die "No such Excel file as <<$XLSX>>"

echo "Using <<$XLSX>> as input"

# map filename within
xlsx_dir=/xlsx_dir
xlsx=$xlsx_dir/${XLSX##*/}

#docker run --rm -it -v $PWD:/cv mjbright/cv_resume_42 bash
docker run --rm -it -v $XLSX_DIR:/xlsx_dir -v $PWD:/cv mjbright/cv_resume_42 /cv/create_cv.sh -xl $xlsx

ls -al -tr result/*.pdf | tail -2

