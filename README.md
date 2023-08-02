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
* [Git](https://github.com/git-guides/install-git)
* [Node 16 or greater](https://nodejs.org/en/download/)
* [Python version 3.9](https://www.python.org/downloads/)
* [Amplify CLI](https://aws-amplify.github.io/docs/cli-toolchain/quickstart#quickstart)

## Deploy the App

### Manual Deployment 
EC2 Dashboard manual deployment requires:

* Linux-based system
* Local copy of the GitHub repository
```sh
~ git clone https://github.com/okaushansky/ec2dashboard.git
~ cd ec2dashboard
```

In the root folder, there is a <b>deploy_params</b> file, which serves as an example of how to set up deployment parameters. The following parameters should be specified in this file:

* ACCESS_KEY_ID: AWS Access Key Id
* SECRET_ACCESS_KEY: AWS Secret Key Id
* REGION: Deployment region
* PROJECT_NAME: Deploy project name
* ENV_NAME: Deploy environment

To initiate the manual deployment, run the <b>deploy.sh</b> script from the root folder and provide the path to the configuration file as a parameter:
```sh
~ ./deploy.sh deploy_params
```

When prompted, select the defaults for the following options:
```sh
? Select the plugin module to execute: Hosting with Amplify Console (Managed hosting with custom domains, Continuous deployment)
? Choose a type: Manual Deployment
```

To create application users, follow these steps:
* Open the AWS Amplify Studio for the deployed application backend.
* Navigate to the <b>User Management</b> menu.
* Here, you can create and manage application users easily.

Alternatively, you can use the Cognito console to add users to your application:
* Go to the Cognito console.
* From the list of user pools, select the user pool with the name <PROJECT_NAME>-<ENV_NAME>.
* Within the selected user pool, you can add and manage users for your application.


### Amplify Automatic Deploy 
To automatically deploy the app, click the button below 👇

[![amplifybutton](https://oneclick.amplifyapp.com/button.svg)](https://console.aws.amazon.com/amplify/home#/deploy?repo=https://github.com/okaushansky/ec2dashboard)

*Note: if you don't have an [Amplify Service role](https://docs.aws.amazon.com/amplify/latest/userguide/how-to-service-role-amplify-console.html), you will need to create one.* 



