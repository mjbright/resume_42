
die() {
    echo "$0: die - $*" >&2
    exit 1
}

echo; echo "---- build image: ----"
docker build -t mjbright/cv_resume_42 .  || die "Build failed"

echo; echo "---- login to DockerHub ----"
docker login -u mjbright || die "Login failed"

echo; echo "---- push new image to DockerHub ----"
docker push mjbright/cv_resume_42 


