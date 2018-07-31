#!/bin/sh

CLEAN=false

function buildFail {
    echo "Maven package failed"
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
trap packageFail ERR

CURDIR=`pwd`
VERSION=$(cat ./Code/version)
BUILD_VERSION=$VERSION.$GO_PIPELINE_COUNTER

mv ./Code/target/Launcher-1.0.28.jar ./Code/target/Launcher-$BUILD_VERSION.jar
