import json
import boto3
import os
import uuid

s3 = boto3.client("s3")
BUCKET = os.environ["BUCKET_NAME"]

def lambda_handler(event, context):
    try:
        object_key = f"uploads/{uuid.uuid4()}"
        url = s3.generate_presigned_url(
            ClientMethod='put_object',
            Params={
                'Bucket': BUCKET,
                'Key': object_key,
                'ContentType': 'application/octet-stream'  # optional
            },
            ExpiresIn=3600
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'upload_url': url, 'object_key': object_key})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
