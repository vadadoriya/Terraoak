

import boto3

def lambda_handler(event, context):
    ddbClient = boto3.resource('dynamodb')
    ddbTable = ddbClient.Table('Users')
    response = ddbTable.put_item(
        Item={
            'id': int(event['queryStringParameters']['id']),
            'name': event['queryStringParameters']['name'],
            'orgid': event['queryStringParameters']['orgid'],
            'plan': event['queryStringParameters']['plan'],
            'orgname': event['queryStringParameters']['orgname'],
            'creationdate': int(event['queryStringParameters']['creationdate'])
        }
    )
    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': 'Record ' + str(event['queryStringParameters']['id']) + ' Added'
    }