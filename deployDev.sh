#!/bin/sh

function deployFail {
    echo "Deploy to AWS Lambda failed"
	exit 1
}

function cleanUp {
	docker system prune -a
}

trap cleanUp EXIT
trap deployFail ERR

CURDIR=`pwd`
NAME=$(cat ./Code/lambdaName)
VERSION=$(cat ./Code/version)
BUILD_VERSION=$VERSION.$GO_PIPELINE_COUNTER
aws lambda update-function-code --region ${REGION} --function-name ${NAME}Dev --zip-file fileb://Code/target/Launcher-${BUILD_VERSION}.jar