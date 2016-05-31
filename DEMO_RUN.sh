
INPUT=CV.xlsx

[ ! -z "$1" ] && INPUT=$1


DOCKER_CMD="docker run --rm -it -v $PWD:/xlsx_dir -v $PWD:/cv mjbright/cv_resume_42 /cv/create_cv.sh -xl $INPUT"
echo $DOCKER_CMD
$DOCKER_CMD

#ls -altr result/

cp -a result/cv.pdf ../mjbright.github.io/cv.pdf
#cp -a result/cv_2016-05-31_17h33m.pdf ../mjbright.github.io/cv.pdf
cd ../mjbright.github.io/
git add cv.pdf 
git commit -m "Adding cv" 
git push


