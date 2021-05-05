import boto3
import json


def lambda_handler(event, context):
    with open('config.json', 'r') as f:
        config = json.load(f)
    table = config['TABLE']
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table)
    
    x = sorted(table.scan()['Items'], key=lambda x: x['shortcode'])
    body = """
    <head>
    <style>
    table, th, td {
      border: 1px solid black;
      border-collapse: collapse;
    }
    </style>
    </head>
    <body>
    <h1> Registered Shortlinks </h1>
    
    <table style="width:100%">
      <tr>
        <th>Shortlink</th>
        <th>Target URL</th> 
      </tr>
    """
    for row in x:
        url = row['url']
        body += f"""
        <tr>
        <td>{row['shortcode']}</td>
        <td><a href="{url}">{url}</a></td>
        </tr>
        """
    body += """
    </table>
    </body>
    """
        
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'text/html',
        },
        'body': body
    }

