#!/bin/sh

function deploySchemaFail {
    echo "Maven build failed"
	exit 1
}
trap deploySchemaFail ERR

if [ -f Code/schema.json ]; then
	aws s3 cp Code/schema.json s3://toucan-schemas/${GO_PIPELINE_NAME}-schema.json
fi