
INPUT=CV.xlsx

[ ! -z "$1" ] && {
    INPUT=${1##*/}
    #[ "$1" != "$INPUT" ] && cp -a $1 $INPUT
}

#exit 0
ls -altr cv.pdf

echo
echo "Run docker container to create new cv.pdf"
DOCKER_CMD="sudo docker run --rm -it -v $PWD:/xlsx_dir -v $PWD:/cv mjbright/cv_resume_42 /cv/create_cv.sh -xl $INPUT"
echo $DOCKER_CMD
$DOCKER_CMD >/dev/null

ls -altr cv.pdf

#ls -altr result/

echo
echo "Upload cv.pdf to github"
echo "Press <return> to continue"
read _DUMMY

cp -a result/cv.pdf ../mjbright.github.io/cv.pdf
#cp -a result/cv_2016-05-31_17h33m.pdf ../mjbright.github.io/cv.pdf
cd ../mjbright.github.io/
git add cv.pdf 
git commit -m "Adding cv" 
git push


