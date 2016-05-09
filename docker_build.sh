#!/bin/bash

die() {
    echo "$0: die - $*" >&2
    exit 1
}

#IMAGE_TAG=mjbright/alpine_cv_resume_42
#DOCKERFILE=Dockerfile.alpine
IMAGE_TAG=mjbright/cv_resume_42
DOCKERFILE=Dockerfile
DOCKERHUB_USER=mjbright

echo; echo "---- build image: ----"
#CMD="docker build -t $IMAGE_TAG ."
CMD="docker build -f $DOCKERFILE -t $IMAGE_TAG ."
echo $CMD
$CMD || die "Build failed"

echo; echo "---- login to DockerHub ----"
CMD="docker login -u $DOCKERHUB_USER"
echo $CMD
$CMD || die "Login failed"

echo; echo "---- push new image to DockerHub ----"
CMD="docker push $IMAGE_TAG"
echo $CMD
$CMD

