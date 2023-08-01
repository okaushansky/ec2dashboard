#!/usr/bin/env /bin/bash

set -euo pipefail
IFS='|'

# Get the absolute path of the running script
SCRIPT_SOURCE=$(readlink -f ${BASH_SOURCE[0]:=$0})
# Extract the directory part from the absolute path
SCRIPT_DIR=$(dirname ${SCRIPT_SOURCE})

PARAMS_SRC=${1:-deploy_params}

if [[ -f ${PARAMS_SRC} ]]; then
    . ${PARAMS_SRC}
else 
    echo "Parameters definition file ${PARAMS_SRC} not found. Please specify the correct one"
    exit 1
fi

echo " ===== Deploy ${PROJECT_NAME} to region ${REGION} and environment ${ENV_NAME} ====="

echo "*** Install prerequsites"
sudo npm install -g yarn
sudo yarn global add @aws-amplify/cli

# Define parameters for silent AWS Amplify project initialising
REACTCONFIG="{\
\"SourceDir\":\"src\",\
\"DistributionDir\":\"build\",\
\"BuildCommand\":\"yarn run build\",\
\"StartCommand\":\"yarn run start\"\
}"

AWSCLOUDFORMATIONCONFIG="{\
\"useProfile\":false,\
\"profileName\":\"default\",\
\"accessKeyId\":\"${ACCESS_KEY_ID}\",\
\"secretAccessKey\":\"${SECRET_ACCESS_KEY}\",\
\"region\":\"${REGION}\"\
}"

AMPLIFY="{\
\"projectName\":\"${PROJECT_NAME}\",\
\"envName\":\"${ENV_NAME}\",\
\"defaultEditor\":\"code\"\
}"

FRONTEND="{\
\"frontend\":\"javascript\",\
\"framework\":\"react\",\
\"config\":$REACTCONFIG\
}"

PROVIDERS="{\
\"awscloudformation\":$AWSCLOUDFORMATIONCONFIG\
}"


echo "*** Initialize Amplify project"

# Initialize Amplify project
amplify init \
--amplify ${AMPLIFY} \
--frontend ${FRONTEND} \
--providers ${PROVIDERS} \
--yes \
--json

# Extract the App ID using grep and awk
app_id=$(cat ${SCRIPT_DIR}/amplify/team-provider-info.json | jq .${ENV_NAME}.awscloudformation.AmplifyAppId)
echo "Created project with App ID '${app_id// }'"
# Check if the App ID is not empty
if [[ -z ${app_id// } ]]; then
    echo "Failed to get App ID. Amplify project initialization might have failed."
    exit 1
fi

# Needed to create aws-exports.js
amplify configure project \
--amplify $AMPLIFY \
--frontend $FRONTEND \
--providers $PROVIDERS \
--yes


echo -e "*** Configure hosting from repository ${GITHUB_REPO_URL} \nPlease select the defaults for the following prompts:\n \
- Hosting with Amplify Console (Managed hosting with custom domains, Continuous deployment)\n \
- Manual Deployment"

# Add hosting category to the Amplify project
amplify hosting add \
  --appId ${app_id} \
  --envName ${ENV_NAME} \
  --region ${REGION} \
  --repository ${GITHUB_REPO_URL}

# # Configure hosting with your GitHub repository
# amplify hosting configure \
#   --appId ${app_id} \
#   --envName ${ENV_NAME} \
#   --region ${REGION} \
#   --repository ${GITHUB_REPO_URL}

echo "*** Provision cloud resources"

# Provision cloud resources with the latest local changes 
amplify push --yes

# echo "*** Manual deploy"
# yarn install --frozen-lockfile
# amplify publish --yes