#!/bin/sh

function deployFail {
    echo "Deploy to AWS Lambda failed"
	exit 1
}
trap deployFail ERR

CURDIR=`pwd`
NAME=$(cat ./Code/lambdaName)
VERSION=$(cat ./Code/version)
BUILD_VERSION=$VERSION.$GO_PIPELINE_COUNTER
build_number=$1

aws lambda update-function-code --region ${REGION} --function-name ${NAME}Dev --zip-file fileb://Code/target/Launcher-${BUILD_VERSION}.jar

aws lambda publish-version --region ${REGION} --function-name ${NAME}Dev --description ${BUILD_VERSION}

published_version