#!/bin/sh

function deployTestsFail {
    echo "S3 Upload failed"
	exit 1
}
trap deployTestsFail ERR

if [ -d "Code/integration-tests" ]; then
    for filename in Code/integration-tests/*; do
	    aws s3 cp $filename s3://toucan-integration-tests/${GO_PIPELINE_NAME}/$(basename $filename)
    done
fi