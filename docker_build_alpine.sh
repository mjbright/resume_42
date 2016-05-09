#!/bin/bash

die() {
    echo "$0: die - $*" >&2
    exit 1
}

echo; echo "---- build image: ----"
#CMD="docker build -t mjbright/cv_resume_42 ."
CMD="docker build -f Dockerfile.alpine -t mjbright/alpine_cv_resume_42"
echo $CMD
$CMD || die "Build failed"

echo; echo "---- login to DockerHub ----"
CMD="docker login -u mjbright"
echo $CMD
$CMD || die "Login failed"

echo; echo "---- push new image to DockerHub ----"
CMD="docker push mjbright/cv_resume_42 "
echo $CMD
$CMD

