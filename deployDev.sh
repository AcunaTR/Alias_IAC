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


lambda_version=$(aws lambda list-versions-by-function --function-name ${NAME}Dev --region ${REGION} --output json|jq -r ".Versions[]| select(.Version!=\"\$LATEST\") | select(.Description == \"${build_number}\").Version")

aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version $lambda_version --name DEV

aws lambda update-function-code --region ${REGION} --function-name ${NAME}Dev --zip-file fileb://Code/target/Launcher-${BUILD_VERSION}.jar