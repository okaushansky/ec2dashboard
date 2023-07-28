# ec2dashboard

<h1>EC2 Dashboard</h1>
EC2 Dashboard is a simple web application hosted on AWS Amplify, allowing external users to view all active EC2 instances in the AWS infrastructure.

[<b>EC2 Dashboard Application</b>](https://release.d1x56yi7mlda3z.amplifyapp.com/)

<h4>Frontend</h4>
Users need to log in with their correct username and password. 
Frontend is a static React application with minimum functionality:
 - Showing the logged-in user's name and email.
 - Allowing users to sign out from their account.
 - Displaying a paged and sortable table of active EC2 instances from all AWS regions.
 - Allowing users to refresh the data to get the latest information.
Frontend code is located in <b>src/</b> folder.  
Frontend also could be run locally (yarn start) working with the hosted backend.

<h4>Backend Components</h4>
The backend components were implemented using AWS Amplify Console and Amplify CLI, and they include:
 - GraphQL API (amplify/api): Used to fetch data for the EC2 instances.
 - Python Lambda Function (amplify/function): Retrieves and processes data about active EC2 instances from all AWS regions.
 - Authentication (amplify/auth): Uses AWS Cognito user pools for user authentication.

<h4>Access and Authentication</h4>
Users need to log in with their correct username and password, authenticated by the appropriate user pool in AWS Cognito. Currently, there are two user groups: "Admins" and "Users." "Users" have view-only rights, and "Admins" have also the ability to create new users.
Currently, the user sign-up feature has been disabled at the user pool level to restrict new users from signing up independently. Sign-up tab on the login screen is disabled as well.
AWS administrators are responsible for creating user accounts. There are two users in the "Admins" group (admin1 and admin2) and two users in the "Users" group (user1 and user2).

<h4>CI/CD Pipeline</h4>
The application lifecycle is managed by the AWS Amplify Pipeline, which includes the execution of unit tests for the Lambda Function. Currently, the pipeline is connected to a specific AWS account, but with some adjustments, it can be deployed to any AWS account.
Amplify build file - amplify.yml.

The EC2 Dashboard repository have 2 branches: 
 - <b>main</b> for staging environment ([EC2 Dashboard Staging](https://main.d1x56yi7mlda3z.amplifyapp.com/))
 - <b>release</b> for production environment ([EC2 Dashboard Production](https://release.d1x56yi7mlda3z.amplifyapp.com/))

<h4>Unit Tests</h4>
Unit tests for the FetchEC2Instances Lambda Function are located in the amplify/backend/function/FetchEC2Instances/src/ directory. You can run these tests both locally and as part of the pipeline:
    python3 -m unittest test_lambda.py


[![amplifybutton](https://oneclick.amplifyapp.com/button.svg)](https://console.aws.amazon.com/amplify/home#/deploy?repo=https://github.com/username/repository)
