#!/usr/bin/env python
 
import boto3
import unittest
# from unittest.mock import MagicMock, patch

from moto import mock_ec2
from moto.core import DEFAULT_ACCOUNT_ID as ACCOUNT_ID

# Import lambda for testing
from index import handler as lambda_handler

## TEST DATA
EXAMPLE_AMI_ID = "ami-12c6146b"
US_REGION = "us-east-1"
EU_REGION = "eu-central-1"


class TestLambdaHandler(unittest.TestCase):
    def setUp(self):
        self.event = {}
        self.context = {}
       

    def runInstance(self, region, name, **kwargs):
        client = boto3.client("ec2", region_name=region)
        tagSpecifications = [
            {
                "ResourceType": "instance",
                'Tags': [{'Key': 'Name', 'Value': name}],
            }]
        instances = client.run_instances(ImageId=EXAMPLE_AMI_ID, MinCount=1, MaxCount=1,
                                         TagSpecifications=tagSpecifications, 
                                         **kwargs)
        return instances


    def createInstances(self, region, number, stopped=False):
        ec2_resource = boto3.resource('ec2', region_name=region)
        instances = ec2_resource.create_instances(ImageId=EXAMPLE_AMI_ID, MinCount=number, MaxCount=number)
        instance_ids = [instance.id for instance in instances]
        if stopped == True:
            client = boto3.client("ec2", region_name=region)
            client.stop_instances(InstanceIds=instance_ids)
        return instances
    
    
    @mock_ec2
    def test_fetch_ec2_instances_empty(self):
        # Test no EC2 running
        print('Test with EC2 instancies running')
        lambda_result = lambda_handler(None, None)
        self.assertEqual(lambda_result.get('total'), 0)

        self.createInstances(EU_REGION, 1, True)
        lambda_result = lambda_handler(None, None)
        self.assertEqual(lambda_result.get('total'), 0)


    @mock_ec2
    def test_fetch_ec2_instances(self):
        # Test EC2 instance running, check data consistency

        self.runInstance(US_REGION, 'Instance-1',
            InstanceType='t2.micro',
            Placement={'AvailabilityZone': 'us-east-1a'},
            PrivateIpAddress='192.168.4.5')
        response = lambda_handler(None, None)
        print(response)
        
        # Validate the response
        self.assertTrue('items' in response)
        self.assertTrue('total' in response)
        self.assertEqual(len(response['items']), 1)
        self.assertEqual(response['total'], 1)

        # Validate the details of the returned instance
        instance = response['items'][0]
        self.assertEqual(instance['name'], 'Instance-1')
        self.assertEqual(instance['type'], 't2.micro')
        self.assertEqual(instance['state'], 'running')
        self.assertEqual(instance['az'], 'us-east-1a')
        self.assertEqual(instance['privateIP'], '192.168.4.5')

        # Test 2 running EC2 instances and 2 stopped, using previous instance created
        print('Test with 2 EC2 instancies running and some stopped')
        # self.runInstance(US_REGION, 'Instance-1', PrivateIpAddress='192.168.4.5')
        self.runInstance(US_REGION, 'Instance-2', PrivateIpAddress='192.168.4.6')
        self.createInstances(EU_REGION, 2, True)

        response = lambda_handler(None, None)
        self.assertEqual(response.get('total'), 2)

        items = response.get('items')
        self.assertEqual(len(items), 2)

        names = [ i.get('name') for i in items ] 
        self.assertIn('Instance-1', names)
        self.assertIn('Instance-2', names)
        # print(f'***** {json.dumps(items, indent=2)}')
        instance1_ip = next((i.get('privateIP', '') for i in items if i.get('name') == 'Instance-1'), None)
        self.assertEqual(instance1_ip, '192.168.4.5')
        

    @mock_ec2
    def test_stress(self):
        # Test big number of EC2 instances running
        print('Stress Test')
        self.createInstances(EU_REGION, 2, True)
        self.createInstances(US_REGION, 510)
        self.createInstances(EU_REGION, 550)
        lambda_result = lambda_handler(None, None)
        self.assertEqual(lambda_result.get('total'), 1060)
        

    @mock_ec2
    def test_pagination(self):
        # Test pagination
        print('Test Pagination')
        self.createInstances(US_REGION, 20)
        self.createInstances(EU_REGION, 20)
        # Test second page with 10 items
        self.event = {'page': 2, 'perPage': 5}
        response = lambda_handler(self.event, self.context)
        self.assertEqual(len(response['items']), 5)
        self.assertEqual(response['total'], 40)

    
    # @patch('boto3.client')
    # def test_pagination(self, mock_client):
    #     # Mock the response from describe_regions
    #     mock_client.return_value.describe_regions.return_value = {
    #         'Regions': [
    #             {'RegionName': 'us-east-1'},
    #         ]
    #     }

    #     # Mock the response from describe_instances with 20 instances in us-east-1 region
    #     mock_client.return_value.describe_instances.return_value = {
    #         'Reservations': [
    #             {
    #                 'Instances': [
    #                     {
    #                         'InstanceId': f'i-{i}',
    #                         'Tags': [{'Key': 'Name', 'Value': f'Instance-{i}'}],
    #                         'InstanceType': 't2.micro',
    #                         'State': {'Name': 'running'},
    #                         'Placement': {'AvailabilityZone': 'us-east-1a'},
    #                         'PublicIpAddress': f'54.210.167.{i}',
    #                         'PrivateIpAddress': f'10.20.30.{i}',
    #                         'LaunchTime': '2023-07-19T12:34:56Z',
    #                     }
    #                     for i in range(1, 21)
    #                 ]
    #             }
    #         ]
    #     }

    #     # Test first page with 10 items
    #     self.event = {'page': 1, 'perPage': 10}
    #     response = lambda_handler(self.event, self.context)
    #     self.assertEqual(len(response['items']), 10)
    #     self.assertEqual(response['total'], 20)
    #     self.assertEqual(response['items'][0]['id'], 'i-1')
    #     self.assertEqual(response['items'][9]['id'], 'i-10')

    #     # Test second page with 10 items
    #     self.event = {'page': 2, 'perPage': 10}
    #     response = lambda_handler(self.event, self.context)
    #     self.assertEqual(len(response['items']), 10)
    #     self.assertEqual(response['total'], 20)
    #     self.assertEqual(response['items'][0]['id'], 'i-11')
    #     self.assertEqual(response['items'][9]['id'], 'i-20')

    #     # Test third page with 5 items (remaining instances)
    #     self.event = {'page': 3, 'perPage': 10}
    #     response = lambda_handler(self.event, self.context)
    #     self.assertEqual(len(response['items']), 5)
    #     self.assertEqual(response['total'], 20)
    #     self.assertEqual(response['items'][0]['id'], 'i-11')
    #     self.assertEqual(response['items'][4]['id'], 'i-15')
        

if __name__ == '__main__':
    unittest.main()