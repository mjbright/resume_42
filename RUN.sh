

GITDIR=$PWD
#GITDIR=$HOME/src/git/GIT_mjbright/cv_resume_42

CHEAT="-v $GITDIR/scripts:/scripts"

INPUT_XLSX="CV.xlsx"
if [ ! -z "$1" ];then
    cp -a "$1" CV_mine.xlsx
    INPUT_XLSX="CV_mine.xlsx"
fi

CMD="docker run --rm -it $CHEAT -v $HOME/:/xlsx_dir -v $GITDIR:/cv mjbright/cv_resume_42 bash /scripts/create_cv.sh -xl /cv/$INPUT_XLSX"

echo $CMD
$CMD 2>&1 | tee TEST.sh.log

