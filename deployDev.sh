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


aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version "\$LATEST" --name DEV
aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "beta" --function-version 1 --name BETA

aws lambda update-function-code --region ${REGION} --function-name ${NAME}Dev --zip-file fileb://Code/target/Launcher-${BUILD_VERSION}.jar