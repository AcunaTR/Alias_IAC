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

existing_aliases=$(aws lambda list-aliases --function-name ${NAME} --region ${REGION} --output json| jq -r '.Aliases[] | {Name: .Name}')


if [[ $existing_aliases == *"DEV"* ]]; then
  aws lambda update-alias --region ${REGION} --function-name ${NAME} --description "${NAME}" --function-version 2  --name DEV
else
   aws lambda create-alias --region ${REGION} --function-name ${NAME} --description "${NAME}" --function-version 2 --name DEV
fi

