#!/bin/bash

die() {
    echo "$0: die - $*" >&2
    exit 1
}

IMAGE=mjbright/cv_resume_42
#IMAGE=mjbright/slim_cv_resume_42

REPO_DIR=${PWD%/*} 
#cd ~/src/git/mjbright-resume42
cd $REPO_DIR

YEAR=$(date +%Y)

XLSX_DIR=~/z/Planning/$YEAR
XLSX=""

[ -d $XLSX_DIR ] && {
    XLSX=$(ls -tr $XLSX_DIR/*.xlsx | grep $YEAR | tail -1)
}

EXECUTE=1
[ ! -z "$1" ] && [ "$1" = "-n" ] && {
    EXECUTE=0
    shift
}

# Must be in local dir:
[ ! -z "$1" ] && {
    XLSX=$1
    XLSX_DIR=${XLSX%/*}
    [ "$XLSX_DIR" = "$XLSX" ] && XLSX_DIR=.
    #die "XLSX_DIR=$XLSX_DIR"
}

[ -z "$XLSX" ] && die "No Excel file specified/found"

[ ! -f $XLSX ] && die "No such Excel file as <<$XLSX>>"

# Need absolute PATH in volume path:
[ "$XLSX_DIR" = "." ] && XLSX_DIR=$PWD
XLSX_DIR=$(echo $XLSX_DIR | sed 's/\/\.\.\//\/$PWD\//')
#die "Using <<$XLSX_DIR>> as dir"

echo "Using <<$XLSX>> as input"

# map filename within
xlsx_dir=/xlsx_dir
xlsx=$xlsx_dir/${XLSX##*/}

#docker run --rm -it -v $PWD:/cv mjbright/cv_resume_42 bash
CMD="docker run --rm -it -v $XLSX_DIR:/xlsx_dir -v $PWD:/cv $IMAGE /cv/create_cv.sh -xl $xlsx"
echo; echo;

[ $EXECUTE -ne 0 ] && {
    echo $CMD
    $CMD;
    #docker run --rm -it -v $XLSX_DIR:/xlsx_dir -v $PWD:/cv $IMAGE /cv/create_cv.sh -xl $xlsx
    ls -al -tr result/*.pdf | tail -2;
} || {
    echo "NOT RUN:"
    echo "    "$CMD
}

