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

existing_aliases=$(aws lambda list-aliases --function-name ${NAME}Dev --region ${REGION} --output json| jq -r '.Aliases[] | {Name: .Name}')

if [[ $existing_aliases == *"DEV"* ]]; then
   aws lambda update-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version "\$LATEST" --name DEV
else
   aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version "\$LATEST" --name DEV
fi

if [[ $existing_aliases == *"EAP"* ]]; then
   aws lambda update-alias --region ${REGION} --function-name ${NAME}Dev --description "eap" --function-version 1 --name EAP
else
   aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "eap" --function-version 1 --name EAP
fi

aws lambda publish-version --region ${REGION} --function-name ${NAME}Dev --description {$VERSION}

aws lambda update-function-code --region ${REGION} --function-name ${NAME}Dev --zip-file fileb://Code/target/Launcher-${BUILD_VERSION}.jar