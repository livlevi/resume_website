import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    
    dynamodb = boto3.resource('dynamodb')
    visit_count_table = dynamodb.Table('siteVisitCounter')
    last_record_table = dynamodb.Table('siteLastRecordValue')
    
    last_record_var = last_record_table.get_item(
        Key={
            'last_rec_id': 0
        }
    )

    response = visit_count_table.get_item(
        Key={
            'visit_id': last_record_var['Item']['last_rec']
        }
    )
    json_response = response['Item']['visit_counter']
 
#    return last_record_var['Item']['last_record']   
    return {
        'statusCode': 200,
        'lastVisit': json_response,
        'body': "Retrieved last visit from dynamodb."
        }