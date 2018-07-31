#!/bin/sh

function deploySchemaFail {
    echo "S3 deploy failed"
	exit 1
}
trap deploySchemaFail ERR

if [ -f Code/schema.json ]; then
	aws s3 cp Code/schema.json s3://toucan-schemas-dev/${GO_PIPELINE_NAME}-schema.json
fi