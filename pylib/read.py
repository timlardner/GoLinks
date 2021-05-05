import boto3
import json


def lambda_handler(event, context):
    with open('config.json', 'r') as f:
        config = json.load(f)
    shortlink = event.get('path', '/')[1:]
    if not shortlink:
        return {
            'statusCode': 302,
            'body': f"https://{config['DOMAIN']}/create"
        }
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(config['TABLE'])
    response = table.get_item(Key={'shortcode': shortlink.casefold()})
    if 'Item' in response:
        return {
            'statusCode': 302,
            'body': response['Item']['url']
        }
    else:
        return {
            'statusCode': 302,
            'body': f"https://{config['DOMAIN']}/create?shortlink={shortlink}"
        }
