import json
import boto3
from datetime import datetime


def handler(event, context):
    print(f'*** FetchEC2Instances  --  event: {json.dumps(event, indent=2)} \ncontext: {context}')

    # Initialize the EC2 client
    ec2 = boto3.client('ec2')

    # Define the filters to get only running instances
    filters = [{'Name': 'instance-state-name', 'Values': ['running']}]

    instances = []
    try:
        # Get a list of all AWS regions
        ec2_regions = [region['RegionName'] for region in ec2.describe_regions().get('Regions', [])]
        print (f"* Regions: {ec2_regions}")

        for region in ec2_regions:
            # print (f"* Checking region  --  {region}")
            ec2_region = boto3.client('ec2', region_name=region)
            paginator = ec2_region.get_paginator('describe_instances')
            response_iterator = paginator.paginate(Filters=filters)
            for page in response_iterator:
                for reservation in page['Reservations']:
                    print (f"* Checking region = {region}, reservation = {reservation.get('ReservationId', '')}")
                    # instances.extend(reservation['Instances'])
                    for instance in reservation['Instances']:
                        instance_details = {
                            'id': instance['InstanceId'],
                            # 'ec2_id': instance['InstanceId'],
                            'name': next((tag['Value'] for tag in instance.get('Tags', []) if tag['Key'].lower() == 'name'), None),
                            # instance_name = [tag['Value'] for tag in instance['Tags'] if tag['Key'] == 'Name']
                            'type': instance['InstanceType'],
                            'state': instance['State']['Name'],
                            'az': instance['Placement']['AvailabilityZone'],
                            'privateIP': instance.get('PrivateIpAddress', ''),
                            'publicIP': instance.get('PublicIpAddress', ''),
                            'createdAt': instance['LaunchTime'].strftime('%Y-%m-%dT%H:%M:%SZ'),
                            'updatedAt': datetime.now().strftime('%Y-%m-%dT%H:%M:%SZ')
                            # Add any additional instance details you require
                        }
                        print (f"Instance {region}: {instance_details['id']}\n{instance_details}")
                        instances.append(instance_details)
        
        # Check if we need to sort instancies data
        if event and 'sortField' in event:
            sort_field = event.get('sortField', 'name')
            sort_direction = event.get('sortDirection', 'asc').upper()
            # Sort the instances by the specified field and direction
            instances = sorted(instances, key=lambda x: x[sort_field], reverse=(sort_direction == 'DESC'))
        
        # Check if we need to perform pagination
        if event and ('page' in event or 'perPage' in event) :
            # Perform pagination
            page = event.get('page', 1)
            per_page = event.get('perPage', 10)
            start = (page - 1) * per_page
            end = start + per_page
            paginated_instances = instances[start:end]
        else:
            paginated_instances = instances
        # print(f'RESULT: {paginated_instances}')
        
        # Prepare the response with paginated instances and the total count
        response = {
            'items': paginated_instances,
            'total': len(instances),
        }
        # print(f'FetchEC2Instances result:\n{response}')
        return response
    except Exception as ex:
        print(f"Error fetching EC2 instances: {ex}")
        raise Exception("Error fetching EC2 instances") from ex
     
  
# def handler(event, context):
#   print('received event:')
#   print(event)
  
#   return {
#       'statusCode': 200,
#       'headers': {
#           'Access-Control-Allow-Headers': '*',
#           'Access-Control-Allow-Origin': '*',
#           'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
#       },
#       'body': json.dumps('Hello from your new Amplify Python lambda!')
#   }
