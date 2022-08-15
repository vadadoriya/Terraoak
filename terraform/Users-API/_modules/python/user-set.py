

import boto3

def lambda_handler(event, context):
    ddbClient = boto3.resource('dynamodb')
    ddbTable = ddbClient.Table('Users')
    response = ddbTable.put_item(
        Item={
            'id': event['id'],
            'name': event['name'],
            'orgid': event['orgid'],
            'plan': event['plan'],
            'orgname': event['orgname'],
            'creationdate': event['creationdate']
        }
    )
    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': 'Record ' + event['id'] + ' Added'
    }