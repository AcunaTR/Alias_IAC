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

if [[ $existing_aliases == *"UNUSED"* ]]; then
  aws lambda update-alias --region ${REGION} --function-name ${NAME}Dev --description "unused" --function-version 7  --name UNUSED
else
   aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "unused" --function-version 7 --name UNUSED
fi

OUTPUT=$(aws lambda get-alias --region ${REGION} --function-name ${NAME}Dev --name UNUSED) 
echo ------- $OUTPUT ---------
echo "${OUTPUT}" >> file.txt
ls -al