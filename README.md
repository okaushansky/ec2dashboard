# EC2 Dashboard

EC2 Dashboard is a simple web application hosted on AWS Amplify, allowing external users to view all active EC2 instances in the AWS infrastructure.

[<b>EC2 Dashboard Application</b>](https://main.d1x56yi7mlda3z.amplifyapp.com/)


## Frontend
Users need to log in with their correct username and password. 
Frontend is a static React application with minimum functionality:
 - Showing the logged-in user's name and email.
 - Allowing users to sign out from their account.
 - Displaying a paged and sortable table of active EC2 instances from all AWS regions.
 - Allowing users to refresh the data to get the latest information.
Frontend code is located in <b>src/</b> folder.  
Frontend also could be run locally (<b>yarn start</b>) working with the hosted backend.

## Backend Components
The backend components were implemented using AWS Amplify Console and Amplify CLI, and they include:
 - GraphQL API (<b>amplify/api</b>): Used to fetch data for the EC2 instances.
 - Python Lambda Function (<b>amplify/function</b>): Retrieves and processes data about active EC2 instances from all AWS regions.
 - Authentication (<b>amplify/auth</b>): Uses AWS Cognito user pools for user authentication.


## Access and Authentication
Users need to log in with their correct username and password, authenticated by the appropriate user pool in AWS Cognito. Currently, there are two user groups: "Admins" and "Users." "Users" have view-only rights, and "Admins" have also the ability to create new users.
Currently, the user sign-up feature has been disabled at the user pool level to restrict new users from signing up independently. Sign-up tab on the login screen is disabled as well.
AWS administrators are responsible for creating user accounts. There are two users in the "Admins" group (admin1 and admin2) and two users in the "Users" group (user1 and user2).


## CI/CD Pipeline
The application lifecycle is managed by the AWS Amplify Pipeline, which includes the execution of unit tests for the Lambda Function. Currently, the pipeline is connected to a specific AWS account.
[EC2 Dashboard Staging](https://main.d1x56yi7mlda3z.amplifyapp.com/)
Amplify build file - <b>amplify.yml</b>.

## Unit Tests
Unit tests for the FetchEC2Instances Lambda Function are located in the amplify/backend/function/FetchEC2Instances/src/ directory. You can run these tests both locally and as part of the pipeline:
<b>python3 -m unittest test_lambda.py</b>

## Requirements
Before you deploy, you must have the following in place:

* [AWS Account](https://aws.amazon.com/account/)
* [Git](https://github.com/git-guides/install-git))
* [Node 16 or greater](https://nodejs.org/en/download/)
* [Python version 3.9](https://www.python.org/downloads/)
* [Amplify CLI installed and configured](https://aws-amplify.github.io/docs/cli-toolchain/quickstart#quickstart)

## Deploy the App

To automatically deploy the app, click the button below 👇

[![amplifybutton](https://oneclick.amplifyapp.com/button.svg)](https://console.aws.amazon.com/amplify/home#/deploy?repo=https://github.com/okaushansky/ec2dashboard.git)

*Note: if you don't have an Amplify Service role, you will need to create one.*


