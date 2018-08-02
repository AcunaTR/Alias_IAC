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

aws lambda update-function-code --region ${REGION} --function-name ${NAME} --zip-file fileb://Code/target/Launcher-${BUILD_VERSION}.jar

OUTPUT=$(aws lambda publish-version --region ${REGION} --function-name ${NAME} --description ${BUILD_VERSION})

if [[ -e ${NAME}.txt ]]; then
   echo "${OUTPUT}" > $file
else
   file="${NAME}.txt"
   echo "${OUTPUT}" > $file
   ls -al
fi




