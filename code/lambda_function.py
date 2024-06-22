import boto3
import os

# Initialize the DynamoDB and SNS clients
dynamodb = boto3.client('dynamodb')
sns = boto3.client('sns')

# Get environment variables
table_name = os.environ['DYNAMODB_TABLE']
sns_topic = os.environ['SNS_TOPIC']

# Lambda handler function
def handler(event, context):
    operation = event.get('operation') # Get the operation from the event
    if operation == 'create':
        create_item(event['data']) # Call create_item function
    elif operation == 'update':
        update_item(event['data']) # Call update_item function
    elif operation == 'delete':
        delete_item(event['data']) # Call delete_item function

    # Send a notification to the SNS topic
    sns.publish(
        TopicArn=sns_topic,
        Message=f"Operation {operation} completed successfully"
    )
    return {'status': 'success'}

# Function to create an item in the DynamoDB table
def create_item(data):
    dynamodb.put_item(TableName=table_name, Item=data)

# Function to update an item in the DynamoDB table
def update_item(data):
    dynamodb.update_item(TableName=table_name, Key={'ID': {'S': data['ID']}}, AttributeUpdates=data['attributes'])

# Function to delete an item from the DynamoDB table
def delete_item(data):
    dynamodb.delete_item(TableName=table_name, Key={'ID': {'S': data['ID']}})
