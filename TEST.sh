CMD="docker run --rm -it -v /home/mjb/:/xlsx_dir -v /home/mjb/src/git/mjbright/resume_42:/cv mjbright/cv_resume_42 /scripts/create_cv.sh -xl /cv/CV_2016-12.xlsx"

echo $CMD
$CMD 2>&1 | tee TEST.sh.log

