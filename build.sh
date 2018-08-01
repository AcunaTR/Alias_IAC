#!/bin/sh

CLEAN=false

function buildFail {
    echo "Maven build failed"
    if [ "$CLEAN" = true ] ; then
    	exit 0
    fi
    
	exit 1
}

function cleanUp {
	CLEAN=true
	docker system prune -af
}

trap cleanUp EXIT
trap buildFail ERR


CURDIR=`pwd`
VERSION=$(cat ./Code/version)
BUILD_VERSION=$VERSION.$GO_PIPELINE_COUNTER

docker run --rm \
           --env BUILD_VERSION=$BUILD_VERSION \
           -v "${CURDIR}/:/build" \
		   --user 498 \
           --workdir /build/Code \
           maven:3.5.2-jdk-8 mvn compile
           
		   
		   