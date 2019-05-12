
# Set this to get error on \$CMD below:
set -o pipefail

#GITDIR=$PWD

# Create WSL compatible address: get physical path, then strip leading /mnt
GITDIR=$(pwd -P | sed 's?^/mnt??')
#GITDIR=$HOME/src/git/GIT_mjbright/cv_resume_42
#echo $GITDIR
#exit 1
#GITDIR="/mnt/c/tools/cygwin/home/windo/src/github.com/GIT_mjbright/resume_42/"

CHEAT=""
CHEAT="-v $GITDIR/scripts:/scripts -v $HOME/:/xlsx_dir"

die() {
    echo "$0: die - $*" >&2
    exit 1
}

INPUT_XLSX="CV.xlsx"
WWW_CV_XLSX="$HOME/z/www/mjbright.github.io/static/docs/src/CV.xlsx"

LANG=""

while [ ! -z "$1" ];do
    case $1 in
        -lang) shift; LANG="-lang $1";;
        FR) LANG="FR";;
	-www) set -- $WWW_CV_XLSX;;

        *)
            [ ! -f "$1" ] && die "No such file <$1>"
            cp -a "$1" CV_mine.xlsx
            INPUT_XLSX="CV_mine.xlsx"
	    ;;
    esac
    shift
done

which docker || die "No docker on path"

CMD="docker run --rm -it $CHEAT -v $GITDIR:/cv mjbright/cv_resume_42 bash /scripts/create_cv.sh -xl /cv/$INPUT_XLSX $LANG"

echo $CMD
#exit 1
$CMD 2>&1 | tee TEST.sh.log
RET=$?

echo "logfile:"
ls -altr TEST.sh.log

echo "exit $RET"
exit $RET


