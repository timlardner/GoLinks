import boto3


def lambda_handler(event, context):
    shortlink = event.get('rawPath', '/')[1:]
    if not shortlink:
        return {
            'statusCode': 302,
            'body': 'https://go.intae.it/create'
        }
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('golinks')
    response = table.get_item(Key={'shortcode': shortlink.casefold()})
    if 'Item' in response:
        return {
            'statusCode': 302,
            'body': response['Item']['url']
        }
    else:
        return {
            'statusCode': 302,
            'body': f'https://go.intae.it/create?shortlink={shortlink}'
        }

