import boto3


def lambda_handler(event, context):
    shortlink = event.get('rawPath', '/')[1:]
    if not shortlink:
        return {
            'statusCode': 302,
            'body': 'https://golinks.intae.it/create'
        }
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('tftest')
    response = table.get_item(Key={'shortcode': shortlink.casefold()})
    if 'Item' in response:
        return {
            'statusCode': 302,
            'body': response['Item']['url']
        }
    else:
        return {
            'statusCode': 302,
            'body': f'https://golinks.intae.it/create?shortlink={shortlink}'
        }

