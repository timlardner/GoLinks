import boto3
import botocore
from urllib import parse


def lambda_handler(event, context):
    # TODO implement
    
    qs = parse.parse_qs(event['queryStringParameters']['body'])
    shortlink = qs['shortlink'][0]
    target = qs['target_url'][0]
    
    if not target.startswith(('http://', 'https://')):
        return {
            'statusCode': 400,
            'body': 'You must provide a valid URL to link'
        }
        
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('tftest')
    try:
        table.put_item(
            Item={
                'url': target,
                'shortcode': shortlink.casefold(),
            },
            ConditionExpression='attribute_not_exists(shortcode)'
        )
    except botocore.exceptions.ClientError as e:
        # Ignore the ConditionalCheckFailedException, bubble up
        # other exceptions.
        if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
            return {
                'statusCode': 400,
                'body': f'Shortlink "{shortlink}" already exists in the database.'
             }
        
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'text/html',
        },
        'body': f"""
        <head>
        <meta http-equiv="refresh" content="5;url={target}" />
        </head>
        <body>
        <h1> Success </h1>
        </body>
        """
    }

