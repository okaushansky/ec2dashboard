#!/usr/bin/env /bin/bash

set -eux
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

# Define parameters for silent AWS Amplify project initialising
REACTCONFIG="{\
\"SourceDir\":\"src\",\
\"DistributionDir\":\"dist\",\
\"BuildCommand\":\"yarn run-script build\",\
\"StartCommand\":\"yarn run-script start\"\
}"

AWSCLOUDFORMATIONCONFIG="{\
\"useProfile\":false,\
\"profileName\":\"default\",\
\"accessKeyId\":\"${ACCESS_KEY_ID}\",\
\"secretAccessKey\":\"${SECRET_ACCESS_KEY}\",\
\"region\":\"${REGION}\"\
}"

AMPLIFY="{\
\"projectName\":\"${PROGECT_NAME}\",\
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


# Initialize Amplify project


# Initialize Amplify project and capture the output
amplify init \
--amplify ${AMPLIFY} \
--frontend ${FRONTEND} \
--providers ${PROVIDERS} \
--yes \
--json

# Extract the App ID using grep and awk
app_id=$(cat ${SCRIPT_DIR}/amplify/team-provider-info.json | jq .${ENV_NAME}.awscloudformation.AmplifyAppId)

# Check if the App ID is not empty
if [[ -z ${app_id// } ]]; then
    echo "Failed to get App ID. Amplify project initialization might have failed."
    exit 1
fi

# # Install and activate Python virtual environment to avoid Lambda compilation errors
# echo "${SCRIPT_DIR}/amplify/backend/function/FetchEC2Instances/"
# cd ${SCRIPT_DIR}/amplify/backend/function/FetchEC2Instances/
# python3 -m venv venv
# source venv/bin/activate

# # Create the JSON content with the specified values
# json_content=$(cat <<EOF
# {
#   "envName": "${ENV_NAME}",
#   "appId": "${app_id// }",
#   "default": true
# }
# EOF
# )

echo "*** Configure hosting"

# # Save the JSON content to a file
# echo "${json_content}" > ${SCRIPT_DIR}/hosting-config.json
# echo "JSON configuration file '${SCRIPT_DIR}/hosting-config.json' has been created."

# # Import the hosting configuration
# amplify env import --config ${SCRIPT_DIR}/hosting-config.json

# # Checkout the new environment
# amplify env checkout ${ENV_NAME}

# # Configure the hosting settings (optional)
# amplify hosting configure

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

# Deploy the hosting environment
# amplify hosting publish \
#   --appId ${app_id} \
#   --region ${REGION}

# Provision cloud resources with the latest local changes 
amplify push --yes

amplify publish --yes