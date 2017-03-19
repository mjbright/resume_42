

GITDIR=$PWD
#GITDIR=$HOME/src/git/GIT_mjbright/cv_resume_42

CHEAT="-v $GITDIR/scripts:/scripts -v $HOME/:/xlsx_dir"
CHEAT=""

die() {
    echo "$0: die - $*" >&2
    exit 1
}

INPUT_XLSX="CV.xlsx"
if [ ! -z "$1" ];then
    [ ! -f "$1" ] && die "No such file <$1>"

    cp -a "$1" CV_mine.xlsx
    INPUT_XLSX="CV_mine.xlsx"
fi

CMD="docker run --rm -it $CHEAT -v $GITDIR:/cv mjbright/cv_resume_42 bash /scripts/create_cv.sh -xl /cv/$INPUT_XLSX"

echo $CMD
$CMD 2>&1 | tee TEST.sh.log

