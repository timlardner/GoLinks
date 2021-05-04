import json

def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'text/html',
        },
        'body': r"""
        <head>
        <script>
            window.onload = function(){
                var params = (new URL(document.location)).searchParams;
                document.getElementById("form").elements["shortlink"].value = params.get("shortlink");
            }
        </script>
        </head>
        <body>
        <h1> Awesome shortlinking service </h1>
        <form method="POST" action="/create" id="form">
            <input type="text" name="shortlink" placeholder="Add shortlink here">
            <input type="text" name="target_url" placeholder="Add target URL here">
            <input type="submit" value="Create link">
        </form>
        </body>
        """
    }

