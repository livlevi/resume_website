import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    
    dynamodb = boto3.resource('dynamodb')
    visit_count_table = dynamodb.Table('siteVisitCounter')
    last_record_table = dynamodb.Table('siteLastRecordValue')

    # Retrieve the number corresponding to the last integer stored in the place holder database 
    
    last_rec_var = last_record_table.get_item(
        Key={
            'last_rec_id': 0
        }
    )

    # Assign this the place holder number to a variable
    
    last_record = last_rec_var['Item']['last_rec']
    
    # Using the place holder value, retrieve the key value pair that corresponsds to the current website count

    last_record = last_record + 1
    
    #    site_count = last_rec_var['Item']['las_rec']
    #    site_count = site_count + 1
    
    visit_count_table.put_item(
        Item={
            'visit_id': last_record,
            'visit_counter': last_record
            
        })
    
    last_record_table.put_item(
        Item={
            'last_rec_id': 0,
            'last_rec': last_record
        })
    
    return {
        'statusCode': 200,
        'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Methods': 'OPTIONS,POST',
                    'Access-Control-Allow-Headers': 'Origin, X-Api-Key, X-Requested-With, Content-Type, Accept, Authorization'

                },
        'body': "Your vist was added to dynamodb."
        }