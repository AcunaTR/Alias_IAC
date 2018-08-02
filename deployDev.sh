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

lambda_version=$(aws lambda list-versions-by-function --function-name ${NAME}Dev --region ${REGION} --output json| jq -r ".Versions[] | select(.Version!=\"\$LATEST\") | select(.Description == \"${BUILD_VERSION}\").Version")
echo ------ $lambda_version --------

if [[ $existing_aliases == *"DEV"* ]]; then
   Alias_DEV = $(aws lambda update-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version 2  --name DEV~)
else
   Alias_DEV = $(aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version 2 --name DEV)
fi

echo "$Alias_DEV" >> file.txt
ls -al