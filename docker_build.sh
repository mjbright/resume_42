#!/bin/bash

# ./docker_build.sh --no-cache

DATE=$(date +%Y-%m-%d)
IMAGE_TAG_LATEST=mjbright/cv_resume_42:latest
IMAGE_TAG_DATED=mjbright/cv_resume_42:$DATE
DOCKERFILE=Dockerfile
DOCKERHUB_USER=mjbright


#IMAGE_TAG=mjbright/alpine_cv_resume_42
#DOCKERFILE=Dockerfile.alpine

die() {
    echo "$0: die - $*" >&2
    exit 1
}

press()
{
    [ ! -z "$1" ] && echo "$*"
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}


echo; echo "---- build image: ----"
#CMD="docker image build -t $IMAGE_TAG ."
CMD="docker image build $* -f $DOCKERFILE -t $IMAGE_TAG_LATEST ."
echo $CMD
$CMD || die "Build failed"

echo; echo "---- date tag image: ----"
CMD="docker image tag $IMAGE_TAG_LATEST $IMAGE_TAG_DATED"
echo $CMD
$CMD || die "Dated tag failed"

echo; press "About to login to Dockerhub"
#echo; echo "---- login to DockerHub ----"
CMD="docker login -u $DOCKERHUB_USER"
echo $CMD
$CMD || die "Login failed"

echo; echo "---- push new image to DockerHub ----"
CMD="docker image push $IMAGE_TAG_LATEST"
echo $CMD
$CMD
CMD="docker image push $IMAGE_TAG_DATED"
echo $CMD
$CMD


