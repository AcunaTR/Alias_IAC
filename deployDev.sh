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
alias = $2

existing_aliases=$(aws lambda list-aliases --function-name ${NAME}Dev --region ${REGION} --output json| jq -r '.Aliases[] | {Name: .Name}')

if [[ $existing_aliases == *"\"$alias\""* ]]
then
   aws lambda update-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version "\$LATEST" --name DEV
else
 aws lambda create-alias --region ${REGION} --function-name ${NAME}Dev --description "dev" --function-version "\$LATEST" --name DEV
fi


aws lambda update-function-code --region ${REGION} --function-name ${NAME}Dev --zip-file fileb://Code/target/Launcher-${BUILD_VERSION}.jar