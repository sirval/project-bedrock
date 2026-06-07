import json
import logging
import os
import urllib.parse

import boto3

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

S3 = boto3.client("s3")


def handler(event, context):
    processed = []
    bucket_from_env = os.environ.get("ASSET_BUCKET")

    for record in event.get("Records", []):
        bucket = record.get("s3", {}).get("bucket", {}).get("name", bucket_from_env)
        key = record.get("s3", {}).get("object", {}).get("key")

        if not bucket or not key:
            LOGGER.warning("Skipping malformed S3 event record: %s", record)
            continue

        decoded_key = urllib.parse.unquote_plus(key)
        LOGGER.info("Processing asset s3://%s/%s", bucket, decoded_key)

        S3.put_object_tagging(
            Bucket=bucket,
            Key=decoded_key,
            Tagging={
                "TagSet": [
                    {"Key": "processed", "Value": "true"},
                    {"Key": "processor", "Value": "asset_processor"},
                ]
            },
        )
        processed.append({"bucket": bucket, "key": decoded_key})

    return {
        "statusCode": 200,
        "body": json.dumps({"processed": processed}),
    }
